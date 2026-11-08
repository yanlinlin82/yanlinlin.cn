// Import Bootstrap JavaScript
import "bootstrap";

// Import search functionality
const { setupSearch } = require("./search.js");

// Import calendar page functionality
const { setupCalendar } = require("./calendar.js");

// Constants
const WORDS_PER_MINUTE = 300;

// Calculate word count and reading time
function calculateArticleStats() {
  const articleStats = document.querySelector(".article-stats");
  if (!articleStats) return;

  const wordCountAttr = articleStats.getAttribute("data-word-count");
  if (!wordCountAttr) return;

  const totalCount = parseInt(wordCountAttr, 10);
  if (totalCount > 0) {
    const wordCountElement = articleStats.querySelector(".word-count-number");
    const readingTimeElement = articleStats.querySelector(
      ".reading-time-number",
    );

    if (wordCountElement) wordCountElement.textContent = totalCount;
    if (readingTimeElement) {
      const readingTime = Math.max(
        1,
        Math.round(totalCount / WORDS_PER_MINUTE),
      );
      readingTimeElement.textContent = readingTime;
    }
  }
}

// 返回顶部功能
function setupBackToTop() {
  const backToTopButton = document.getElementById("backToTop");
  if (!backToTopButton) return;

  const scrollThreshold = 300; // 滚动超过300px时显示按钮

  function toggleBackToTop() {
    if (window.scrollY > scrollThreshold) {
      backToTopButton.classList.add("show");
    } else {
      backToTopButton.classList.remove("show");
    }
  }

  function scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  }

  // 监听滚动事件
  window.addEventListener("scroll", toggleBackToTop, { passive: true });

  // 点击事件
  backToTopButton.addEventListener("click", scrollToTop);

  // 键盘事件支持
  backToTopButton.addEventListener("keydown", (e) => {
    if (e.key === "Enter" || e.key === " ") {
      e.preventDefault();
      scrollToTop();
    }
  });
}

// =============================================================================
// 主题切换
// =============================================================================
function getPreferredTheme() {
  var saved = localStorage.getItem("theme");
  if (saved === "light" || saved === "dark") {
    return saved;
  }
  return "system";
}

function getSystemTheme() {
  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light";
}

function getResolvedTheme() {
  var pref = getPreferredTheme();
  return pref === "system" ? getSystemTheme() : pref;
}

function applyTheme(theme) {
  var html = document.documentElement;
  // Remove both theme classes
  html.classList.remove("theme-light", "theme-dark");
  // If not 'system', add the explicit theme class
  if (theme !== "system") {
    html.classList.add("theme-" + theme);
  }
}

function updateToggleUI(theme) {
  var icon = document.querySelector("#themeToggle .theme-icon i");
  var label = document.getElementById("themeLabel");
  if (!icon || !label) return;

  // Reset icon classes
  icon.className = "fas";

  switch (theme) {
    case "light":
      icon.classList.add("fa-sun");
      label.textContent = "\u5fae\u4eae";
      break;
    case "dark":
      icon.classList.add("fa-moon");
      label.textContent = "\u6df1\u8272";
      break;
    default:
      icon.classList.add("fa-circle-half-stroke");
      label.textContent = "\u7cfb\u7edf";
      break;
  }
}

function setTheme(theme) {
  localStorage.setItem("theme", theme === "system" ? "" : theme);
  applyTheme(theme);
  updateToggleUI(theme);
}

function cycleTheme() {
  var current = getPreferredTheme();
  var next =
    current === "system" ? "light" : current === "light" ? "dark" : "system";
  setTheme(next);
}

function setupThemeToggle() {
  var toggle = document.getElementById("themeToggle");
  if (!toggle) return;

  // Apply saved theme on load
  var saved = getPreferredTheme();
  applyTheme(saved);
  updateToggleUI(saved);

  // Listen for system preference changes (only relevant in 'system' mode)
  var mq = window.matchMedia("(prefers-color-scheme: dark)");
  mq.addEventListener("change", function () {
    if (getPreferredTheme() === "system") {
      applyTheme("system");
    }
  });

  // Click handler
  toggle.addEventListener("click", cycleTheme);
}

