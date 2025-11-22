console.log('Publications script loaded and starting...');  // Debug log to confirm execution

try {
  const body = document.body;
  const navbar = document.querySelector('.navbar');
  if (!navbar) {
    console.warn('Navbar not found — dropdowns will not be initialized.');
  }

  console.log('Navbar found');  // Debug log

  // Move all dropdown contents to body to avoid sticky clipping issues
  const dropdownContents = document.querySelectorAll('.dropdown-content');
  dropdownContents.forEach(content => {
    document.body.appendChild(content);
  });

  function closeAllDropdowns() {
    document.querySelectorAll('.dropdown-content.show').forEach(dropdown => {
      dropdown.classList.remove('show');
      dropdown.setAttribute('aria-hidden', 'true');
    });
    document.querySelectorAll('.dropbtn').forEach(btn => btn.setAttribute('aria-expanded', 'false'));
    body.classList.remove('dropdown-active');
  }

  function positionDropdown(dropdownElement) {
    if (!dropdownElement) return;
    const navBarHeight = navbar.offsetHeight;
    const viewportHeight = window.innerHeight;
    const availableHeight = viewportHeight - navBarHeight - 20;

    dropdownElement.style.position = 'fixed';
    dropdownElement.style.top = navBarHeight + 'px';
    dropdownElement.style.left = '0';
    dropdownElement.style.right = '0';
    dropdownElement.style.maxHeight = availableHeight + 'px';
    dropdownElement.style.overflowY = 'auto';
  }

  // Delegated click on navbar (works even if DOM shape changes slightly)
  navbar.addEventListener('click', (event) => {
    try {
      console.log('Navbar click detected');  // Debug log
      const button = event.target.closest('.dropbtn');
      if (!button) {
        console.log('No button found');  // Debug log
        return;
      }

      event.stopPropagation();

      const targetId = (button.dataset && button.dataset.target) || button.getAttribute('data-target');
      console.log('Target ID:', targetId);  // Debug log
      if (!targetId) return;
      const targetElement = document.getElementById(targetId);
      console.log('Target element found:', !!targetElement);  // Debug log (true/false)
      if (!targetElement) return;

      const wasAlreadyOpen = targetElement.classList.contains('show');
      console.log('Was already open:', wasAlreadyOpen);  // Debug log
      closeAllDropdowns();

      if (!wasAlreadyOpen) {
        console.log('Opening dropdown');  // Debug log
        body.classList.add('dropdown-active');
        button.setAttribute('aria-expanded', 'true');
        positionDropdown(targetElement);
        targetElement.classList.add('show');
        targetElement.setAttribute('aria-hidden', 'false');
      }
    } catch (err) {
      console.error('Error handling navbar click:', err);
    }
  });

  document.addEventListener('click', (event) => {
    if (!event.target.closest('.dropdown') && !event.target.closest('.dropdown-content')) {
      closeAllDropdowns();
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeAllDropdowns();
    }
  });

  window.addEventListener('resize', () => {
    const openDropdown = document.querySelector('.dropdown-content.show');
    if (openDropdown) {
      positionDropdown(openDropdown);
    }
  });

  const images = document.querySelectorAll('.figure-img');
  images.forEach(image => {
    image.addEventListener('click', () => {
      try {
        const overlay = document.createElement('div');
        overlay.classList.add('modal-overlay');
        const modalImage = document.createElement('img');
        modalImage.src = image.src;
        modalImage.classList.add('modal-img');
        overlay.appendChild(modalImage);
        document.body.appendChild(overlay);
        setTimeout(() => { overlay.classList.add('active'); }, 10);
        overlay.addEventListener('click', (event) => {
          event.stopPropagation();
          overlay.classList.remove('active');
          overlay.addEventListener('transitionend', () => {
            if (document.body.contains(overlay)) {
              document.body.removeChild(overlay);
            }
          }, { once: true });
        });
      } catch (err) {
        console.error('Error opening image modal:', err);
      }
    });
  });

// NEW: Parse raw HTML strings (e.g., <a href...>) into actual HTML elements
  // Firefox ignores 'disable-output-escaping', so we must detect raw HTML text and render it manually.
  const textElements = document.querySelectorAll('.text-content h2, .text-content p');
  textElements.forEach(el => {
    // If the visible text contains HTML tags (like <a or <b>), it means the browser failed to parse them.
    // We take the text content and force the browser to interpret it as HTML.
    if (el.textContent.includes('<') && el.textContent.includes('>')) {
      el.innerHTML = el.textContent;
    }
  });

} catch (err) {
  console.error('Publications script initialization error:', err);
}