<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc'][@element='contributor'][@qualifier='sonomaauthor']">
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc'][@element='contributor'][@qualifier='sonomaclassification']">
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartofseries']">
    <field name="source">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='department']">
    <field name="contributor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='department']">
    <field name="contributor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

</xsl:stylesheet>