#!/usr/bin/env python3
"""Generate an article banner via Tencent Cloud's text-to-image API.

STATUS: not yet verified end to end. It was written without credentials and
without network access, so confirm SERVICE / ACTION / VERSION and the request
fields against the current API docs before relying on the result. (The 元宝 app
uses an internal service that is not callable with a normal cloud key; this
targets the public API instead.)

Credentials are read from the environment; never hardcode them:
    TENCENTCLOUD_SECRET_ID
    TENCENTCLOUD_SECRET_KEY
    TENCENTCLOUD_REGION        (optional, default: ap-guangzhou)

Example:
    TENCENTCLOUD_SECRET_ID=... TENCENTCLOUD_SECRET_KEY=... \
        python3 scripts/generate-banner.py \
            --prompt "深色科技风横幅，抽象账本格线，一束光沿对角线逐格点亮，画面无任何文字" \
            --negative-prompt "文字, 水印, 字母, 数字" \
            --resolution 1024:1024 \
            --out static/uploads/2026/1007/article-banner-ai.png

Notes:
  * Needs outbound HTTPS to the API host.
  * The API does not offer 1200x500; generate first, then crop, e.g.:
        magick IN.png -resize 1200x -gravity center -crop 1200x500+0+0 +repage OUT.png
  * This is a paid API. Check quota and billing, and whether sending the prompt
    to the provider is acceptable.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import hmac
import json
import os
import sys
import time
import urllib.error
import urllib.request

# --- Confirm these three against the current API docs before use. ------------
SERVICE = "hunyuan"
HOST = "hunyuan.tencentcloudapi.com"
ACTION = "TextToImage"
VERSION = "2023-09-01"


def _sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _hmac(key: bytes, msg: str) -> bytes:
    return hmac.new(key, msg.encode("utf-8"), hashlib.sha256).digest()


def _authorization(secret_id: str, secret_key: str, payload: bytes, ts: int) -> str:
    """Build the TC3-HMAC-SHA256 Authorization header."""
    date = time.strftime("%Y-%m-%d", time.gmtime(ts))
    canonical_headers = f"content-type:application/json\nhost:{HOST}\n"
    signed_headers = "content-type;host"
    canonical_request = "\n".join([
        "POST",
        "/",
        "",
        canonical_headers,
        signed_headers,
        _sha256_hex(payload),
    ])
    scope = f"{date}/{SERVICE}/tc3_request"
    string_to_sign = "\n".join([
        "TC3-HMAC-SHA256",
        str(ts),
        scope,
        _sha256_hex(canonical_request.encode("utf-8")),
    ])
    k_date = _hmac(f"TC3{secret_key}".encode("utf-8"), date)
    k_service = _hmac(k_date, SERVICE)
    k_signing = _hmac(k_service, "tc3_request")
    signature = hmac.new(k_signing, string_to_sign.encode("utf-8"), hashlib.sha256).hexdigest()
    return (
        f"TC3-HMAC-SHA256 Credential={secret_id}/{scope}, "
        f"SignedHeaders={signed_headers}, Signature={signature}"
    )


def _request(args: argparse.Namespace) -> dict:
    secret_id = os.environ.get("TENCENTCLOUD_SECRET_ID")
    secret_key = os.environ.get("TENCENTCLOUD_SECRET_KEY")
    if not secret_id or not secret_key:
        sys.exit("missing TENCENTCLOUD_SECRET_ID / TENCENTCLOUD_SECRET_KEY")

    body = {"Prompt": args.prompt, "Resolution": args.resolution, "LogoAdd": False}
    if args.negative_prompt:
        body["NegativePrompt"] = args.negative_prompt
    if args.style:
        body["Style"] = args.style
    if args.seed is not None:
        body["Seed"] = args.seed
    payload = json.dumps(body).encode("utf-8")

    ts = int(time.time())
    request = urllib.request.Request(
        f"https://{HOST}/",
        data=payload,
        method="POST",
        headers={
            "Authorization": _authorization(secret_id, secret_key, payload, ts),
            "Content-Type": "application/json",
            "Host": HOST,
            "X-TC-Action": ACTION,
            "X-TC-Version": VERSION,
            "X-TC-Timestamp": str(ts),
            "X-TC-Region": args.region,
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=args.timeout) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as err:
        sys.exit(f"HTTP {err.code}: {err.read().decode('utf-8', 'replace')}")


def _save(result: dict, out_path: str) -> None:
    response = result.get("Response", {})
    if "Error" in response:
        sys.exit(f"API error: {json.dumps(response['Error'], ensure_ascii=False)}")

    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    if response.get("ResultImage"):
        with open(out_path, "wb") as fh:
            fh.write(base64.b64decode(response["ResultImage"]))
    elif response.get("ResultImageUrl"):
        with urllib.request.urlopen(response["ResultImageUrl"], timeout=60) as resp, \
                open(out_path, "wb") as fh:
            fh.write(resp.read())
    else:
        sys.exit(f"unexpected response: {json.dumps(response, ensure_ascii=False)}")
    print(f"saved {out_path}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--prompt", required=True)
    parser.add_argument("--negative-prompt", default="")
    parser.add_argument("--style", default="")
    parser.add_argument("--resolution", default="1024:1024")
    parser.add_argument("--seed", type=int)
    parser.add_argument("--region", default=os.environ.get("TENCENTCLOUD_REGION", "ap-guangzhou"))
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    _save(_request(args), args.out)


if __name__ == "__main__":
    main()
