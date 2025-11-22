<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>About</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLMDJd/rB7Xj+XyU6K/BEXF8s0FwXG4Tj4e9F/F8Xy6d4+4+4/g+g+g+g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="/css/button.css"/>
        <link rel="stylesheet" href="/css/text.css"/>
        <link rel="stylesheet" href="/css/about-page.css"/>
      </head>
      <body>
        <xsl:apply-templates select="/profile/header"/>
        <main>
          <xsl:apply-templates select="/profile/resume"/>
          <xsl:apply-templates select="/profile/workExperience"/>
          
          <section class="topic">
            <h2><xsl:value-of select="/profile/domainFocus/@title"/></h2>
            <div class="topic-subsection right-margin left-margin">
              <xsl:apply-templates select="/profile/domainFocus"/>
            </div>
            <section class="skills-section right-margin left-margin">
              <hr/>
              <h3><xsl:value-of select="/profile/skills/@title"/>
                <div class="transparent toggle-link" onclick="toggleVisibility('skills-challenges-content', this)"><xsl:value-of select="/profile/skills/@expand_text"/></div>
              </h3>
              <div id="skills-challenges-content" class="hidden-content">
                <xsl:apply-templates select="/profile/skills"/>
              </div>
            </section>
          </section>
          
          <xsl:apply-templates select="/profile/distinctions"/>
          <xsl:apply-templates select="/profile/contributions"/>
          <xsl:apply-templates select="/profile/currentDevelopment"/>
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
        <script src="/js/moving-content.js"></script>
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

  <xsl:template match="resume">
    <section class="topic no-bullet">
      <div class="right-margin">
        <h2><xsl:value-of select="@title"/> (<a href="{@cv_path}" target="_blank" class="cv-link"><xsl:value-of select="@open_cv_text"/></a>)</h2>
        <ul>
          <xsl:for-each select="item">
            <li class="bold"><xsl:value-of select="@title"/></li>
            <ul>
              <xsl:for-each select="detail">
                <li><xsl:value-of select="."/></li>
              </xsl:for-each>
            </ul>
            <hr/>
          </xsl:for-each>
          
          <li class="bold no-bullet"><xsl:value-of select="@challenges_title"/>
            <div class="transparent toggle-link" id="challenge-toggle-text" onclick="toggleVisibility('ai-challenges-content', this)">(expand ⇩)</div>
          </li>
          <div id="ai-challenges-content" class="hidden-content">
            <ul>
              <xsl:for-each select="challenges/challengeGroup">
                <li><xsl:value-of select="@name"/></li>
                <ul>
                  <xsl:for-each select="award">
                    <li><xsl:value-of select="@icon"/> <xsl:value-of select="."/></li>
                  </xsl:for-each>
                </ul>
              </xsl:for-each>
            </ul>
          </div>
          <hr/>

          <li class="no-bullet"><xsl:value-of select="@languages_title"/></li>
          <ul>
            <xsl:for-each select="languages/language">
              <li class="language-item">
                <span class="language-name"><xsl:value-of select="@flag"/> <xsl:value-of select="@name"/></span>
                <div class="level-bar-container">
                  <div class="level-bar-fill">
                    <xsl:attribute name="class">level-bar-fill level-<xsl:value-of select="@levelCode"/></xsl:attribute>
                  </div>
                </div>
                &#160; <xsl:value-of select="@levelText"/>
              </li>
            </xsl:for-each>
          </ul>
        </ul>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="workExperience">
    <section class="topic">
      <h2><xsl:value-of select="@title"/></h2>
      <div class="timeline">
        <xsl:for-each select="milestone">
          <div class="milestone">
            <div class="icon"><xsl:value-of select="@icon"/></div>
            <div class="content">
              <div class="title"><xsl:value-of select="title"/></div>
              <div class="date"><xsl:value-of select="date"/></div>
              <div class="location"><xsl:value-of select="location"/></div>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </section>
  </xsl:template>
  
  <xsl:template match="domainFocus">
    <ul>
      <xsl:for-each select="focusArea">
        <li class="bold"><xsl:value-of select="@title"/></li>
        <ul>
          <xsl:for-each select="point">
            <li><xsl:value-of select="."/></li>
          </xsl:for-each>
        </ul>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="skills">
    <ul class="skills-list">
      <xsl:for-each select="skill">
        <li class="skill-item">
          <span class="skill-name"><xsl:value-of select="@name"/></span>
          <div class="skill-bar-container">
            <div class="skill-bar-fill">
              <xsl:attribute name="class">skill-bar-fill level-<xsl:value-of select="@level"/></xsl:attribute>
            </div>
          </div>
          <span class="skill-level-text"><xsl:value-of select="@level"/>/5</span>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="distinctions">
    <section class="topic">
      <h2><xsl:value-of select="@title"/></h2>
      <div class="topic-subsection right-margin left-margin">
        <ul>
          <xsl:for-each select="distinction">
            <li class="bold"><xsl:value-of select="@title"/></li>
            <ul class="circle">
              <xsl:for-each select="detail">
                <li><xsl:value-of select="@date"/></li>
                <li><xsl:value-of select="@location"/></li>
              </xsl:for-each>
            </ul>
          </xsl:for-each>
          <li class="bold"><xsl:value-of select="funding/@title"/></li>
          <ol>
            <xsl:for-each select="funding/grant">
              <li class="bold"><xsl:value-of select="@title"/></li>
              <ul class="circle">
                <xsl:for-each select="detail">
                  <li><xsl:value-of select="@date"/></li>
                  <li><xsl:value-of select="@location"/></li>
                </xsl:for-each>
              </ul>
            </xsl:for-each>
          </ol>
        </ul>
      </div>
    </section>
  </xsl:template>
  
  <xsl:template match="contributions">
    <section class="topic">
      <h2><xsl:value-of select="@title"/></h2>
      <div class="topic-subsection right-margin left-margin">
        <ol>
          <xsl:for-each select="contribution">
            <li><xsl:copy-of select="node()"/></li>
          </xsl:for-each>
        </ol>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="currentDevelopment">
    <section class="topic">
      <h2><xsl:value-of select="@title"/></h2>
      <div class="topic-subsection right-margin left-margin">
        <ul>
          <xsl:for-each select="item">
            <li><xsl:copy-of select="node()"/></li>
          </xsl:for-each>
        </ul>
      </div>
    </section>
  </xsl:template>

</xsl:stylesheet>