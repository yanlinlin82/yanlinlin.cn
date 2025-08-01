// Import Bootstrap JavaScript
import 'bootstrap';

// Import search functionality
const { setupSearch } = require('./search.js');

// 字体加载性能监控
function monitorFontLoading() {
  // 监控字体加载性能
  if ('fonts' in document) {
    document.fonts.ready.then(() => {
      console.log('字体加载完成');
      
      // 记录字体加载时间
      const fontLoadTime = performance.now();
      console.log(`字体加载耗时: ${fontLoadTime.toFixed(2)}ms`);
      
      // 如果字体加载时间过长，可以考虑优化
      if (fontLoadTime > 2000) {
        console.warn('字体加载时间较长，建议检查网络连接或使用本地字体');
      }
    });
  }
  
  // 监控字体回退情况
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
        const hasFallback = mutation.target.classList.contains('fonts-fallback');
        if (hasFallback) {
          console.log('已启用字体回退模式');
        }
      }
    });
  });
  
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ['class']
  });
}

// 页面加载完成后启动监控
document.addEventListener('DOMContentLoaded', monitorFontLoading);

// Constants
const WORDS_PER_MINUTE = 300;

// External link handling
function setupExternalLinks() {
  const externalLinks = document.querySelectorAll('main a[href^="http"], a.external-link');
  externalLinks.forEach(link => {
    link.classList.add('external-link');
    link.setAttribute('target', '_blank');
  });
}

// Calculate word count and reading time
function calculateArticleStats() {
  const articleStats = document.querySelector('.article-stats');
  if (!articleStats) return;

  const content = articleStats.getAttribute('data-content');
  if (!content) return;

  const chineseCount = (content.match(/[\u4e00-\u9fff\u3000-\u303f\uff00-\uffef]/g) || []).length;
  const englishCount = (content.match(/[a-zA-Z]+/g) || []).length;
  const totalCount = chineseCount + englishCount;

  if (totalCount > 0) {
    const wordCountElement = articleStats.querySelector('.word-count-number');
    const readingTimeElement = articleStats.querySelector('.reading-time-number');
    
    if (wordCountElement) wordCountElement.textContent = totalCount;
    if (readingTimeElement) {
      const readingTime = Math.max(1, Math.round(totalCount / WORDS_PER_MINUTE));
      readingTimeElement.textContent = readingTime;
    }
  }
}

// 返回顶部功能
function setupBackToTop() {
  const backToTopButton = document.getElementById('backToTop');
  if (!backToTopButton) return;

  const scrollThreshold = 300; // 滚动超过300px时显示按钮

  function toggleBackToTop() {
    if (window.scrollY > scrollThreshold) {
      backToTopButton.classList.add('show');
    } else {
      backToTopButton.classList.remove('show');
    }
  }

  function scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  }

  // 监听滚动事件
  window.addEventListener('scroll', toggleBackToTop, { passive: true });

  // 点击事件
  backToTopButton.addEventListener('click', scrollToTop);

  // 键盘事件支持
  backToTopButton.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      scrollToTop();
    }
  });
}

// 初始化所有功能
document.addEventListener('DOMContentLoaded', function() {
  setupExternalLinks();
  setupSearch();
  setupBackToTop();
  calculateArticleStats();
});
