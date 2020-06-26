<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"  xmlns:tei="http://www.tei-c.org/ns/1.0"  exclude-result-prefixes="tei">
  <xsl:import href="../../Teinte/xsl/toc.xsl"/>
  <xsl:import href="../../Teinte/xsl/flow.xsl"/>
  <xsl:import href="../../Teinte/xsl/notes.xsl"/>
  <xsl:output indent="yes" encoding="UTF-8" method="xml" omit-xml-declaration="no"/>
  <xsl:param name="bookid" select="/*/@xml:id"/>
  <xsl:variable name="_html"></xsl:variable>
  <xsl:variable name="title_j">
    <xsl:apply-templates select="//title[@level='j'][1]" mode="title"/>
  </xsl:variable>  
  <xsl:template match="/" priority="10">
    <concrete5-cif version="1.0">
      <pages>
        <xsl:for-each select="//tei:div[@type='article']">
          <xsl:call-template name="article"/>
        </xsl:for-each>
      </pages>
    </concrete5-cif>
  </xsl:template>
  
  <xsl:template name="article">
    <xsl:variable name="chapid">
      <xsl:call-template name="id"/>
    </xsl:variable>
    
    <xsl:variable name="name">
      <xsl:variable name="rich">
        <xsl:apply-templates select="." mode="title"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($rich)"/>
    </xsl:variable>
    <xsl:variable name="meta_title">
      <xsl:variable name="rich">
        <xsl:apply-templates select="tei:head/tei:note[1]" mode="title"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($rich)"/>
    </xsl:variable>
    <page path="/articles/{$bookid}/{$chapid}" name="{$name}" package="{$bookid}" template="liseuse" pagetype="liseuse">
      <attributes>
        <attributekey handle="doctype">
          <value>Article</value>
        </attributekey>
        <attributekey handle="bookid">
          <value>
            <xsl:value-of select="$bookid"/>
          </value>
        </attributekey>
        <attributekey handle="meta_title">
          <value>
            <xsl:value-of select="$meta_title"/>
          </value>
        </attributekey>
      </attributes>
      <area name="Main">
        <blocks>
          <block type="content">
            <data table="btContentLocal">
              <record>
                <content>
                  <article>
                    <xsl:apply-templates>
                      <xsl:with-param name="level" select="1"/>
                    </xsl:apply-templates>
                    <xsl:call-template name="footnotes"/>
                  </article>
                </content>
              </record>
            </data>
          </block>
        </blocks>
      </area>
    </page>
  </xsl:template>

  <!-- Identifiant local -->
  <xsl:template match="tei:div[@type = 'article']" mode="id">
    <xsl:value-of select="@xml:id"/>
  </xsl:template>
  

</xsl:transform>
