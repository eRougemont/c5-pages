<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei" 
  >
  <xsl:import href="../../../Teinte/xsl/toc.xsl"/>
  <xsl:import href="../../../Teinte/xsl/flow.xsl"/>
  <xsl:import href="../../../Teinte/xsl/notes.xsl"/>
  <!-- Pour indentation -->
  <xsl:strip-space elements="*" />
  <xsl:output indent="yes" encoding="UTF-8" method="xml" />
  <!-- Fixé par l’appelant -->
  <xsl:variable name="id"/>
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>
          <xsl:copy-of select="$doctitle"/>
        </title>
        <link rel="stylesheet" type="text/css" href="../static/rougemont.css" />
        <script>const relup = "../../"; </script>
      </head>
      <body class="chapter">
        <header id="header">
          <div id="top"> </div>
        </header>
        <main>
          <header>
            Articles
          </header>
          <div>
            <xsl:for-each select="/*/file">
              <xsl:variable name="name" select="substring-before(., '.')"/>
              <xsl:for-each select="document(.)">
                <a href="{$name}.html">
                  <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl"/>
                </a>
              </xsl:for-each>
            </xsl:for-each>
          </div>
        </main>
        <a href="#" id="gotop">▲</a>
        <footer id="footer">
          <div id="bottom"></div>
        </footer>
        <script src="../static/js/common.js">//</script>
      </body>
    </html>
  </xsl:template>
  
  
</xsl:transform>