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
    <xsl:message terminate="no">
      <xsl:value-of select="$destdir"/>
      <xsl:value-of select="$bookid"/>
    </xsl:message>
    <xsl:call-template name="document">
      <xsl:with-param name="href" select="concat($destdir, $bookid, '/index.html')"/>
      <xsl:with-param name="title" select="$bibl"/>
      <xsl:with-param name="main">
        <div class="bookfront">
          <figure>
            <img src="../couv/{$bookid}_m.jpg"/>
          </figure>
          <div class="cont">
            <article>
              <a href="ch1.html" class="booktitle">
                <i>
                  <xsl:copy-of select="$doctitle"/>
                </i>
                <time>
                  <xsl:text> (</xsl:text>
                  <xsl:value-of select="$docdate"/>
                  <xsl:text>)</xsl:text>
                </time>
                <small class="more"> [Lire…]</small>
              </a>
              <xsl:copy-of select="document(concat('../../', $destdir, $bookid, '.html'))"/>
            </article>
            <nav class="toclocal">
              <button>
                <xsl:attribute name="onclick">
                  if (!this.last) { this.parentNode.className='toclocal all'; this.last = this.innerHTML; this.innerHTML = 'Sommaire -';}
                  else {this.parentNode.className='toclocal'; this.innerHTML = this.last; this.last = null;}
                </xsl:attribute>
                <xsl:text>Sommaire +</xsl:text>
              </button>
              <ul>
                <xsl:apply-templates select="/*/tei:text/tei:front/* | /*/tei:text/tei:body/* | /*/tei:text/tei:group/* | /*/tei:text/tei:back/*" mode="toclocal"/>
              </ul>
            </nav>
          </div>
        </div>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="//tei:div[@type='chapter']">
      <xsl:variable name="chapid">
        <xsl:call-template name="id"/>
      </xsl:variable>
      <xsl:variable name="href" select="concat($destdir, $bookid, '/', $chapid, '.html')"/>
      <xsl:variable name="title">
        <a href=".">
          <i>
            <xsl:copy-of select="$doctitle"/>
          </i>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$docdate"/>
          <xsl:text>)</xsl:text>
        </a>
        <xsl:text> » </xsl:text>
        <a href="#">
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:sort order="descending" select="position()"/>
            <xsl:choose>
              <xsl:when test="self::tei:TEI"/>
              <xsl:when test="self::tei:text"/>
              <xsl:when test="self::tei:body"/>
              <xsl:otherwise>
                <xsl:if test="position() != 1"> » </xsl:if>
                <xsl:apply-templates mode="title" select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </a>
      </xsl:variable>     
      <xsl:variable name="main">
        <header title="{normalize-space($title)}">
          <a title="Rougemont 2.0, accueil" href="../../." class="logo">
            <img title="Rougemont 2.0" class="logo" src="../../static/img/logo_ddr2.svg"/>
          </a>
          <a href="../.">Livres</a>
          <xsl:text> » </xsl:text>
          <xsl:copy-of select="$title"/>
          <a class="top" href="#">↑</a>
        </header>
        <div class="textwin">
          <nav class="toclocal">
            <figure>
              <img src="../couv/{$bookid}_m.jpg"/>
            </figure>
            <xsl:call-template name="toclocal"/>
          </nav>
          <div class="cont">
            <a class="booktitle" href=".">
              <i>
                <xsl:copy-of select="$doctitle"/>
              </i>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="$docdate"/>
              <xsl:text>)</xsl:text>
            </a>
            <xsl:call-template name="prevnext"/>
            <article>
              <xsl:apply-templates/>
              <xsl:call-template name="footnotes"/>
            </article>
            <aside class="bibl">
              <xsl:copy-of select="$bibl"/>
            </aside>
            <xsl:call-template name="prevnext"/>
          </div>
        </div>
      </xsl:variable>
      <xsl:call-template name="document">
        <xsl:with-param name="href" select="$href"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="main" select="$main"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!-- a prev/next navigation -->
  <xsl:template name="prevnext">
    <nav class="prevnext">
      <div class="prev">
        <xsl:for-each select="preceding::*[@type='chapter'][1]">
          <xsl:variable name="title">
            <xsl:call-template name="title"/>
          </xsl:variable>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="normalize-space($title)"/>
            </xsl:attribute>
            <xsl:copy-of select="$title"/>
          </a>
        </xsl:for-each>
        <xsl:text> </xsl:text>
      </div>
      <div class="next">
        <xsl:text> </xsl:text>
        <xsl:for-each select="following::*[@type='chapter'][1]">
          <xsl:variable name="title">
            <xsl:call-template name="title"/>
          </xsl:variable>
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="normalize-space($title)"/>
            </xsl:attribute>
            <xsl:copy-of select="$title"/>
          </a>
        </xsl:for-each>
      </div>
     </nav>
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
          <script src="../../static/js/text.js">//</script>
        </body>
      </html>
    </xsl:document>
  </xsl:template>
</xsl:transform>