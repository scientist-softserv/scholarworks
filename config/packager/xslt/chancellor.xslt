<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc' and @element='type']">
    <field name="resource_type">
      <xsl:choose>
        <xsl:when test="text() = 'Reference Material'">
          <xsl:text>Course Material</xsl:text>
        </xsl:when>
        <xsl:when test="text() = 'Website'">
          <xsl:text>Course Material</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="type_map">
            <xsl:with-param name="value">
              <xsl:value-of select="text()"/>
            </xsl:with-param>
            <xsl:with-param name="include_other">false</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
</xsl:stylesheet>
