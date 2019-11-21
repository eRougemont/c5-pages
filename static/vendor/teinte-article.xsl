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
  <xsl:variable name="bibl">
    <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/node()"/>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <head>
        <meta charset="UTF-8" />
        <title>
          <xsl:copy-of select="$doctitle"/>
        </title>
        <link rel="stylesheet" type="text/css" href="../static/vendor/teinte.css" />
        <link rel="stylesheet" type="text/css" href="../static/rougemont.css" />
        <script>const relup = "../../"; </script>
      </head>
      <body class="chapter">
        <header id="header">
          <div id="top"> </div>
        </header>
        <main>
          <xsl:variable name="bibl">
            <xsl:call-template name="bibl"/>
          </xsl:variable>
          <header title="{normalize-space($bibl)}">
            <a href="#">
              <i>
                <xsl:copy-of select="$doctitle"/>
              </i>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="$docdate"/>
              <xsl:text>)</xsl:text>
            </a>
          </header>
          <div class="textwin">
            <nav class="toclocal">
              <xsl:call-template name="toc"/>
              <xsl:text> </xsl:text>
            </nav>
            <article>
              <xsl:for-each select="/tei:TEI/tei:text/tei:body">
                <xsl:apply-templates />
                <xsl:call-template name="footnotes"/>
              </xsl:for-each>
              <aside class="bibl">
                <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl"/>
              </aside>
            </article>
          </div>
        </main>
        <a href="#" id="gotop">▲</a>
        <footer id="footer">
          <div id="bottom"></div>
        </footer>
        <script src="../static/js/common.js">//</script>
        <script src="../static/js/text.js">//</script>
      </body>
    </html>
  </xsl:template>
  
  
</xsl:transform>