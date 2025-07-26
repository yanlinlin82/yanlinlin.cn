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
      keys: ['title', 'content', 'tags', 'categories'],
      threshold: 0.3,
      includeScore: true,
      includeMatches: true
    };
    
    const fuse = new Fuse(window.searchIndex, fuseOptions);
    
    // Search functionality
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');
    
    if (searchInput && searchResults) {
      searchInput.addEventListener('input', function() {
        const query = this.value.trim();
        
        if (query.length < 2) {
          searchResults.innerHTML = '<p class="text-muted">输入至少2个字符开始搜索...</p>';
          return;
        }
        
        const results = fuse.search(query).slice(0, 10); // Limit to 10 results
        
        if (results.length === 0) {
          searchResults.innerHTML = '<p class="text-muted">没有找到相关结果</p>';
          return;
        }
        
        const resultsHtml = results.map(result => {
          const item = result.item;
          const score = result.score;
          const matches = result.matches;
          
          // Highlight matched text
          let title = item.title;
          let content = item.content.substring(0, 200) + '...';
          
          if (matches) {
            matches.forEach(match => {
              if (match.key === 'title') {
                match.indices.forEach(([start, end]) => {
                  const matchedText = title.substring(start, end + 1);
                  title = title.replace(matchedText, `<mark>${matchedText}</mark>`);
                });
              }
            });
          }
          
          return `
            <div class="search-result-item mb-3 p-3 border rounded">
              <h6 class="mb-1">
                <a href="${item.url}" class="text-decoration-none">${title}</a>
              </h6>
              <p class="text-muted small mb-1">${item.date}</p>
              <p class="mb-2">${content}</p>
              ${item.tags && item.tags.length > 0 ? 
                `<div class="mb-2">
                  ${item.tags.map(tag => `<span class="badge bg-secondary me-1">${tag}</span>`).join('')}
                </div>` : ''
              }
            </div>
          `;
        }).join('');
        
        searchResults.innerHTML = resultsHtml;
      });
    }
  }
});
