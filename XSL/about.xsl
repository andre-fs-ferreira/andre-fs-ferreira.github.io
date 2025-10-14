<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>About</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLMDJd/rB7Xj+XyU6K/BEXF8s0FwXG4Tj4e9F/F8Xy6d4+4+4/g+g+g+g+g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="/css/background-pub.css"/>
        <link rel="stylesheet" href="/css/button.css"/>
        <link rel="stylesheet" href="/css/text.css"/>
        <link rel="stylesheet" href="/css/about-page.css"/>
        <style>
          .toggle-link { cursor: pointer; }
          .no-bullet li { list-style-type: none; }
          .transparent { color: rgba(0, 0, 0, 0.312); }
          .language-item { display: flex; align-items: center; margin-bottom: 8px; list-style-type: none; }
          .language-name { width: 150px; flex-shrink: 0; }
          .level-bar-container { height: 12px; width: 250px; background-color: #0000006e; border-radius: 6px; overflow: hidden; }
          .level-bar-fill { height: 100%; background-color: #3498db; transition: width 0.8s ease-in-out; border-radius: 6px; }
          .level-a1 { width: 16.67%; } .level-a2 { width: 33.33%; } .level-b1 { width: 50.00%; } .level-b2 { width: 66.67%; } .level-c1 { width: 83.33%; } .level-c2 { width: 100%; }
          .skills-list { list-style-type: none; padding-left: 0; }
          .skill-item { display: flex; align-items: center; margin-bottom: 8px; font-size: 14px; }
          .skill-name { width: 200px; flex-shrink: 0; }
          .skill-level-text { width: 30px; text-align: right; font-weight: bold; }
          .skill-bar-container { height: 10px; width: 150px; background-color: #0000006e; border-radius: 5px; overflow: hidden; }
          .skill-bar-fill { height: 100%; background-color: #3498db; border-radius: 5px; }
          .level-1 { width: 20%; } .level-2 { width: 40%; } .level-3 { width: 60%; } .level-4 { width: 80%; } .level-5 { width: 100%; }
          .timeline { margin: auto auto; position: relative; }
          .milestone { display: flex; align-items: center; margin: 60px auto; position: relative; opacity: 0; animation: fadeInUp 0.8s ease forwards; max-width: 100%; }
          .icon { width: 80px; height: 80px; background: radial-gradient(circle, #000876, #0112ff); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; z-index: 1; box-shadow: 0 4px 20px rgba(255, 107, 53, 0); position: relative; left: 5%; transform: translateX(-50%); flex-shrink: 0; }
          .content { padding-left: 5%; position: relative; }
          .title { font-size: 24px; font-weight: bold; color: #000000; margin-bottom: 10px; }
          .date { color: #000000; margin-bottom: 5px; }
          .location { color: #000000; font-size: 18px; }
          .milestone:nth-child(1) { animation-delay: 0.2s; } .milestone:nth-child(2) { animation-delay: 0.4s; } .milestone:nth-child(3) { animation-delay: 0.6s; } .milestone:nth-child(4) { animation-delay: 0.8s; }
          @media (max-width: 768px) { body { padding: 0px; } .timeline::before { left: 20px; } .milestone { text-align: left !important; margin: auto auto; } .content { padding: 15px; padding-left: 0; text-align: left !important; margin: 0 0 0 100px; } .icon { position: absolute; left: 1%; top: 50%; transform: translateY(-50%); width: 80px; height: 80px; font-size: 32px; } .title { font-size: 20px; } .location { font-size: 16px; } }
          @media (max-width: 480px) { .milestone { margin: 30px auto; } .icon { width: 50px; height: 50px; font-size: 20px; } .content { padding-left: 0; text-align: left !important; margin: 0 0 0 60px; } .title { font-size: 18px; } .location { font-size: 14px; } }
          .right-margin { margin-right: 5%; } .left-margin { margin-left: 5%; } ul.circle { list-style-type: circle; }
          .cv-link { text-decoration: underline; color: #007bff; cursor: default; transition: color 0.3s ease; }
          .cv-link:hover { color: #ff4500; cursor: pointer; }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="/profile/header"/>
        <main>
          <xsl:apply-templates select="/profile/resume"/>
          <xsl:apply-templates select="/profile/workExperience"/>
          
          <section class="topic">
            <h2>👨‍💻 Domain Focus</h2>
            <div class="topic-subsection right-margin left-margin">
              <xsl:apply-templates select="/profile/domainFocus"/>
            </div>
            <section class="skills-section right-margin left-margin">
              <hr/>
              <h3>Technical Skills
                <div class="transparent toggle-link" onclick="toggleVisibility('skills-challenges-content', this)">(expand ⇩)</div>
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
        
        <script src="/js/mask-wave-mouse.js"></script>
        <script src="/js/responsive.js"></script>
        <script src="/js/moving-content.js"></script>
        <script>
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

  <xsl:template match="resume">
    <section class="topic no-bullet">
      <div class="right-margin">
        <h2>Resume (<a href="{@cv_path}" target="_blank" class="cv-link">open CV</a>)</h2>
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
          
          <li class="bold no-bullet">🎉 Winner of multiple international AI challenges in medical imaging:
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

          <li class="no-bullet">💬 Language levels:</li>
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
      <h2>Work experience</h2>
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
      <h2>🔑 Key Distinctions</h2>
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
      <h2>🎓 Academic &amp; Research Contributions</h2>
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
      <h2>🌐 Current Development</h2>
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