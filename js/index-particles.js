// --------------------------- Particles (responsive) ---------------------------
    (function(){
      const canvas = document.getElementById('particle-canvas');
      const ctx = canvas.getContext('2d');
      const bg = document.querySelector('.bg-image');

      let DPR = Math.max(1, window.devicePixelRatio || 1);

      class Particle {
        constructor(w, h) {
          this.x = Math.random() * w;
          this.y = Math.random() * h;
          this.vx = (Math.random() - 0.5) * 2;
          this.vy = (Math.random() - 0.5) * 2;
          this.size = Math.random() * 3 + 2;
        }
        update(w, h) {
          this.x += this.vx;
          this.y += this.vy;
          if (this.x > w) { this.x = w; this.vx *= -1; }
          if (this.x < 0) { this.x = 0; this.vx *= -1; }
          if (this.y > h) { this.y = h; this.vy *= -1; }
          if (this.y < 0) { this.y = 0; this.vy *= -1; }
        }
        draw(ctx, alpha) {
          if (alpha <= 0) return;
          ctx.beginPath();
          ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
          ctx.fillStyle = `rgba(0,200,255,${(0.85 * alpha).toFixed(3)})`;
          ctx.fill();
        }
      }

      let particles = [];

      // --- responsive settings ---
      const AREA_PER_PARTICLE = 30000;
      const MIN_PARTICLES = 30;
      const MAX_PARTICLES = 50;

      function calcNumParticles() {
        const area = window.innerWidth * window.innerHeight;
        const count = Math.round(area / AREA_PER_PARTICLE);
        return Math.max(MIN_PARTICLES, Math.min(MAX_PARTICLES, count));
      }

      function calcConnectDistance(w, h) {
        const base = Math.max(w, h) * 1.0;
        return Math.max(60, Math.min(120, Math.round(base)));
      }

      let numParticles = calcNumParticles();
      let connectDistance = calcConnectDistance(window.innerWidth, window.innerHeight);

      function setCanvasSize() {
        DPR = Math.max(1, window.devicePixelRatio || 1);
        const w = window.innerWidth;
        const h = window.innerHeight;
        canvas.style.width = w + 'px';
        canvas.style.height = h + 'px';
        canvas.width = Math.floor(w * DPR);
        canvas.height = Math.floor(h * DPR);
        ctx.setTransform(1,0,0,1,0,0);
        ctx.scale(DPR, DPR);
      }

      function initParticles() {
        setCanvasSize();
        numParticles = calcNumParticles();
        connectDistance = calcConnectDistance(window.innerWidth, window.innerHeight);

        particles = [];
        for (let i = 0; i < numParticles; i++) {
          particles.push(new Particle(window.innerWidth, window.innerHeight));
        }
      }

      function getMousePosFromCSS() {
        const mx = getComputedStyle(bg).getPropertyValue('--mouse-x') || '50%';
        const my = getComputedStyle(bg).getPropertyValue('--mouse-y') || '50%';
        const mxN = parseFloat(mx) / 100 * window.innerWidth;
        const myN = parseFloat(my) / 100 * window.innerHeight;
        return { x: mxN, y: myN };
      }

      function getMaskParams() {
        const maskSizeRaw = getComputedStyle(bg).getPropertyValue('--mask-size') || '1%';
        const maskFeatherRaw = getComputedStyle(bg).getPropertyValue('--mask-feather') || '6%';
        const maskSize = parseFloat(maskSizeRaw);
        const maskFeather = parseFloat(maskFeatherRaw);
        return { maskSize, maskFeather };
      }

      function maskPercentToPx(pct) {
        const ref = Math.max(window.innerWidth, window.innerHeight);
        return (pct / 100) * ref;
      }

      function computeMaskAlphaAtPoint(px, py, maskRadiusPx, maskFeatherPx, centerX, centerY) {
        const dx = px - centerX;
        const dy = py - centerY;
        const dist = Math.sqrt(dx*dx + dy*dy);
        if (dist <= maskRadiusPx) return 1;
        if (maskFeatherPx <= 0) return 0;
        if (dist <= maskRadiusPx + maskFeatherPx) {
          return 1 - (dist - maskRadiusPx) / maskFeatherPx;
        }
        return 0;
      }

      function animateParticles() {
        ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

        const { x: mouseX, y: mouseY } = getMousePosFromCSS();
        const { maskSize, maskFeather } = getMaskParams();
        const radiusPx = maskPercentToPx(maskSize);
        const featherPx = maskPercentToPx(maskFeather);

        for (let p of particles) {
          p.update(window.innerWidth, window.innerHeight);
          const alpha = computeMaskAlphaAtPoint(p.x, p.y, radiusPx, featherPx, mouseX, mouseY);
          p.draw(ctx, alpha);
        }

        for (let i = 0; i < particles.length; i++) {
          for (let j = i + 1; j < particles.length; j++) {
            const a = particles[i];
            const b = particles[j];
            const dx = a.x - b.x;
            const dy = a.y - b.y;
            const dist = Math.sqrt(dx*dx + dy*dy);
            if (dist < connectDistance) {
              const midX = (a.x + b.x) / 2;
              const midY = (a.y + b.y) / 2;
              const maskAlpha = computeMaskAlphaAtPoint(midX, midY, radiusPx, featherPx, mouseX, mouseY);
              if (maskAlpha <= 0) continue;
              const baseAlpha = 1 - dist / connectDistance;
              ctx.beginPath();
              ctx.moveTo(a.x, a.y);
              ctx.lineTo(b.x, b.y);
              ctx.strokeStyle = `rgba(0,150,255,${(baseAlpha * maskAlpha * 0.95).toFixed(3)})`;
              ctx.lineWidth = 1.5;
              ctx.stroke();
            }
          }
        }

        requestAnimationFrame(animateParticles);
      }

      initParticles();
      animateParticles();

      let resizeDebounce = null;
      window.addEventListener('resize', () => {
        clearTimeout(resizeDebounce);
        resizeDebounce = setTimeout(() => {
          initParticles();
        }, 120);
      }, {passive:true});
    })();
