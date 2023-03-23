<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <!-- records -->
  <xsl:template match="/record">
    <record>
      <field name="source">Zenodo</field>
      <xsl:apply-templates />
    </record>
  </xsl:template>

  <!-- contributor -->
  <!-- advisor -->
  <!-- committee member -->
  <xsl:template match="contributor">
    <field>
      <xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="type = 'ProjectLeader'">advisor</xsl:when>
          <xsl:when test="type = 'ProjectMember'">committee_member</xsl:when>
          <xsl:otherwise>contributor</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="name"/>
      <xsl:if test="affiliation">
        <xsl:text>::::::</xsl:text><xsl:value-of select="affiliation"/>
      </xsl:if>
    </field>
  </xsl:template>

  <!-- creator -->
  <xsl:template match="creator">
    <field name="creator">
      <xsl:value-of select="name"/>
      <xsl:if test="affiliation">
        <xsl:text>::::::</xsl:text><xsl:value-of select="affiliation"/>
      </xsl:if>
    </field>
  </xsl:template>

  <!-- description -->
  <xsl:template match="description">
    <field name="description">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- doi -->
  <xsl:template match="doi">
    <field name="doi">
      <xsl:text>https://doi.org/</xsl:text><xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- language -->
  <xsl:template match="language">
    <field name="language">
      <xsl:choose>
        <xsl:when test="text() = 'ara'">Aramaic</xsl:when>
        <xsl:when test="text() = 'cat'">Catalan</xsl:when>
        <xsl:when test="text() = 'chi'">Chinese</xsl:when>
        <xsl:when test="text() = 'eng'">English</xsl:when>
        <xsl:when test="text() = 'fre'">French</xsl:when>
        <xsl:when test="text() = 'ger'">German</xsl:when>
        <xsl:when test="text() = 'gre'">Greek</xsl:when>
        <xsl:when test="text() = 'ita'">Italian</xsl:when>
        <xsl:when test="text() = 'jpn'">Japanese</xsl:when>
        <xsl:when test="text() = 'kor'">Korean</xsl:when>
        <xsl:when test="text() = 'por'">Polish</xsl:when>
        <xsl:when test="text() = 'por'">Portuguese</xsl:when>
        <xsl:when test="text() = 'rus'">Russian</xsl:when>
        <xsl:when test="text() = 'spa'">Spanish</xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>

  <!-- license -->
  <xsl:template match="license">
    <field name="license">
      <xsl:choose>
        <xsl:when test="id = 'CC-BY-4.0'">https://creativecommons.org/licenses/by/4.0/</xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>

  <!-- resource type -->
  <xsl:template match="resource-type">
    <field name="resource_type">
      <xsl:choose>
        <xsl:when test="type = 'publication'">
          <xsl:choose>
            <xsl:when test="subtype = 'book'">Book</xsl:when>
            <xsl:when test="subtype = 'section'">Book Chapter</xsl:when>
            <xsl:when test="subtype = 'conferencepaper'">Conference Proceeding</xsl:when>
            <xsl:when test="subtype = 'article'">Article</xsl:when>
            <xsl:when test="subtype = 'preprint'">Article</xsl:when>
            <xsl:when test="subtype = 'report'">Report</xsl:when>
            <xsl:when test="subtype = 'thesis'">Masters Thesis</xsl:when>
            <xsl:when test="subtype = 'workingpaper'">Article</xsl:when>
            <xsl:otherwise>Other</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="type = 'presentation'">Presentation</xsl:when>
        <xsl:when test="type = 'poster'">Poster</xsl:when>
        <xsl:when test="type = 'dataset'">Dataset</xsl:when>
        <xsl:when test="type = 'lesson'">Course Material</xsl:when>
        <xsl:otherwise>Other</xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- title -->
  <xsl:template match="title">
    <field name="title">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- remove any other non-matching element -->
  <xsl:template match="text()"/>

</xsl:stylesheet>