// Floating TOC sidebar
function setupTocFloat() {
  var toc = document.getElementById("tocFloat");
  var toggleBtn = document.getElementById("tocToggleBtn");
  var closeBtn = document.getElementById("tocCloseBtn");
  if (!toc) return;

  var visible = true;

  function show() {
    visible = true;
    toc.classList.remove("toc-float-hidden");
    if (toggleBtn) toggleBtn.classList.add("btn-toc-toggle-hidden");
  }

  function hide() {
    visible = false;
    toc.classList.add("toc-float-hidden");
    if (toggleBtn) toggleBtn.classList.remove("btn-toc-toggle-hidden");
  }

  if (toggleBtn) {
    toggleBtn.addEventListener("click", show);
  }
  if (closeBtn) {
    closeBtn.addEventListener("click", hide);
  }

  // Gather headings and TOC links
  var headings = document.querySelectorAll(
    ".article-body h2, .article-body h3",
  );
  if (headings.length === 0) return;

  var tocLinks = toc.querySelectorAll("a");
  if (tocLinks.length === 0) return;

  // Build id -> link map
  var linkMap = {};
  tocLinks.forEach(function (link) {
    var href = link.getAttribute("href");
    if (href && href.startsWith("#")) {
      linkMap[href.substring(1)] = link;
    }
  });

  // Smooth scroll to heading on TOC link click
  tocLinks.forEach(function (link) {
    link.addEventListener("click", function (e) {
      var href = link.getAttribute("href");
      if (href && href.startsWith("#")) {
        e.preventDefault();
        var target = document.getElementById(href.substring(1));
        if (target) {
          target.scrollIntoView({ behavior: "smooth" });
        }
      }
    });
  });

  // Update active heading based on scroll position
  function updateActive() {
    var scrollTop = window.scrollY + 120; // offset for fixed navbar
    var activeId = null;

    for (var i = 0; i < headings.length; i++) {
      var h = headings[i];
      if (h.offsetTop <= scrollTop) {
        activeId = h.getAttribute("id");
      } else {
        break;
      }
    }

    tocLinks.forEach(function (link) {
      link.classList.remove("active");
    });

    if (activeId && linkMap[activeId]) {
      linkMap[activeId].classList.add("active");
      // Scroll active link into view within the TOC panel
      linkMap[activeId].scrollIntoView({ block: "nearest" });
    }
  }

  updateActive();
  window.addEventListener("scroll", updateActive, { passive: true });
}

// 代码块：复制到剪贴板
function setupCodeCopy() {
  var blocks = document.querySelectorAll(".code-block");
  if (!blocks.length) return;

  Array.prototype.forEach.call(blocks, function (block) {
    var button = block.querySelector(".code-copy");
    var source = block.querySelector("template.code-source");
    if (!button || !source) return;

    var label = button.querySelector(".code-copy-text");
    var icon = button.querySelector("i");
    var idleText = button.getAttribute("data-label-copy") || "复制";
    var doneText = button.getAttribute("data-label-done") || "已复制";
    var failText = button.getAttribute("data-label-fail") || "复制失败";
    var timer = null;

    function reset() {
      if (label) label.textContent = idleText;
      if (icon) icon.className = "fas fa-copy";
      button.classList.remove("is-done");
    }

    function flash(text, ok) {
      if (label) label.textContent = text;
      if (icon) icon.className = ok ? "fas fa-check" : "fas fa-triangle-exclamation";
      button.classList.toggle("is-done", ok);
      if (timer) clearTimeout(timer);
      timer = setTimeout(reset, 1600);
    }

    function fallbackCopy(text) {
      return new Promise(function (resolve, reject) {
        var area = document.createElement("textarea");
        area.value = text;
        area.setAttribute("readonly", "");
        area.style.position = "fixed";
        area.style.top = "-1000px";
        area.style.opacity = "0";
        document.body.appendChild(area);
        area.select();
        try {
          resolve(document.execCommand("copy"));
        } catch (err) {
          reject(err);
        } finally {
          document.body.removeChild(area);
        }
      });
    }

    function copy(text) {
      if (navigator.clipboard && window.isSecureContext) {
        return navigator.clipboard.writeText(text);
      }
      return fallbackCopy(text);
    }

    button.addEventListener("click", function () {
      var text = source.content
        ? source.content.textContent
        : source.textContent;
      copy(text.replace(/\n$/, ""))
        .then(function () {
          flash(doneText, true);
        })
        .catch(function () {
          flash(failText, false);
        });
    });
  });
}

// 代码块：折行开关（状态记在 localStorage，跨页面生效）
function setupCodeWrap() {
  var toggles = document.querySelectorAll(".code-wrap-toggle");
  if (!toggles.length) return;

  var html = document.documentElement;
  var enabled = localStorage.getItem("codeWrap") === "on";

  function apply(on) {
    html.classList.toggle("code-wrap", on);
    Array.prototype.forEach.call(toggles, function (btn) {
      btn.setAttribute("aria-pressed", on ? "true" : "false");
    });
  }

  apply(enabled);

  Array.prototype.forEach.call(toggles, function (btn) {
    btn.addEventListener("click", function () {
      enabled = !html.classList.contains("code-wrap");
      localStorage.setItem("codeWrap", enabled ? "on" : "off");
      apply(enabled);
    });
  });
}

// 初始化所有功能
document.addEventListener("DOMContentLoaded", function () {
  setupSearch();
  setupBackToTop();
  calculateArticleStats();
  setupThemeToggle();
  setupTocFloat();
  setupCalendar();
  setupCodeCopy();
  setupCodeWrap();
});
