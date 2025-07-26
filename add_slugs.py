#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import yaml
from pathlib import Path

def generate_slug(title):
    """Generate a URL-friendly slug from a Chinese/English title"""
    # Remove common prefixes like "书评-", "《", "》"
    title = re.sub(r'^书评-', '', title)
    title = re.sub(r'^《', '', title)
    title = re.sub(r'》$', '', title)
    
    # Remove special characters and replace with hyphens
    slug = re.sub(r'[^\w\s-]', '', title)
    slug = re.sub(r'[-\s]+', '-', slug)
    slug = slug.strip('-')
    
    # Convert to lowercase
    slug = slug.lower()
    
    # Handle Chinese characters - keep them as is for now
    # (Hugo should handle Chinese slugs properly)
    
    return slug

def process_markdown_file(file_path):
    """Process a single markdown file to add slug if missing"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if file already has a slug
        if 'slug:' in content:
            print(f"✓ {file_path} already has slug")
            return False
        
        # Split frontmatter and body
        if not content.startswith('---'):
            print(f"⚠ {file_path} doesn't have frontmatter")
            return False
        
        parts = content.split('---', 2)
        if len(parts) < 3:
            print(f"⚠ {file_path} has malformed frontmatter")
            return False
        
        frontmatter_text = parts[1]
        body = parts[2]
        
        # Parse frontmatter
        try:
            frontmatter = yaml.safe_load(frontmatter_text)
        except yaml.YAMLError as e:
            print(f"⚠ {file_path} has invalid YAML: {e}")
            return False
        
        if not frontmatter or 'title' not in frontmatter:
            print(f"⚠ {file_path} missing title")
            return False
        
        title = frontmatter['title']
        slug = generate_slug(title)
        
        # Add slug to frontmatter
        frontmatter['slug'] = slug
        
        # Reconstruct the file
        new_frontmatter = yaml.dump(frontmatter, default_flow_style=False, allow_unicode=True, sort_keys=False)
        new_content = f"---\n{new_frontmatter}---{body}"
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"✓ {file_path} - added slug: {slug}")
        return True
        
    except Exception as e:
        print(f"✗ {file_path} - error: {e}")
        return False

def main():
    """Main function to process all markdown files"""
    posts_dir = Path('content/posts')
    
    if not posts_dir.exists():
        print("Error: content/posts directory not found")
        return
    
    # Find all markdown files
    markdown_files = list(posts_dir.rglob('*.md'))
    
    print(f"Found {len(markdown_files)} markdown files")
    print("Processing files...")
    print("-" * 50)
    
    processed_count = 0
    skipped_count = 0
    error_count = 0
    
    for file_path in markdown_files:
        # Skip _index.md files
        if file_path.name == '_index.md':
            continue
            
        result = process_markdown_file(file_path)
        if result is True:
            processed_count += 1
        elif result is False:
            skipped_count += 1
        else:
            error_count += 1
    
    print("-" * 50)
    print(f"Summary:")
    print(f"  Processed: {processed_count}")
    print(f"  Skipped: {skipped_count}")
    print(f"  Errors: {error_count}")

if __name__ == '__main__':
    main() 