<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc' and @element='type']">
    <xsl:choose>
      <xsl:when test="text() = 'Letters'">Article</xsl:when>
      <xsl:when test="text() = 'Script'">Article</xsl:when>
      <xsl:when test="text() = 'Pamphlet'">Article</xsl:when>
      <xsl:otherwise>
        <field name="resource_type">
          <xsl:call-template name="type_map">
            <xsl:with-param name="value">
              <xsl:value-of select="text()"/>
            </xsl:with-param>
          </xsl:call-template>
        </field>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
