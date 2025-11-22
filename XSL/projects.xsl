<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title><xsl:value-of select="research/header/title"/></title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="/css/button.css" />
        <link rel="stylesheet" href="/css/text.css" />
        <link rel="stylesheet" href="/css/projects.css" />
      </head>
      <body>
        <xsl:apply-templates select="research/header"/>

        <main>
          <xsl:apply-templates select="research/projects"/>
        </main>

        <canvas id="particle-canvas"></canvas>
        <footer>
          <button class="house-button" onclick="location.href='/'" aria-label="Homepage">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <path d="M3 9.75L12 3l9 6.75V21a.75.75 0 01-.75.75h-5.25v-6h-6v6H3.75A.75.75 0 013 21V9.75z"/>
            </svg>
          </button>
        </footer>

        <script src="/js/particles.js"></script>
        <script src="/js/responsive.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="header">
    <header class="header">
      <div class="header-content">
        <h1>
          <i class="{@icon}"></i>&#160;
          <xsl:value-of select="title"/>
        </h1>
        <p class="quote">
          <xsl:value-of select="quote"/> - <xsl:value-of select="quote/@author"/>
        </p>
      </div>
    </header>
  </xsl:template>

  <xsl:template match="projects">
    <xsl:for-each select="project">
      <xsl:apply-templates select="."/>
      <xsl:if test="position() != last()">
        <br/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="project">
    <article class="topic">
      <h2><xsl:value-of select="title"/></h2>
      <div class="topic-content">
        <p>
          <xsl:copy-of select="description/node()"/>
        </p>
        <div class="tags">
          <xsl:for-each select="tags/tag">
            <span class="tag">
              <xsl:value-of select="."/>
            </span>
          </xsl:for-each>
        </div>
        <div class="project-links">
          <xsl:for-each select="links/link">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="@href"/>
              </xsl:attribute>
              <xsl:if test="@target">
                <xsl:attribute name="target">
                  <xsl:value-of select="@target"/>
                </xsl:attribute>
              </xsl:if>
              <i>
                <xsl:attribute name="class">
                  <xsl:value-of select="@icon"/>
                </xsl:attribute>
              </i>&#160;
              <xsl:value-of select="."/>
            </a>
          </xsl:for-each>
        </div>
      </div>
    </article>
  </xsl:template>

</xsl:stylesheet>