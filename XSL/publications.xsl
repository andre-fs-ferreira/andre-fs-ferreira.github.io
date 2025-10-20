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
        <link rel="stylesheet" href="/css/button.css"/>
        <link rel="stylesheet" href="/css/text.css"/>
        <link rel="stylesheet" href="/css/publications.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
      </head>
      <body>
        <xsl:apply-templates select="/publications/header"/>

        <button class="house-button" onclick="location.href='/'">
          <xsl:attribute name="aria-label">
            <xsl:value-of select="/publications/@homepage_aria_label"/>
          </xsl:attribute>
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

        <script src="/js/paticles.js"></script>
        <script src="/js/responsive.js"></script>
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
      <h1><xsl:value-of select="@title"/></h1>
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