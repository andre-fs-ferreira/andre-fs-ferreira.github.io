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

        <script src="/js/particles.js"></script>
        <script src="/js/responsive.js"></script>
        <script src="/js/publications.js"></script>  <!-- New external script link -->

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
      <!-- button: use attribute value templates and type="button" -->
      <button class="dropbtn"
              type="button"
              data-target="{@value}_papers"
              aria-expanded="false"
              aria-controls="{@value}_papers">
        <xsl:value-of select="@value"/>
        <i class="fa fa-caret-down" aria-hidden="true"></i>
      </button>

      <!-- dropdown content with id using attribute value template -->
      <div class="dropdown-content"
          id="{@value}_papers"
          role="region"
          aria-hidden="true">
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
        <!-- correct, void element usage -->
        <img class="figure-img" src="{image/@src}" alt="{title}"/>
      </figure>
    </div>
    <xsl:if test="position() != last()">
      <hr/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>