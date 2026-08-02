// Import Fuse.js for search functionality
const Fuse = require('fuse.js');

// Constants
const SEARCH_MIN_LENGTH = 2;
const SEARCH_MAX_RESULTS = 10;
const CONTENT_MAX_LENGTH = 200;

// Decode HTML entities
function decodeHtmlEntities(text) {
  const textarea = document.createElement('textarea');
  textarea.innerHTML = text;
  return textarea.value;
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
  const searchInput = document.getElementById('searchInput');
  const searchResults = document.getElementById('searchResults');
  const searchModal = document.getElementById('searchModal');

  if (!searchInput || !searchResults || !searchModal) return;

  let fuse = null;
  let searchInitialized = false;
  let indexLoading = false;

  // Initialize search when index is loaded
  function initializeSearch() {
    if (searchInitialized || !window.searchIndexLoaded || !window.searchIndex || window.searchIndex.length === 0) {
      return;
    }

    const fuseOptions = {
      keys: ['title', 'summary', 'content', 'tags', 'categories'],
      threshold: 0.3,
      includeScore: true,
      includeMatches: true
    };

    fuse = new Fuse(window.searchIndex, fuseOptions);
    searchInitialized = true;
    console.log('搜索功能初始化完成');
  }

  // Lazily load the external search index on first use
  function loadSearchIndex() {
    if (indexLoading || searchInitialized) return;
    if (window.searchIndexDisabled) {
      searchResults.innerHTML = '<p class="text-muted">搜索暂不可用</p>';
      return;
    }
    indexLoading = true;
    searchResults.innerHTML = '<p class="text-muted">正在加载搜索索引...</p>';

    fetch(window.searchIndexURL || 'search-index.json')
      .then(function(res) {
        if (!res.ok) throw new Error('search index HTTP ' + res.status);
        return res.json();
      })
      .then(function(data) {
        window.searchIndex = data;
      })
      .catch(function() {
        window.searchIndex = [];
      })
      .finally(function() {
        window.searchIndexLoaded = true;
        indexLoading = false;
        initializeSearch();
      });
  }

  // Search input handler
  searchInput.addEventListener('input', function() {
    if (!searchInitialized) {
      loadSearchIndex();
      searchResults.innerHTML = '<p class="text-muted">正在加载搜索索引...</p>';
      return;
    }
    performSearch(fuse, this.value.trim(), searchResults);
  });

  // Modal event handlers
  searchModal.addEventListener('shown.bs.modal', () => {
    setTimeout(() => searchInput.focus(), 100);

    // 首次打开搜索框时预加载搜索索引
    loadSearchIndex();
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

  // 设置全局函数供外部调用
  window.initializeSearch = initializeSearch;
}

// Export for use in main.js
module.exports = { setupSearch };
