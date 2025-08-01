#!/usr/bin/env python3
"""
图片链接检查脚本
检查网站和文章中的图片文件是否都正确引用且存在
"""

import os
import re
import sys
import glob
from pathlib import Path
from typing import List, Tuple, Set

# 颜色定义
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color

def log(message: str):
    print(f"{Colors.GREEN}[CHECK]{Colors.NC} {message}")

def warn(message: str):
    print(f"{Colors.YELLOW}[WARN]{Colors.NC} {message}")

def error(message: str):
    print(f"{Colors.RED}[ERROR]{Colors.NC} {message}")

def info(message: str):
    print(f"{Colors.BLUE}[INFO]{Colors.NC} {message}")

class ImageChecker:
    def __init__(self):
        self.total_images = 0
        self.missing_images = 0
        self.external_links = 0
        self.existing_images = []
        self.missing_images_list = []
        self.external_links_list = []
        
    def check_image_file(self, image_path: str, source_file: str, line_number: int) -> bool:
        """检查单个图片文件是否存在"""
        # 处理相对路径
        if image_path.startswith('/'):
            # 绝对路径，从static目录开始
            full_path = Path("static") / image_path.lstrip('/')
        else:
            # 相对路径
            full_path = Path(image_path)
        
        if full_path.exists():
            self.existing_images.append(f"✓ {image_path}")
            return True
        else:
            self.missing_images_list.append(f"✗ {image_path} (在 {source_file}:{line_number})")
            self.missing_images += 1
            return False
    
    def check_external_link(self, url: str, source_file: str, line_number: int):
        """检查外部链接"""
        self.external_links_list.append(f"🌐 {url} (在 {source_file}:{line_number})")
        self.external_links += 1
    
    def extract_images_from_file(self, file_path: str):
        """从文件中提取图片链接"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                for line_number, line in enumerate(f, 1):
                    # 匹配Markdown图片语法 ![alt](src)
                    md_pattern = r'!\[([^\]]*)\]\(([^)]+)\)'
                    for match in re.finditer(md_pattern, line):
                        image_src = match.group(2)
                        self.total_images += 1
                        
                        if re.match(r'^https?://', image_src):
                            self.check_external_link(image_src, file_path, line_number)
                        else:
                            self.check_image_file(image_src, file_path, line_number)
                    
                    # 匹配HTML img标签
                    html_pattern = r'src=["\']([^"\']+)["\']'
                    for match in re.finditer(html_pattern, line):
                        image_src = match.group(1)
                        self.total_images += 1
                        
                        if re.match(r'^https?://', image_src):
                            self.check_external_link(image_src, file_path, line_number)
                        else:
                            self.check_image_file(image_src, file_path, line_number)
        except Exception as e:
            warn(f"无法读取文件 {file_path}: {e}")
    
    def check_hugo_config_images(self):
        """检查Hugo配置文件中的图片"""
        log("检查Hugo配置文件中的图片...")
        
        config_files = ["hugo.yaml", "config.yaml"]
        for config_file in config_files:
            if os.path.exists(config_file):
                self.extract_images_from_file(config_file)
    
    def check_content_images(self):
        """检查文章内容中的图片"""
        log("检查文章内容中的图片...")
        
        # 查找所有Markdown文件
        for md_file in Path("content").rglob("*.md"):
            self.extract_images_from_file(str(md_file))
    
    def check_template_images(self):
        """检查模板文件中的图片"""
        log("检查模板文件中的图片...")
        
        # 查找所有HTML模板文件
        for html_file in Path("layouts").rglob("*.html"):
            self.extract_images_from_file(str(html_file))
    
    def check_css_images(self):
        """检查CSS文件中的图片"""
        log("检查CSS文件中的图片...")
        
        # 查找所有CSS文件
        css_dirs = ["static", "assets", "src"]
        for css_dir in css_dirs:
            if os.path.exists(css_dir):
                for css_file in Path(css_dir).rglob("*.css"):
                    self.extract_images_from_file(str(css_file))
                for scss_file in Path(css_dir).rglob("*.scss"):
                    self.extract_images_from_file(str(scss_file))
    
    def check_static_images(self):
        """检查静态文件目录"""
        log("检查静态文件目录...")
        
        # 统计static目录下的图片文件
        image_extensions = ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.svg", "*.webp"]
        static_images = 0
        
        if os.path.exists("static"):
            for ext in image_extensions:
                static_images += len(list(Path("static").rglob(ext)))
        
        info(f"静态文件目录中共有 {static_images} 个图片文件")
    
    def generate_report(self):
        """生成报告"""
        print()
        print("=" * 42)
        print("           图片链接检查报告")
        print("=" * 42)
        print()
        
        info(f"总计检查的图片链接: {self.total_images}")
        print()
        
        if self.existing_images:
            log("✅ 存在的图片文件:")
            for img in self.existing_images:
                print(f"  {img}")
            print()
        
        if self.missing_images_list:
            error(f"❌ 缺失的图片文件 ({self.missing_images} 个):")
            for img in self.missing_images_list:
                print(f"  {img}")
            print()
        
        if self.external_links_list:
            warn(f"🌐 外部图片链接 ({self.external_links} 个):")
            for link in self.external_links_list:
                print(f"  {link}")
            print()
        
        # 总结
        print("=" * 42)
        if self.missing_images == 0:
            log("🎉 所有图片文件都存在！")
        else:
            error(f"⚠️  发现 {self.missing_images} 个缺失的图片文件")
        
        if self.external_links > 0:
            warn(f"📡 发现 {self.external_links} 个外部图片链接")
        
        print("=" * 42)
    
    def run(self):
        """运行检查"""
        log("开始检查图片链接...")
        print()
        
        # 检查各种文件类型
        self.check_hugo_config_images()
        self.check_content_images()
        self.check_template_images()
        self.check_css_images()
        self.check_static_images()
        
        # 生成报告
        self.generate_report()
        
        # 返回状态码
        return 1 if self.missing_images > 0 else 0

def show_help():
    """显示帮助信息"""
    print("图片链接检查脚本")
    print()
    print("用法: python3 check-images.py [选项]")
    print()
    print("选项:")
    print("  -h, --help     显示此帮助信息")
    print()
    print("功能:")
    print("  检查网站和文章中的图片文件是否都正确引用且存在")
    print("  包括Markdown文件、HTML模板、CSS文件中的图片链接")
    print()
    print("检查范围:")
    print("  - content/ 目录下的所有Markdown文件")
    print("  - layouts/ 目录下的所有HTML模板")
    print("  - static/ 和 assets/ 目录下的CSS文件")
    print("  - Hugo配置文件")
    print()
    print("支持的图片格式:")
    print("  jpg, jpeg, png, gif, svg, webp")

def main():
    """主函数"""
    # 解析命令行参数
    if len(sys.argv) > 1:
        if sys.argv[1] in ['-h', '--help']:
            show_help()
            return 0
    
    # 运行检查
    checker = ImageChecker()
    return checker.run()

if __name__ == "__main__":
    sys.exit(main()) 