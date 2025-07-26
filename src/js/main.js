// Import Bootstrap JavaScript from node_modules
import 'bootstrap';

// Custom JavaScript for yanlinlin.cn
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
});
