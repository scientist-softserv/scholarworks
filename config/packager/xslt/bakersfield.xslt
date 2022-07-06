<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="config/mappings/dspace.xslt" />

  <xsl:template match="dim:field[@mdschema='dc' and @element='format' and not(@qualifier)]">
    <field name="resource_type">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

</xsl:stylesheet>