// --------------------------- Mask (mouse overlay) logic ---------------------------
(function(){
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  const bg = document.querySelector('.bg-image');
  if (!bg) return;

  let tx = innerWidth / 2, ty = innerHeight / 2;
  function toPercent(value, max){ return (value / max * 100).toFixed(4) + '%'; }

  function updatePos(clientX, clientY){
    tx = clientX; ty = clientY;
    bg.style.setProperty('--mouse-x', toPercent(tx, window.innerWidth));
    bg.style.setProperty('--mouse-y', toPercent(ty, window.innerHeight));
  }

  // mouse
  window.addEventListener('mousemove', (e)=> updatePos(e.clientX, e.clientY), {passive:true});

  // touch
  window.addEventListener('touchstart', (e)=> {
    if (e.touches && e.touches.length) updatePos(e.touches[0].clientX, e.touches[0].clientY);
  }, {passive:true});
  window.addEventListener('touchmove', (e)=> {
    if (e.touches && e.touches.length) updatePos(e.touches[0].clientX, e.touches[0].clientY);
  }, {passive:true});

  // keep overlay centred correctly on resize
  window.addEventListener('resize', ()=> {
    bg.style.setProperty('--mouse-x', toPercent(tx, window.innerWidth));
    bg.style.setProperty('--mouse-y', toPercent(ty, window.innerHeight));
  }, {passive:true});

  // keep sensible defaults for the mask/vignette (static overlay appearance)
  const DEFAULTS = {
    startSize: 0.8,
    startFeather: 6,
    startVignette: 0.35
  };

  bg.style.setProperty('--mask-size', DEFAULTS.startSize + '%');
  bg.style.setProperty('--mask-feather', DEFAULTS.startFeather + '%');
  bg.style.setProperty('--vignette-opacity', DEFAULTS.startVignette);

  // NOTE: all click/touchend handlers and the wave animation were removed so clicks
  // no longer trigger a ripple/wave. Only mouse/touch position updates the overlay.
})();
