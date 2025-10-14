<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width,initial-scale=1"/>
        <title>Publications</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
        <link rel="stylesheet" href="/css/background-pub.css"/>
        <link rel="stylesheet" href="/css/button.css"/>
        <link rel="stylesheet" href="/css/text.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
        <style>
          html, body { margin: 0; }
          .header { max-height: 300px; overflow: hidden; text-align: center; transition: max-height 0.6s ease-in-out, padding 0.6s ease-in-out; }
          .header-content { transition: opacity 0.3s ease; }
          body.dropdown-active .header { max-height: 0; padding-top: 0; padding-bottom: 0; }
          body.dropdown-active .header-content { opacity: 0; }
          .navbar { position: -webkit-sticky; position: sticky; top: 0; z-index: 1000; width: 100%; display: flex; box-sizing: border-box; background-color: #33333300; font-family: Verdana, sans-serif; align-items: stretch; flex-wrap: nowrap; transition: background-color 0.3s ease; }
          body.dropdown-active .navbar { background-color: rgba(51, 51, 51, 0.95); }
          .dropdown { position: relative; display: flex; flex: 1 1 0; min-width: 0; align-items: stretch; }
          .dropdown .dropbtn { cursor: pointer; font-size: clamp(0.5rem, 4vw, 1.6rem); border: none; outline: none; color: white; padding: 16px 16px; background-color: inherit; font-family: inherit; margin: 0; font-weight: bold; flex: 1 1 0; align-items: center; justify-content: center; box-sizing: border-box; white-space: nowrap; }
          .navbar .dropbtn { opacity: 0; transform: translateY(20px); animation: fadeInUp 0.7s ease forwards; will-change: transform, opacity; }
          .navbar .dropdown:nth-child(1) .dropbtn { animation-delay: 0.08s; } .navbar .dropdown:nth-child(2) .dropbtn { animation-delay: 0.16s; } .navbar .dropdown:nth-child(3) .dropbtn { animation-delay: 0.24s; } .navbar .dropdown:nth-child(4) .dropbtn { animation-delay: 0.32s; } .navbar .dropdown:nth-child(5) .dropbtn { animation-delay: 0.40s; } .navbar .dropdown:nth-child(6) .dropbtn { animation-delay: 0.48s; }
          .navbar a:hover, .dropdown:hover .dropbtn, .dropbtn:focus { background-color: rgb(0, 0, 83); }
          .dropdown-content { display: none; position: fixed; left: 0; right: 0; width: auto; z-index: 1100; overflow-y: auto; background-color: #ffffffc7; padding: 1rem; box-shadow: 0 2px 8px rgba(0,0,0,0.2); animation: fadeInUp 0.7s ease forwards; opacity: 0; }
          .show { display: block; }
          .dropdown-content p { margin: 10px 5%; text-align: left; max-width: 95%; font-size: 0.9rem; line-height: 1.6; }
          .dropdown-content p.keywords { margin: 10px 5%; text-align: left; max-width: 100%; font-size: 0.9rem; line-height: 1.6; }
          .dropdown-content p.keywords::before { content: "Keywords: "; font-weight: bold; font-size: 1.0rem; }
          .first-author-with-border { border-bottom: 0px solid rgb(0, 0, 255); padding: 0; margin: 0 auto; }
          .first-author-with-border h1 { display: block; font-size: 1.6rem; font-weight: bold; color: rgb(0, 0, 255); text-align: center; padding: 10px 0; margin: 0; background-color: rgba(0, 0, 255, 0.05); width: 100%; }
          .first-author-with-borde h2 { display: block; margin: 30px auto 1rem; font-size: 1.2rem; font-weight: bold; color: rgb(0, 0, 83); text-align: center; max-width: 80%; }
          .mid-author-with-border { border-bottom: 2px solid rgb(83, 0, 0); padding: 0; margin: 0 auto; }
          .mid-author-with-border h1 { display: block; font-size: 1.6rem; font-weight: bold; color: rgb(83, 0, 0); text-align: center; padding: 10px 0; margin: 0; background-color: rgba(255, 0, 0, 0.05); width: 100%; box-sizing: border-box; }
          .mid-author-with-border h2 { color: rgb(83, 0, 0); }
          .first-author-with-border .container-flex .text-content h2, .first-author-with-border .container-flex .text-content h2 a { color: rgb(0, 0, 83); text-decoration: none; font-weight: bold; transition: color 0.3s ease; }
          .first-author-with-border .container-flex .text-content h2 a:hover, .first-author-with-border .container-flex .text-content p a:hover { background-color: #ffffff00; color: rgb(0, 0, 154); text-decoration: underline; }
          .mid-author-with-border .container-flex .text-content h2 a { color: rgb(83, 0, 0); text-decoration: none; font-weight: bold; transition: color 0.3s ease; }
          .mid-author-with-border .container-flex .text-content h2 a:hover, .mid-author-with-border .container-flex .text-content p a:hover { background-color: #ffffff00; color: rgb(154, 0, 0); text-decoration: underline; }
          .container-flex { display: flex; flex-direction: column; gap: 1.5rem; align-items: center; }
          .text-content { width: 100%; }
          .image-content { width: 100%; max-width: 400px; margin: 0; }
          .image-content .figure-img { width: 100%; height: auto; display: block; }
          @media (min-width: 992px) { .container-flex { flex-direction: row; gap: 2rem; } .image-content img { width: 100%; height: 100%; object-fit: cover; } .container-flex .text-content h2, .container-flex .text-content p { margin-inline: 0; } }
          .figure-img { cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease; }
          .figure-img:hover { transform: scale(1.05); box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
          .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgb(211, 211, 211); display: flex; justify-content: center; align-items: center; z-index: 2000; cursor: pointer; opacity: 0; transition: opacity 0.3s ease; }
          .modal-overlay.active { opacity: 1; }
          .modal-img { max-width: 90vw; max-height: 90vh; object-fit: contain; transform: scale(0.9); transition: transform 0.3s ease; }
          .modal-overlay.active .modal-img { transform: scale(1); }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="/publications/header"/>

        <button class="house-button" onclick="location.href='/'" aria-label="Homepage">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M3 9.75L12 3l9 6.75V21a.75.75 0 01-.75.75h-5.25v-6h-6v6H3.75A.75.75 0 013 21V9.75z"/>
          </svg>
        </button>

        <main>
          <div class="navbar">
            <xsl:apply-templates select="/publications/year"/>
          </div>
        </main>
        
        <canvas id="particle-canvas"></canvas>

        <script src="/js/mask-wave-mouse.js"></script>
        <script src="/js/responsive.js"></script>
        <script src="/js/moving-content.js"></script>
        <script>
          document.addEventListener('DOMContentLoaded', () => {
            const body = document.body;
            const navbar = document.querySelector('.navbar');

            function closeAllDropdowns() {
              document.querySelectorAll('.dropdown-content.show').forEach(dropdown => {
                dropdown.classList.remove('show');
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
              dropdownElement.style.top = `${navBarHeight}px`;
              dropdownElement.style.left = '0';
              dropdownElement.style.right = '0';
              dropdownElement.style.maxHeight = `${availableHeight}px`;
              dropdownElement.style.overflowY = 'auto';
            }

            document.querySelectorAll('.dropbtn[data-target]').forEach(button => {
              button.addEventListener('click', (event) => {
                event.stopPropagation();
                const targetId = button.dataset.target;
                const targetElement = document.getElementById(targetId);
                if (!targetElement) return;

                const wasAlreadyOpen = targetElement.classList.contains('show');
                closeAllDropdowns();

                if (!wasAlreadyOpen) {
                  body.classList.add('dropdown-active');
                  const btn = targetElement.parentElement.querySelector('.dropbtn');
                  if (btn) btn.setAttribute('aria-expanded', 'true');
                  
                  setTimeout(() => {
                    positionDropdown(targetElement);
                    targetElement.classList.add('show');
                  }, 50);
                }
              });
            });

            document.addEventListener('click', (event) => {
              if (!event.target.closest('.dropdown')) {
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
              });
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="header">
    <header class="header">
      <div class="header-content">
        <h1><xsl:value-of select="title"/></h1>
        <p><xsl:value-of select="subtitle"/></p>
      </div>
    </header>
  </xsl:template>

  <xsl:template match="year">
    <div class="dropdown">
      <button class="dropbtn">
        <xsl:attribute name="data-target"><xsl:value-of select="@value"/>_papers</xsl:attribute>
        <xsl:value-of select="@value"/>
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-content">
        <xsl:attribute name="id"><xsl:value-of select="@value"/>_papers</xsl:attribute>
        <xsl:apply-templates select="author-group"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="author-group">
    <xsl:variable name="group-class">
      <xsl:choose>
        <xsl:when test="@type = 'first'">first-author-with-border</xsl:when>
        <xsl:otherwise>mid-author-with-border</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <div class="{$group-class}">
      <h1>
        <xsl:choose>
          <xsl:when test="@type = 'first'">First author</xsl:when>
          <xsl:otherwise>Mid author</xsl:otherwise>
        </xsl:choose>
      </h1>
      <br/>
      <xsl:apply-templates select="publication"/>
    </div>
    <br/>
  </xsl:template>

  <xsl:template match="publication">
    <div class="container-flex">
      <div class="text-content">
        <h2><xsl:value-of select="title" disable-output-escaping="yes"/></h2>
        <p><xsl:value-of select="description" disable-output-escaping="yes"/></p>
        <p class="keywords"><xsl:value-of select="keywords"/></p>
      </div>
      <figure class="figure image-content">
        <img class="figure-img">
          <xsl:attribute name="src"><xsl:value-of select="image/@src"/></xsl:attribute>
        </img>
      </figure>
    </div>
    <xsl:if test="position() != last()">
      <hr/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>