// This JavaScript contains all the logic for the animation
(function() {

    // =================================================================
    // == 1. CONFIGURATION & CONSTANTS
    // =================================================================

    // --- Responsive Settings ---
    const AREA_PER_PARTICLE = 25000; // How much screen area each particle "occupies"
    const MIN_PARTICLES = 20;
    const MAX_PARTICLES = 100;

    // =================================================================
    // == 2. GLOBAL VARIABLES & CANVAS SETUP
    // =================================================================

    const canvas = document.getElementById('particle-canvas');
    const ctx = canvas.getContext('2d');

    let DPR = Math.max(1, window.devicePixelRatio || 1);
    let particles = [];
    let connectDistance = 0; // Will be calculated in initParticles()

    // =================================================================
    // == 3. PARTICLE CLASS DEFINITION
    // =================================================================

    /**
     * Defines a single particle (a white dot)
     */
    class Particle {
        constructor(w, h) {
            this.x = Math.random() * w;
            this.y = Math.random() * h;
            this.vx = (Math.random() - 0.5) * 1; // Slower speed
            this.vy = (Math.random() - 0.5) * 1; // Slower speed
            this.size = Math.random() * 2 + 1;
        }

        /**
         * Updates the particle's position and handles edge bouncing.
         */
        update(w, h) {
            this.x += this.vx;
            this.y += this.vy;
            // This makes particles bounce off the screen edges
            if (this.x > w || this.x < 0) {
                this.vx *= -1;
            }
            if (this.y > h || this.y < 0) {
                this.vy *= -1;
            }
        }

        /**
         * Draws the particle on the canvas.
         */
        draw(ctx) {
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            // Changed color to white with some transparency
            ctx.fillStyle = 'rgba(255, 255, 255, 0.85)';
            ctx.fill();
        }
    }

    // =================================================================
    // == 4. HELPER & UTILITY FUNCTIONS
    // =================================================================

    /**
     * Calculates the number of particles based on screen area.
     */
    function calcNumParticles() {
        const area = window.innerWidth * window.innerHeight;
        const count = Math.round(area / AREA_PER_PARTICLE);
        return Math.max(MIN_PARTICLES, Math.min(MAX_PARTICLES, count));
    }

    /**
     * Calculates the max distance for particles to connect.
     */
    function calcConnectDistance(w, h) {
        return Math.min(w, h) / 7;
    }

    /**
     * Sets the canvas to the full size of the window and handles high-DPR screens.
     */
    function setCanvasSize() {
        DPR = Math.max(1, window.devicePixelRatio || 1);
        const w = window.innerWidth;
        const h = window.innerHeight;
        canvas.style.width = w + 'px';
        canvas.style.height = h + 'px';
        canvas.width = Math.floor(w * DPR);
        canvas.height = Math.floor(h * DPR);
        ctx.scale(DPR, DPR); // Scales for high-res displays
    }

    // =================================================================
    // == 5. MAIN LOGIC FUNCTIONS
    // =================================================================

    /**
     * (Re)initializes the canvas and creates all particles.
     */
    function initParticles() {
        setCanvasSize();
        connectDistance = calcConnectDistance(window.innerWidth, window.innerHeight);
        const numParticles = calcNumParticles();

        particles = [];
        for (let i = 0; i < numParticles; i++) {
            particles.push(new Particle(window.innerWidth, window.innerHeight));
        }
    }

    /**
     * The main animation loop that runs continuously via requestAnimationFrame.
     */
    function animateParticles() {
        // Clear the canvas every frame for a fresh drawing
        ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

        // --- 1. Update and draw each particle ---
        for (let p of particles) {
            p.update(window.innerWidth, window.innerHeight);
            p.draw(ctx);
        }

        // --- 2. Check every pair of particles to draw lines ---
        for (let i = 0; i < particles.length; i++) {
            for (let j = i + 1; j < particles.length; j++) {
                const a = particles[i];
                const b = particles[j];
                const dx = a.x - b.x;
                const dy = a.y - b.y;
                const dist = Math.sqrt(dx * dx + dy * dy);

                // If they are close enough, draw a line
                if (dist < connectDistance) {
                    // The line fades out as the particles get further apart
                    const alpha = 1 - (dist / connectDistance);
                    ctx.beginPath();
                    ctx.moveTo(a.x, a.y);
                    ctx.lineTo(b.x, b.y);
                    // Changed line color to white
                    ctx.strokeStyle = `rgba(255, 255, 255, ${alpha.toFixed(2)})`;
                    ctx.lineWidth = 1;
                    ctx.stroke();
                }
            }
        }

        // Ask the browser to run this function again for the next frame
        requestAnimationFrame(animateParticles);
    }

    // =================================================================
    // == 6. INITIALIZATION & EVENT LISTENERS
    // =================================================================

    // --- Start Everything ---
    initParticles();
    animateParticles();

    // --- Handle Window Resizing ---
    // Re-create particles when the window is resized, using a debounce
    // to prevent it from firing too many times.
    let resizeDebounce = null;
    window.addEventListener('resize', () => {
        clearTimeout(resizeDebounce);
        resizeDebounce = setTimeout(() => {
            initParticles();
        }, 150);
    });

})();