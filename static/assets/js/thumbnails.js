// 缩略图增强功能
document.addEventListener('DOMContentLoaded', function() {
  // 图片错误处理
  const images = document.querySelectorAll('.article-thumbnail-img');
  
  images.forEach(img => {
    // 处理图片加载错误 - 直接隐藏缩略图区域
    img.addEventListener('error', function() {
      img.parentElement.classList.add('d-none');
    });
  });
  
  // 缩略图悬停效果
  const articleItems = document.querySelectorAll('.article-item-with-thumbnail');
  articleItems.forEach(item => {
    const thumbnail = item.querySelector('.article-thumbnail-img');
    const link = item.querySelector('.article-card-link');
    
    if (thumbnail && link) {
      // 鼠标悬停时增强缩略图效果
      link.addEventListener('mouseenter', function() {
        thumbnail.style.transform = 'scale(1.05)';
      });
      
      link.addEventListener('mouseleave', function() {
        thumbnail.style.transform = 'scale(1)';
      });
    }
  });
  
  // 响应式处理：在移动端优化缩略图显示
  function handleResponsiveThumbnails() {
    const isMobile = window.innerWidth <= 768;
    const thumbnails = document.querySelectorAll('.article-thumbnail');
    
    thumbnails.forEach(thumbnail => {
      if (isMobile) {
        // 移动端：确保缩略图在顶部显示
        thumbnail.style.order = '-1';
      } else {
        // 桌面端：恢复默认布局
        thumbnail.style.order = '';
      }
    });
  }
  
  // 初始调用
  handleResponsiveThumbnails();
  
  // 窗口大小改变时重新处理
  window.addEventListener('resize', handleResponsiveThumbnails);
  
  // 性能优化：防抖处理
  let resizeTimeout;
  window.addEventListener('resize', function() {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(handleResponsiveThumbnails, 250);
  });
});

 