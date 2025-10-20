/*
 * --- Staggered Fade-In Animation Logic ---
 *
 * Description:
 * - Animates every visible <ul> inside the .topic container on page load.
 * - Provides a function (animateRevealedLists) to animate lists inside
 * content that is revealed later (e.g., by toggleVisibility).
 * - Relies on a CSS class .fadeInUp and a CSS custom property --delay.
 */

// =================================================================
// == 1. CORE ANIMATION UTILITIES
// =================================================================

/**
 * Applies the fade-in animation class and a CSS delay property to an element.
 * @param {HTMLElement} el - The element to animate.
 * @param {number} delaySec - The animation delay in seconds.
 */
function applyFade(el, delaySec) {
    // set CSS custom property --delay to control animation timing
    el.style.setProperty('--delay', delaySec + 's');
    // Add class to trigger animation
    el.classList.add('fadeInUp');
}

/**
 * Removes animation classes and inline delays so the animation can be replayed.
 * @param {HTMLElement} el - The element to clear.
 */
function clearFade(el) {
    el.classList.remove('fadeInUp');
    el.style.removeProperty('--delay');
    // Force reflow (so re-adding the class replays the animation)
    void el.offsetWidth;
}

// =================================================================
// == 2. ANIMATION ORCHESTRATION
// =================================================================

/**
 * Animates all top-level *visible* ULs inside .topic, staggering each list group.
 * This is intended for the initial page load.
 */
function animateAllTopicLists() {
    const topic = document.querySelector('.topic');
    if (!topic) return;

    // Pick only visible ULs (skip those inside .hidden-content)
    const uls = Array.from(topic.querySelectorAll('ul')).filter(u => {
        // Visible if none of its ancestor elements have display: none
        return u.closest('.hidden-content') === null;
    });

    const groupDelayStep = 0.12; // seconds between each UL starting
    const itemDelayStep = 0.06; // seconds between items inside a UL

    uls.forEach((ul, groupIndex) => {
        // Stagger the start of this ul based on its order
        const baseDelay = groupIndex * groupDelayStep;

        // Note: Optionally animate the UL container itself (uncomment if desired)
        // applyFade(ul, baseDelay);

        const lis = Array.from(ul.children).filter(n => n.matches && n.matches('li'));
        lis.forEach((li, itemIndex) => {
            // Compute per-item delay: group base + incremental per-item
            const delay = baseDelay + itemIndex * itemDelayStep + 0.02; // small offset
            
            // Ensure we clear any previous animation so it can run again
            clearFade(li);
            
            // Use requestAnimationFrame to ensure clear() has taken effect
            requestAnimationFrame(() => applyFade(li, delay));
        });
    });
}

/**
 * Animates lists inside a newly revealed container.
 * This is called by toggleVisibility when content is shown.
 * @param {HTMLElement} container - The container element that was just revealed.
 */
function animateRevealedLists(container) {
    if (!container) return;
    const uls = Array.from(container.querySelectorAll('ul'));
    const itemDelayStep = 0.06;

    uls.forEach((ul, uIdx) => {
        const lis = Array.from(ul.children).filter(n => n.matches && n.matches('li'));
        lis.forEach((li, i) => {
            clearFade(li);
            // A small, simple delay pattern for nested/revealed blocks
            const delay = 0.06 + uIdx * 0.04 + i * itemDelayStep;
            requestAnimationFrame(() => applyFade(li, delay));
        });
    });
}

// =================================================================
// == 3. GLOBAL FUNCTIONS & EVENT HANDLERS
// =================================================================

/**
 * Toggles the visibility of a content block and triggers its animations.
 * @param {string} id - The ID of the element to show/hide.
 * @param {HTMLElement} [triggerEl] - Optional trigger element (e.g., a button) to update text.
 */
window.toggleVisibility = function(id, triggerEl) {
    const el = document.getElementById(id);
    if (!el) return;

    if (el.classList.contains('hidden-content')) {
        // --- SHOW ---
        el.classList.remove('hidden-content');
        el.style.display = 'block';

        // Animate lists inside the revealed block
        // Use requestAnimationFrame to allow layout to settle first
        requestAnimationFrame(() => animateRevealedLists(el));

        if (triggerEl) triggerEl.textContent = '(collapse ⇧)';
    } else {
        // --- HIDE ---
        // Clear animations inside to prepare for next show
        const animated = el.querySelectorAll('.fadeInUp');
        animated.forEach(clearFade);

        el.classList.add('hidden-content');
        el.style.display = 'none';
        if (triggerEl) triggerEl.textContent = '(expand ⇩)';
    }
};

/**
 * Exposes a helper function to replay all initial topic animations.
 */
window.replayTopicAnimations = function() {
    // Clear all previous animations
    const allAnimated = document.querySelectorAll('.topic .fadeInUp');
    allAnimated.forEach(clearFade);
    
    // Re-run the main animation function
    animateAllTopicLists();
};

// =================================================================
// == 4. INITIALIZATION (ENTRY POINT)
// =================================================================

/**
 * Run the initial animation once the DOM is ready.
 */
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', animateAllTopicLists);
} else {
    // DOM is already ready
    animateAllTopicLists();
}

function toggleVisibility(contentId, togglerElement) {
            const contentElement = document.getElementById(contentId);
            if (window.getComputedStyle(contentElement).display === "none" || contentElement.style.display === "none") {
                contentElement.style.display = "block";
                togglerElement.innerHTML = '(collapse ⇧)';
            } else {
                contentElement.style.display = "none";
                togglerElement.innerHTML = '(expand ⇩)';
            }
          }