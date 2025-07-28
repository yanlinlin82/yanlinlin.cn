# 字体加载优化策略

## 概述

为了提升国内用户的访问体验，我们实现了智能字体加载策略，能够根据网络环境自动选择合适的字体源。

## 优化策略

### 1. 网络环境检测

- **语言检测**: 检测浏览器语言设置
- **用户代理检测**: 识别中文系统环境
- **可访问性测试**: 测试Google Fonts是否可访问

### 2. 字体加载策略

#### 正常模式
- 优先加载Google Fonts
- 使用Inter、JetBrains Mono、Noto Sans SC等字体
- 提供最佳的中英文显示效果

#### 回退模式
- 当检测到国内网络且无法访问Google Fonts时启用
- 使用优化的系统字体栈
- 确保页面正常显示和良好体验

### 3. 字体栈优化

#### 中文无衬线字体
```
PingFang SC → Hiragino Sans GB → Microsoft YaHei → Helvetica Neue → Arial
```

#### 等宽字体
```
SF Mono → Monaco → Inconsolata → Roboto Mono → Source Code Pro → Menlo → Consolas
```

#### 中文衬线字体
```
Noto Serif SC → SimSun → STSong → STKaiti → KaiTi → FangSong
```

## 性能监控

### 加载时间监控
- 记录字体加载耗时
- 超过2秒时发出警告
- 在控制台输出详细日志

### 回退模式监控
- 监控字体回退触发情况
- 记录用户网络环境
- 提供优化建议

## 用户体验提升

### 1. 减少加载延迟
- 智能检测网络环境
- 避免长时间等待字体加载
- 提供即时可用的字体回退

### 2. 保持视觉一致性
- 精心设计的字体栈
- 确保中英文混排效果
- 保持代码显示质量

### 3. 渐进式增强
- 优先使用高质量字体
- 在无法访问时优雅降级
- 不影响页面功能

## 技术实现

### JavaScript检测逻辑
```javascript
// 检测国内网络环境
function isChineseNetwork() {
  return navigator.language.includes('zh') || 
         navigator.languages.some(lang => lang.includes('zh')) ||
         /cn|china|chinese/i.test(navigator.userAgent);
}

// 测试Google Fonts可访问性
function testGoogleFonts() {
  return new Promise((resolve) => {
    const testImg = new Image();
    testImg.onload = () => resolve(true);
    testImg.onerror = () => resolve(false);
    testImg.src = 'https://fonts.googleapis.com/favicon.ico';
    setTimeout(() => resolve(false), 3000);
  });
}
```

### CSS回退样式
```css
.fonts-fallback {
  --font-sans: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif;
  --font-mono: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', 'Source Code Pro', 'Menlo', 'Consolas', 'DejaVu Sans Mono', 'Courier New', monospace;
  --font-serif: 'Noto Serif SC', 'SimSun', 'STSong', 'STKaiti', 'KaiTi', 'FangSong', 'STFangsong', serif;
}
```

## 监控和维护

### 控制台日志
- 字体加载完成时间
- 回退模式启用情况
- 性能警告和建议

### 用户反馈
- 收集字体加载问题
- 优化检测算法
- 持续改进用户体验

## 未来优化方向

1. **本地字体缓存**: 考虑将常用字体本地化
2. **CDN优化**: 使用国内CDN加速字体加载
3. **字体子集**: 只加载必要的字符集
4. **预加载策略**: 优化字体预加载时机 