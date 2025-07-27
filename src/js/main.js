// Import Bootstrap JavaScript
import 'bootstrap';

// Import Fuse.js for search functionality
const Fuse = require('fuse.js');

// Custom JavaScript
document.addEventListener('DOMContentLoaded', function() {
  // Add external link indicators
  const externalLinks = document.querySelectorAll('main a[href^="http"]');
  externalLinks.forEach(function(link) {
    link.classList.add('external-link');
    link.setAttribute('target', '_blank');
  });

  // Add external link indicators for existing external-link class
  const existingExternalLinks = document.querySelectorAll('a.external-link');
  existingExternalLinks.forEach(function(link) {
    link.setAttribute('target', '_blank');
  });

  // Initialize search functionality
  if (typeof window.searchIndex !== 'undefined') {
    const fuseOptions = {
      keys: ['title', 'summary', 'content', 'tags', 'categories'],
      threshold: 0.3,
      includeScore: true,
      includeMatches: true
    };

    const fuse = new Fuse(window.searchIndex, fuseOptions);

    // Search functionality
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');
    const searchModal = document.getElementById('searchModal');

    if (searchInput && searchResults && searchModal) {
      searchInput.addEventListener('input', function() {
        const query = this.value.trim();

        if (query.length < 2) {
          searchResults.innerHTML = '<p class="text-muted">输入至少2个字符开始搜索...</p>';
          return;
        }

        const results = fuse.search(query);

        if (results.length === 0) {
          searchResults.innerHTML = '<p class="text-muted">没有找到相关结果</p>';
          return;
        }

        // 按日期从新到旧排序，然后限制结果数量
        const sortedResults = results
          .sort((a, b) => {
            const dateA = new Date(a.item.date.replace(/"/g, ''));
            const dateB = new Date(b.item.date.replace(/"/g, ''));
            return dateB - dateA; // 从新到旧排序
          })
          .slice(0, 10); // Limit to 10 results

        const resultsHtml = sortedResults.map(result => {
          const item = result.item;
          const score = result.score;
          const matches = result.matches;

          // Highlight matched text
          let title = item.title;

          // 清理URL，去掉可能的引号包裹
          item.url = item.url.replace(/^["']|["']$/g, '');

          // 先进行高亮处理（在解码HTML实体之前）
          if (matches) {
            matches.forEach(match => {
              if (match.key === 'title') {
                match.indices.forEach(([start, end]) => {
                  const matchedText = title.substring(start, end + 1);
                  title = title.replace(matchedText, `<mark>${matchedText}</mark>`);
                });
              } else if (match.key === 'summary' || match.key === 'content') {
                // 对摘要和内容进行高亮处理
                const originalContent = item.summary || '';
                match.indices.forEach(([start, end]) => {
                  const matchedText = originalContent.substring(start, end + 1);
                  // 在原始内容中替换匹配的文本
                  item.summary = item.summary.replace(matchedText, `<mark>${matchedText}</mark>`);
                });
              }
            });
          }

          // 解码HTML实体并移除HTML标签（在高亮处理之后）
          let content = item.summary ?
            item.summary
              // 解码Unicode转义序列
              .replace(/\\u([0-9a-fA-F]{4})/g, (match, hex) => String.fromCharCode(parseInt(hex, 16)))
              // 解码HTML数字实体
              .replace(/&#(\d+);/g, (match, dec) => String.fromCharCode(parseInt(dec, 10)))
              // 解码HTML十六进制实体
              .replace(/&#x([0-9a-fA-F]+);/gi, (match, hex) => String.fromCharCode(parseInt(hex, 16)))
              // 解码常见的HTML实体
              .replace(/&quot;/g, '"')
              .replace(/&amp;/g, '&')
              .replace(/&lt;/g, '<')
              .replace(/&gt;/g, '>')
              .replace(/&apos;/g, "'")
              .replace(/&nbsp;/g, ' ')
              // 移除HTML标签
              .replace(/<[^>]*>/g, '')
              .substring(0, 200) + '...' : '';



          return `
            <div class="search-result-item mb-3 p-3 border rounded">
              <h6 class="mb-1">
                <a href="${item.url}" class="text-decoration-none">${title}</a>
              </h6>
              <p class="text-muted small mb-1">${item.date}</p>
              <p class="mb-2">${content}</p>
              ${item.tags && Array.isArray(item.tags) && item.tags.length > 0 ?
                `<div class="mb-2">
                  ${item.tags.map(tag => `<span class="badge bg-secondary me-1">${tag}</span>`).join('')}
                </div>` : ''
              }
            </div>
          `;
        }).join('');

        searchResults.innerHTML = resultsHtml;
      });

      // 搜索框自动聚焦和焦点管理
      searchModal.addEventListener('shown.bs.modal', function() {
        // 模态框显示后自动聚焦到输入框
        setTimeout(() => {
          searchInput.focus();
        }, 100);
      });

      searchModal.addEventListener('hide.bs.modal', function() {
        // 模态框关闭前清除输入框内容
        searchInput.value = '';
        searchResults.innerHTML = '<p class="text-muted">输入至少2个字符开始搜索...</p>';
      });

      searchModal.addEventListener('hidden.bs.modal', function() {
        // 模态框完全关闭后，移除aria-hidden属性以避免可访问性错误
        searchModal.removeAttribute('aria-hidden');
        // 将焦点返回到触发搜索框的元素
        const searchButton = document.querySelector('[data-bs-target="#searchModal"]');
        if (searchButton) {
          searchButton.focus();
        }
      });
    }
  }

  // 中文字数统计功能
  const articleStats = document.querySelector('.article-stats');
  if (articleStats) {
    const content = articleStats.getAttribute('data-content');
    if (content) {
      // 计算中文字符数（包括中文标点符号）
      const chineseChars = content.match(/[\u4e00-\u9fff\u3000-\u303f\uff00-\uffef]/g);
      const chineseCount = chineseChars ? chineseChars.length : 0;

      // 计算英文字符数
      const englishWords = content.match(/[a-zA-Z]+/g);
      const englishCount = englishWords ? englishWords.length : 0;

      // 总字数 = 中文字符数 + 英文字符数
      const totalCount = chineseCount + englishCount;

      // 更新字数显示
      const wordCountNumber = articleStats.querySelector('.word-count-number');
      if (wordCountNumber && totalCount > 0) {
        wordCountNumber.textContent = totalCount;
      }

      // 更新阅读时间（按每分钟300字计算）
      const readingTimeNumber = articleStats.querySelector('.reading-time-number');
      if (readingTimeNumber && totalCount > 0) {
        const readingTime = Math.max(1, Math.round(totalCount / 300));
        readingTimeNumber.textContent = readingTime;
      }
    }
  }
});
