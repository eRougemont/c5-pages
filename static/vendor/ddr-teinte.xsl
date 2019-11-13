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
  <!-- Produce a good control on indentation -->
  <xsl:strip-space elements="*" />
  <xsl:output indent="yes" encoding="UTF-8" method="xml" />
  <xsl:param name="destdir">livres/</xsl:param>
  <xsl:variable name="top" select="document('')"/>
  <xsl:variable name="bookid" select="/*/@xml:id"/>
  <xsl:variable name="split" select="true()"/>
  <xsl:key name="split" match="
    tei:*[self::tei:div or self::tei:div1 or self::tei:div2][normalize-space(.) != ''][@type][
    contains(@type, 'article') 
    or contains(@type, 'chapter') 
    or contains(@subtype, 'split') 
    or contains(@type, 'act')  
    or contains(@type, 'poem')
    or contains(@type, 'letter')
    ] 
    | tei:group/tei:text 
    | tei:TEI/tei:text/tei:*/tei:*[self::tei:div or self::tei:div1 or self::tei:group or self::tei:titlePage  or self::tei:castList][normalize-space(.) != '']" 
    use="generate-id(.)"/>
  <xsl:variable name="bibl">
    <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/node()"/>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:variable name="titlebranch">
      <xsl:call-template name="titlebranch"/>
    </xsl:variable>
    <xsl:call-template name="document">
      <xsl:with-param name="href" select="concat($destdir, $bookid, '/index.html')"/>
      <xsl:with-param name="title" select="$bibl"/>
      <xsl:with-param name="main">
        <header title="{normalize-space($bibl)}">
          <xsl:copy-of select="$bibl"/>
        </header>
        <div class="bookfront">
          <nav class="toclocal">
            <xsl:call-template name="toclocal"/>
          </nav>
          <!--
          <article>
            <xsl:copy-of select="document(concat('../../', $destdir, $bookid, '.html'))"/>
          </article>
          -->
          <figure>
            <img src="../couv/{$bookid}_m.jpg"/>
          </figure>
        </div>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="//tei:div[@type='chapter']">
      <xsl:variable name="chapid">
        <xsl:call-template name="id"/>
      </xsl:variable>
      <xsl:variable name="href" select="concat($destdir, $bookid, '/', $chapid, '.html')"/>
      <xsl:variable name="title">
        <xsl:call-template name="titlebranch"/>
      </xsl:variable>     
      <xsl:variable name="main">
        <xsl:variable name="bibl">
          <xsl:call-template name="bibl"/>
        </xsl:variable>
        <header title="{normalize-space($bibl)}">
          <a href="."><xsl:copy-of select="$bibl"/></a>
        </header>
        <div class="textwin">
          <nav class="toclocal">
            <xsl:call-template name="toclocal"/>
          </nav>
          <article>
            <xsl:apply-templates/>
            <xsl:call-template name="footnotes"/>
          </article>
        </div>
      </xsl:variable>
      <xsl:call-template name="document">
        <xsl:with-param name="href" select="$href"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="main" select="$main"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="tei:div[@type = 'chapter']" mode="id">
    <xsl:text>ch</xsl:text>
    <xsl:number level="any" count="tei:div[@type = 'chapter']"/>
  </xsl:template>
  
  <xsl:template name="document">
    <xsl:param name="href"/>
    <xsl:param name="title"/>
    <xsl:param name="main"/>
    <xsl:document 
      href="{$href}" 
      omit-xml-declaration="yes" 
      encoding="UTF-8" 
      indent="yes"
      >
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
      <html>
        <head>
          <meta charset="UTF-8" />
          <title>
            <xsl:value-of select="$title"/>
          </title>
          <link rel="stylesheet" type="text/css" href="../../static/vendor/teinte.css" />
          <link rel="stylesheet" type="text/css" href="../../static/rougemont.css" />
          <script>const relup = "../../"; </script>
        </head>
        <body class="chapter">
          <header id="header">
            <div id="top"> </div>
          </header>
          <main>
            <xsl:copy-of select="$main"/>
          </main>
          <footer id="footer">
            <div id="bottom"></div>
          </footer>
          <script src="../../static/js/common.js">//</script>
          <script src="../../static/js/chapter.js">//</script>
        </body>
      </html>
    </xsl:document>
  </xsl:template>
</xsl:transform>