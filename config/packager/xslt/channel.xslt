<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='editor']">
    <field name="contributor">
      <xsl:value-of select="text()"/><xsl:text> (editor) </xsl:text>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='editor']">
    <field name="contributor">
      <xsl:value-of select="text()"/><xsl:text> (editor) </xsl:text>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartofseries']">
    <field name="source">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='issn']">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='isbn']">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='advisor']">
    <field name="contributor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='advisor']">
    <field name="contributor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

</xsl:stylesheet>
