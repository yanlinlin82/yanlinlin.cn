// Import Bootstrap JavaScript
import 'bootstrap';

// Import Fuse.js for search functionality
const Fuse = require('fuse.js');

// Constants
const SEARCH_MIN_LENGTH = 2;
const SEARCH_MAX_RESULTS = 10;
const WORDS_PER_MINUTE = 300;
const CONTENT_MAX_LENGTH = 200;

// External link handling
function setupExternalLinks() {
  const externalLinks = document.querySelectorAll('main a[href^="http"], a.external-link');
  externalLinks.forEach(link => {
    link.classList.add('external-link');
    link.setAttribute('target', '_blank');
  });
}

// HTML entity decoding
function decodeHtmlEntities(text) {
  return text
    .replace(/\\u([0-9a-fA-F]{4})/g, (_, hex) => String.fromCharCode(parseInt(hex, 16)))
    .replace(/&#(\d+);/g, (_, dec) => String.fromCharCode(parseInt(dec, 10)))
    .replace(/&#x([0-9a-fA-F]+);/gi, (_, hex) => String.fromCharCode(parseInt(hex, 16)))
    .replace(/&quot;/g, '"')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&apos;/g, "'")
    .replace(/&nbsp;/g, ' ')
    .replace(/<[^>]*>/g, '');
}

// Highlight matched text in search results
function highlightMatches(text, matches, key) {
  if (!matches) return text;
  
  matches.forEach(match => {
    if (match.key === key) {
      match.indices.forEach(([start, end]) => {
        const matchedText = text.substring(start, end + 1);
        text = text.replace(matchedText, `<mark>${matchedText}</mark>`);
      });
    }
  });
  
  return text;
}

// Process search result item
function processSearchResult(result) {
  const { item, matches } = result;
  
  // Clean URL and highlight title
  item.url = item.url.replace(/^["']|["']$/g, '');
  let title = highlightMatches(item.title, matches, 'title');
  
  // Process content with highlighting and decoding
  let content = '';
  if (item.summary) {
    content = highlightMatches(item.summary, matches, 'summary');
    content = decodeHtmlEntities(content).substring(0, CONTENT_MAX_LENGTH) + '...';
  }
  
  return { title, content, item };
}

// Generate search result HTML
function generateSearchResultHtml({ title, content, item }) {
  const tagsHtml = item.tags && Array.isArray(item.tags) && item.tags.length > 0
    ? `<div class="mb-2">${item.tags.map(tag => `<span class="badge bg-secondary me-1">${tag}</span>`).join('')}</div>`
    : '';
    
  return `
    <div class="search-result-item mb-3 p-3 border rounded">
      <h6 class="mb-1">
        <a href="${item.url}" class="text-decoration-none">${title}</a>
      </h6>
      <p class="text-muted small mb-1">${item.date}</p>
      <p class="mb-2">${content}</p>
      ${tagsHtml}
    </div>
  `;
}

// Perform search and update results
function performSearch(fuse, query, searchResults) {
  if (query.length < SEARCH_MIN_LENGTH) {
    searchResults.innerHTML = '<p class="text-muted">输入至少2个字符开始搜索...</p>';
    return;
  }

  const results = fuse.search(query);
  
  if (results.length === 0) {
    searchResults.innerHTML = '<p class="text-muted">没有找到相关结果</p>';
    return;
  }

  // Sort by date (newest first) and limit results
  const sortedResults = results
    .sort((a, b) => {
      const dateA = new Date(a.item.date.replace(/"/g, ''));
      const dateB = new Date(b.item.date.replace(/"/g, ''));
      return dateB - dateA;
    })
    .slice(0, SEARCH_MAX_RESULTS)
    .map(processSearchResult)
    .map(generateSearchResultHtml)
    .join('');

  searchResults.innerHTML = sortedResults;
}

// Setup search functionality
function setupSearch() {
  if (typeof window.searchIndex === 'undefined') return;

  const fuseOptions = {
    keys: ['title', 'summary', 'content', 'tags', 'categories'],
    threshold: 0.3,
    includeScore: true,
    includeMatches: true
  };

  const fuse = new Fuse(window.searchIndex, fuseOptions);
  const searchInput = document.getElementById('searchInput');
  const searchResults = document.getElementById('searchResults');
  const searchModal = document.getElementById('searchModal');

  if (!searchInput || !searchResults || !searchModal) return;

  // Search input handler
  searchInput.addEventListener('input', function() {
    performSearch(fuse, this.value.trim(), searchResults);
  });

  // Modal event handlers
  searchModal.addEventListener('shown.bs.modal', () => {
    setTimeout(() => searchInput.focus(), 100);
  });

  searchModal.addEventListener('hide.bs.modal', () => {
    searchInput.value = '';
    searchResults.innerHTML = '<p class="text-muted">输入至少2个字符开始搜索...</p>';
  });

  searchModal.addEventListener('hidden.bs.modal', () => {
    searchModal.removeAttribute('aria-hidden');
    const searchButton = document.querySelector('[data-bs-target="#searchModal"]');
    if (searchButton) searchButton.focus();
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
