// --------------------------- Mask + wave logic ---------------------------
(function(){
  if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  const bg = document.querySelector('.bg-image');
  const header = document.querySelector('.header-wrap'); 
  const textBox = document.querySelector('.text-box'); // ✨ 1. Select the text box

  if (!bg || !header || !textBox) return; // ✅ Update the check

  let tx = innerWidth / 2, ty = innerHeight / 2;
  function toPercent(value, max){ return (value / max * 100).toFixed(4) + '%'; }

  function updatePos(clientX, clientY){
    tx = clientX; ty = clientY;
    bg.style.setProperty('--mouse-x', toPercent(tx, window.innerWidth));
    bg.style.setProperty('--mouse-y', toPercent(ty, window.innerHeight));
  }

  window.addEventListener('mousemove', (e)=> updatePos(e.clientX, e.clientY), {passive:true});
  window.addEventListener('touchstart', (e)=> {
    if (e.touches && e.touches.length) updatePos(e.touches[0].clientX, e.touches[0].clientY);
  }, {passive:true});
  window.addEventListener('touchmove', (e)=> {
    if (e.touches && e.touches.length) updatePos(e.touches[0].clientX, e.touches[0].clientY);
  }, {passive:true});

  window.addEventListener('resize', ()=> {
    bg.style.setProperty('--mouse-x', toPercent(tx, window.innerWidth));
    bg.style.setProperty('--mouse-y', toPercent(ty, window.innerHeight));
  }, {passive:true});

  function parsePercent(str, fallback=0){
    if (!str) return fallback;
    const m = String(str).trim().match(/^(-?[\d.]+)/);
    return m ? parseFloat(m[1]) : fallback;
  }
  function easeOutCubic(t){ return 1 - Math.pow(1 - t, 3); }

  let waveRAF = null;
  let waveStart = 0;
  const DEFAULTS = {
    startSize: 0.8,
    startFeather: 6,
    peakSize: 65,
    peakFeather: 28,
    startVignette: 0.35,
    peakVignette: 0.05,
    duration: 2000
  };

  bg.style.setProperty('--mask-size', DEFAULTS.startSize + '%');
  bg.style.setProperty('--mask-feather', DEFAULTS.startFeather + '%');
  bg.style.setProperty('--vignette-opacity', DEFAULTS.startVignette);

  function animateWave(options = {}) {
    const {
      startSize = DEFAULTS.startSize,
      startFeather = DEFAULTS.startFeather,
      peakSize = DEFAULTS.peakSize,
      peakFeather = DEFAULTS.peakFeather,
      startVignette = DEFAULTS.startVignette,
      peakVignette = DEFAULTS.peakVignette,
      duration = DEFAULTS.duration
    } = options;

    header.style.opacity = '0'; 
    textBox.style.opacity = '0'; // ✨ 2. Fade the text box out

    let currentSize = parsePercent(getComputedStyle(bg).getPropertyValue('--mask-size'), startSize);
    let currentFeather = parsePercent(getComputedStyle(bg).getPropertyValue('--mask-feather'), startFeather);
    let currentVig = parseFloat(getComputedStyle(bg).getPropertyValue('--vignette-opacity')) || startVignette;

    if (waveRAF) cancelAnimationFrame(waveRAF);
    waveStart = performance.now();

    function frame(now) {
      const elapsed = now - waveStart;
      let t = Math.min(1, elapsed / duration);
      const ease = easeOutCubic(t);

      const size = currentSize + (peakSize - currentSize) * ease;
      const feather = currentFeather + (peakFeather - currentFeather) * ease;
      const vig = currentVig + (peakVignette - currentVig) * ease;

      bg.style.setProperty('--mask-size', size.toFixed(4) + '%');
      bg.style.setProperty('--mask-feather', feather.toFixed(4) + '%');
      bg.style.setProperty('--vignette-opacity', vig.toFixed(4));

      if (t < 1) {
        waveRAF = requestAnimationFrame(frame);
      } else {
        const settleStart = performance.now();
        const settleDuration = 700;
        const settleFrom = { size, feather, vig };
        function settle(now2) {
          const elapsed2 = now2 - settleStart;
          const tt = Math.min(1, elapsed2 / settleDuration);
          const e2 = 1 - Math.pow(1 - tt, 2);
          const sSize = settleFrom.size + (startSize - settleFrom.size) * e2;
          const sFeather = settleFrom.feather + (startFeather - settleFrom.feather) * e2;
          const sVig = settleFrom.vig + (startVignette - settleFrom.vig) * e2;
          bg.style.setProperty('--mask-size', sSize.toFixed(4) + '%');
          bg.style.setProperty('--mask-feather', sFeather.toFixed(4) + '%');
          bg.style.setProperty('--vignette-opacity', sVig.toFixed(4));

          if (tt < 1) {
            waveRAF = requestAnimationFrame(settle);
          } else {
            waveRAF = null;
            header.style.opacity = '1'; 
            textBox.style.opacity = '1'; // ✨ 3. Fade the text box back in
          }
        }
        waveRAF = requestAnimationFrame(settle);
      }
    }

    waveRAF = requestAnimationFrame(frame);
  }

  function clickWave(clientX, clientY){
    updatePos(clientX, clientY);
    animateWave({
      startSize: 0.8,
      startFeather: 6,
      peakSize: 65,
      peakFeather: 28,
      startVignette: 0.35,
      peakVignette: 0.05,
      duration: 4000
    });
  }

  window.addEventListener('click', (e)=> {
    clickWave(e.clientX, e.clientY);
  }, {passive:true});

  window.addEventListener('touchend', (e)=> {
    const t = (e.changedTouches && e.changedTouches[0]) || (e.touches && e.touches[0]);
    if (t) clickWave(t.clientX, t.clientY);
  }, {passive:true});
})();