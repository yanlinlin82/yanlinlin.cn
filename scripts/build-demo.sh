#!/bin/bash

echo "🚀 构建模式演示"
echo "=================="
echo ""

echo "1️⃣ 快速构建模式（不包含搜索索引）"
echo "   适用场景：CSS/JS样式调整"
echo "   命令：npm run hugo:fast:server"
echo "   特点：构建速度快，搜索功能禁用"
echo ""

echo "2️⃣ 完整构建模式（包含搜索索引）"
echo "   适用场景：添加新文章、内容更新"
echo "   命令：npm run hugo:full:server"
echo "   特点：功能完整，构建时间较长"
echo ""

echo "📋 使用建议："
echo "   • 日常样式调整 → 使用快速构建模式"
echo "   • 添加新文章 → 使用完整构建模式"
echo "   • 最终部署 → 使用完整构建模式"
echo ""

echo "🔧 技术实现："
echo "   • 快速构建：使用 hugo-fast.yaml 配置"
echo "   • 完整构建：使用默认 hugo.yaml 配置"
echo "   • 搜索索引：通过模板条件控制生成" 