<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

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

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='provenance']">
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='provenance']">
  </xsl:template>

</xsl:stylesheet>
