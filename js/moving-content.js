/* --- Staggered fade-in for each UL and its LI children.
- Animates every visible <ul> inside .topic
- When a hidden block (e.g. #ai-challenges-content) is revealed by toggleVisibility(),
    call animateRevealedLists() to animate its lists.
*/

/* Utility: apply fade class and delay to an element */
function applyFade(el, delaySec) {
// set CSS custom property --delay to control animation timing
el.style.setProperty('--delay', delaySec + 's');
// Add class to trigger animation
el.classList.add('fadeInUp');
}

/* Remove animation classes and inline delays so animation can be replayed */
function clearFade(el) {
el.classList.remove('fadeInUp');
el.style.removeProperty('--delay');
// force reflow (so re-adding the class replays animation)
void el.offsetWidth;
}

/* Animate all top-level ULs inside .topic, staggering each list group */
function animateAllTopicLists() {
const topic = document.querySelector('.topic');
if (!topic) return;

// pick only visible ULs (skip those inside .hidden-content)
const uls = Array.from(topic.querySelectorAll('ul')).filter(u => {
    // visible if none of its ancestor elements have display: none
    return u.closest('.hidden-content') === null;
});

const groupDelayStep = 0.12; // seconds between each UL starting
const itemDelayStep = 0.06;  // seconds between items inside a UL

uls.forEach((ul, groupIndex) => {
    // stagger the start of this ul based on its order
    const baseDelay = groupIndex * groupDelayStep;

    // optionally animate the UL container itself (uncomment if desired)
    // applyFade(ul, baseDelay);

    const lis = Array.from(ul.children).filter(n => n.matches && n.matches('li'));
    lis.forEach((li, itemIndex) => {
    // compute per-item delay: group base + incremental per-item
    const delay = baseDelay + itemIndex * itemDelayStep + 0.02; // small offset
    // ensure we clear any previous animation so it can run again
    clearFade(li);
    // tiny timeout to allow clear to take effect / reflow
    requestAnimationFrame(() => applyFade(li, delay));
    });
});
}

/* Animate lists inside a newly revealed container (used by toggleVisibility) */
function animateRevealedLists(container) {
if (!container) return;
const uls = Array.from(container.querySelectorAll('ul'));
const itemDelayStep = 0.06;
uls.forEach((ul, uIdx) => {
    const lis = Array.from(ul.children).filter(n => n.matches && n.matches('li'));
    lis.forEach((li, i) => {
    clearFade(li);
    const delay = 0.06 + uIdx * 0.04 + i * itemDelayStep; // small pattern for nested blocks
    requestAnimationFrame(() => applyFade(li, delay));
    });
});
}

/* Replace or augment your existing toggleVisibility function so it triggers animations */
window.toggleVisibility = function(id, triggerEl) {
const el = document.getElementById(id);
if (!el) return;
if (el.classList.contains('hidden-content')) {
    // show
    el.classList.remove('hidden-content');
    el.style.display = 'block';
    // animate lists inside the revealed block
    // allow layout to settle first
    requestAnimationFrame(() => animateRevealedLists(el));
    if (triggerEl) triggerEl.textContent = '(collapse ⇧)';
} else {
    // hide
    // clear animations inside to prepare for next show
    const animated = el.querySelectorAll('.fadeInUp');
    animated.forEach(clearFade);
    el.classList.add('hidden-content');
    el.style.display = 'none';
    if (triggerEl) triggerEl.textContent = '(expand ⇩)';
}
};

/* Initial run when DOM is ready */
if (document.readyState === 'loading') {
document.addEventListener('DOMContentLoaded', animateAllTopicLists);
} else {
animateAllTopicLists();
}

/* Expose a helper to replay all topic animations if you need it elsewhere */
window.replayTopicAnimations = function() {
// clear previous animations
const all = document.querySelectorAll('.topic .fadeInUp');
all.forEach(clearFade);
// re-run
animateAllTopicLists();
};