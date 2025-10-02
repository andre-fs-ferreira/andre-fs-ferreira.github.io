// -------------------- Shrink image proportionally on small screens --------------------
    (function(){
      const bg = document.querySelector('.bg-image');
      const SMALL_WIDTH = 800; // px
      const SHRINK_TO = 0.9;   // 90% of full size

      function updateSize(){
        const scale = (window.innerWidth <= SMALL_WIDTH) ? SHRINK_TO : 1;
        bg.style.width = (scale*100) + '%';
        bg.style.height = (scale*100) + '%';
      }

      updateSize();
      window.addEventListener('resize', updateSize, {passive:true});
    })();