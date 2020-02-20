<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"  xmlns:tei="http://www.tei-c.org/ns/1.0"  exclude-result-prefixes="tei">
  <xsl:import href="../../Teinte/xsl/toc.xsl"/>
  <xsl:import href="../../Teinte/xsl/flow.xsl"/>
  <xsl:import href="../../Teinte/xsl/notes.xsl"/>
  <xsl:output indent="yes" encoding="UTF-8" method="xml" omit-xml-declaration="no"/>
  <xsl:param name="bookid" select="/*/@xml:id"/>
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
  <xsl:variable name="_html"></xsl:variable>
  <xsl:variable name="bibl">
    <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/node()"/>
  </xsl:variable>
  

  
  <xsl:template match="/" priority="10">
    <concrete5-cif version="1.0">
      <pages>
        <xsl:call-template name="book"/>
        <xsl:for-each select="//tei:div[@type='chapter']">
          <xsl:call-template name="chapter"/>
        </xsl:for-each>
      </pages>
    </concrete5-cif>
  </xsl:template>
  <xsl:template name="book">
    <xsl:variable name="title">
      <xsl:variable name="rich">
        <xsl:copy-of select="$doctitle"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$docdate"/>
        <xsl:text>)</xsl:text>
      </xsl:variable>
      <xsl:value-of select="normalize-space($rich)"/>
    </xsl:variable>
    <page path="/livres/{$bookid}/toc" name="{$title}" package="{$bookid}" pagetype="livre" template="left_sidebar">
      <attributes>
        <attributekey handle="doctype">
          <value>Chapitre</value>
        </attributekey>
        <attributekey handle="bookid">
          <value>
            <xsl:value-of select="$bookid"/>
          </value>
        </attributekey>
        <attributekey handle="meta_title">
          <value>
            <xsl:value-of select="$title"/>
          </value>
        </attributekey>
      </attributes>
      <area name="Main">
        <blocks>
          <block type="content">
            <data table="btContentLocal">
              <record>
                <content>
                  <nav class="toclocal" id="toc">
                    <button>
                      <xsl:attribute name="onclick"> if (!this.last) { this.parentNode.className='toclocal all'; this.last = this.innerHTML; this.innerHTML = 'Sommaire -';} else {this.parentNode.className='toclocal'; this.innerHTML = this.last; this.last = null;} </xsl:attribute>
                      <xsl:text>Sommaire +</xsl:text>
                    </button>
                    <ul>
                      <xsl:apply-templates select="/*/tei:text/tei:front/* | /*/tei:text/tei:body/* | /*/tei:text/tei:group/* | /*/tei:text/tei:back/*" mode="toclocal"/>
                    </ul>
                  </nav>
                </content>
              </record>
            </data>
          </block>
        </blocks>
      </area>
    </page>
  </xsl:template>
  <xsl:template name="chapter">
    <xsl:variable name="chapid">
      <xsl:call-template name="id"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:variable name="rich">
        <xsl:copy-of select="$doctitle"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$docdate"/>
        <xsl:text>) </xsl:text>
        <xsl:for-each select="ancestor-or-self::*">
          <xsl:sort order="descending" select="position()"/>
          <xsl:choose>
            <xsl:when test="self::tei:TEI"/>
            <xsl:when test="self::tei:text"/>
            <xsl:when test="self::tei:body"/>
            <xsl:otherwise>
              <xsl:if test="position() != 1"> — </xsl:if>
              <xsl:apply-templates mode="title" select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($rich)"/>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:variable name="rich">
        <xsl:apply-templates select="." mode="title"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($rich)"/>
    </xsl:variable>
    <page path="/livres/{$bookid}/{$chapid}" name="{$name}" package="{$bookid}" template="left_sidebar" pagetype="chapitre">
      <attributes>
        <attributekey handle="doctype">
          <value>Chapitre</value>
        </attributekey>
        <attributekey handle="bookid">
          <value>
            <xsl:value-of select="$bookid"/>
          </value>
        </attributekey>
        <attributekey handle="meta_title">
          <value>
            <xsl:value-of select="$title"/>
          </value>
        </attributekey>
      </attributes>
      <area name="Main">
        <blocks>
          <!-- ???
           <block type="page_title" name="">
             <data table="btPageTitle">
               <record>
                 <useCustomTitle><![CDATA[0]]></useCustomTitle>
                 <titleText><![CDATA[Chapitre 1]]></titleText>
               </record>
             </data>
           </block>
           </block>
           -->
          <block type="content">
            <data table="btContentLocal">
              <record>
                <content>
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
                    <!--
                    <xsl:call-template name="footnotes"/>
                    -->
                  </article>
                  <aside class="bibl">
                    <xsl:copy-of select="$bibl"/>
                  </aside>
                  <xsl:call-template name="prevnext"/>
                </content>
              </record>
            </data>
          </block>
        </blocks>
      </area>
      <area name="Sidebar">
        <blocks>
          <block type="content" name="">
            <data table="btContentLocal">
              <record>
                <content>
                  <figure>
                    <img src="https://iiif.unige.ch/iiif/2/1072068135_037/full/pct:90/0/default.jpg"/>
                  </figure>
                  <xsl:call-template name="toclocal"/>
                </content>
              </record>
            </data>
          </block>
        </blocks>
      </area>
    </page>
  </xsl:template>

  <!-- Identifiant local -->
  <xsl:template match="tei:div[@type = 'chapter']" mode="id">
    <xsl:number level="any" count="tei:div[@type = 'chapter']"/>
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
</xsl:transform>
