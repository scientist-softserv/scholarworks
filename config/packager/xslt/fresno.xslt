<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc'][@element='relation'][@qualifier='hasversion']">
    <field name="identifier_uri">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc'][@element='coverage'][@qualifier='temporal']">
    <field name="keyword">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc'][@element='date'][@qualifier='event']">
    <field name="keyword">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>


</xsl:stylesheet>