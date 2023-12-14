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

  <xsl:template match="dim:field[@mdschema='dc' and @element='course' and @qualifier='number']">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='course']">
    <field name="related_url">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='audience']">
    <field name="description_note">
      <xsl:text>Audience: </xsl:text><xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='accessibility']">
    <field name="description_note">
      <xsl:text>Accessibility: </xsl:text><xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='college']">
    <field name="college">
      <xsl:text>Accessibility: </xsl:text><xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='role']">
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='repository']">
  </xsl:template>

</xsl:stylesheet>
