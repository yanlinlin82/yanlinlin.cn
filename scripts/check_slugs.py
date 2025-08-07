#!/usr/bin/env python3
"""
Hugo Slug Checker
检查Hugo项目中slug的完整性和唯一性
"""

import os
import re
import yaml
import argparse
from collections import defaultdict
from pathlib import Path

def extract_frontmatter(file_path):
    """从Markdown文件中提取frontmatter"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 匹配YAML frontmatter
        frontmatter_match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
        if frontmatter_match:
            frontmatter_text = frontmatter_match.group(1)
            try:
                return yaml.safe_load(frontmatter_text)
            except yaml.YAMLError as e:
                print(f"警告: 无法解析 {file_path} 的frontmatter: {e}")
                return None
        return None
    except Exception as e:
        print(f"错误: 无法读取文件 {file_path}: {e}")
        return None

def get_slug_from_frontmatter(frontmatter, file_path):
    """从frontmatter中获取slug"""
    if not frontmatter:
        return None
    
    # 直接检查slug字段
    if 'slug' in frontmatter:
        return frontmatter['slug']
    
    return None

def generate_slug_from_filename(file_path):
    """从文件名生成slug（用于显示建议）"""
    filename = Path(file_path).stem
    # 移除日期前缀 (YYYYMMDD-)
    if re.match(r'^\d{8}-', filename):
        filename = filename[9:]  # 移除前9个字符 (YYYYMMDD-)
    
    # 转换为slug格式
    slug = re.sub(r'[^\w\s-]', '', filename)  # 移除特殊字符
    slug = re.sub(r'[-\s]+', '-', slug)  # 将空格和多个连字符替换为单个连字符
    slug = slug.lower().strip('-')  # 转换为小写并移除首尾连字符
    
    return slug

def check_slugs(content_dir):
    """检查slug的完整性和唯一性"""
    slug_files = defaultdict(list)
    files_without_slug = []
    files_with_invalid_frontmatter = []
    
    # 遍历所有Markdown文件
    for root, dirs, files in os.walk(content_dir):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                frontmatter = extract_frontmatter(file_path)
                
                if frontmatter:
                    slug = get_slug_from_frontmatter(frontmatter, file_path)
                    if slug:
                        slug_files[slug].append(file_path)
                    else:
                        # 检查是否是_index文件（这些通常不需要slug）
                        if not file.startswith('_index'):
                            files_without_slug.append(file_path)
                else:
                    if not file.startswith('_index'):
                        files_with_invalid_frontmatter.append(file_path)
    
    # 检查重复
    duplicates = {slug: files for slug, files in slug_files.items() if len(files) > 1}
    
    return duplicates, files_without_slug, files_with_invalid_frontmatter, slug_files

def main():
    parser = argparse.ArgumentParser(description='检查Hugo项目中slug的完整性和唯一性')
    parser.add_argument('--content-dir', default='content', help='内容目录路径 (默认: content)')
    parser.add_argument('--verbose', '-v', action='store_true', help='显示详细信息')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.content_dir):
        print(f"错误: 内容目录 '{args.content_dir}' 不存在")
        return 1
    
    print(f"正在检查目录: {args.content_dir}")
    print("-" * 50)
    
    duplicates, files_without_slug, files_with_invalid_frontmatter, all_slugs = check_slugs(args.content_dir)
    
    has_issues = False
    
    # 显示重复的slug
    if duplicates:
        has_issues = True
        print(f"❌ 发现 {len(duplicates)} 个重复的slug:")
        print()
        for slug, files in duplicates.items():
            print(f"重复slug: '{slug}'")
            for file_path in files:
                print(f"  - {file_path}")
            print()
    
    # 显示没有slug的文件
    if files_without_slug:
        has_issues = True
        print(f"⚠️  发现 {len(files_without_slug)} 个文件没有设置slug:")
        print()
        for file_path in files_without_slug:
            suggested_slug = generate_slug_from_filename(file_path)
            print(f"文件: {file_path}")
            print(f"建议slug: {suggested_slug}")
            print()
    
    # 显示frontmatter无效的文件
    if files_with_invalid_frontmatter:
        has_issues = True
        print(f"❌ 发现 {len(files_with_invalid_frontmatter)} 个文件的frontmatter无效:")
        print()
        for file_path in files_with_invalid_frontmatter:
            print(f"  - {file_path}")
        print()
    
    # 显示统计信息
    if args.verbose:
        print(f"统计信息:")
        print(f"  总文件数: {len(all_slugs)}")
        print(f"  唯一slug数: {len(all_slugs)}")
        print(f"  重复slug数: {len(duplicates)}")
        print(f"  无slug文件数: {len(files_without_slug)}")
        print(f"  frontmatter无效文件数: {len(files_with_invalid_frontmatter)}")
    
    # 显示总结
    if not has_issues:
        print("✅ 所有slug检查通过！")
        print("  - 没有重复的slug")
        print("  - 所有文章都设置了slug")
        print("  - 所有frontmatter格式正确")
    else:
        print("\n📝 处理建议:")
        if duplicates:
            print("  - 重复的slug需要手动修改，确保每个slug唯一")
        if files_without_slug:
            print("  - 没有slug的文件需要手动添加slug字段")
        if files_with_invalid_frontmatter:
            print("  - frontmatter无效的文件需要检查YAML格式")
    
    return 0 if not has_issues else 1

if __name__ == '__main__':
    exit(main())
