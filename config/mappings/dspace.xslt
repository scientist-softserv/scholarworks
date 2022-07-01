<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:mets="http://www.loc.gov/METS/"
                version="1.0">

  <!-- records -->
  <xsl:template match="/">
    <records>
      <xsl:for-each select="//mets:dmdSec[@ID='dmdSec_2']/mets:mdWrap/mets:xmlData/dim:dim[@dspaceType='ITEM']">
        <record>
          <xsl:apply-templates />
        </record>
      </xsl:for-each>
    </records>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='advisor']">
    <field name="advisor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor']">
    <field name="creator">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='advisor']">
    <field name="advisor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='author']">
    <field name="creator">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='department']">
    <field name="department">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='editor']">
    <field name="editor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and (@qualifier='committeeMember' or @qualifier='committeemember')]">
    <field name="committee_member">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='primaryAdvisor']">
    <field name="advisor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='contributor' and @qualifier='sponsor']">
    <field name="sponsor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='coverage' and @qualifier='spatial']">
    <field name="geographical_area">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='coverage' and @qualifier='temporal']">
    <field name="time_period">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='creator']">
    <field name="creator">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='date' and not(@qualifier)]">
    <field name="date_issued">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='date' and @qualifier='embargountil']">
    <field name="embargo_release_date">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='date' and @qualifier='issued']">
    <field name="date_issued">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='degree']">
    <field name="degree_name">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description']">
    <field name="description_note">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='abstract']">
    <field name="description">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='department']">
    <field name="department">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='degree']">
    <field name="degree_name">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='provenance']">
    <field name="provenance">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='description' and @qualifier='sponsorship']">
    <field name="sponsor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='format' and @qualifier='extent']">
    <field name="extent">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='format' and @qualifier='technicalinfo']">
    <field name="extent">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='genre']">
    <field name="resource_type">
      <xsl:call-template name="type_map">
        <xsl:with-param name="value">
          <xsl:value-of select="text()"/>
        </xsl:with-param>
        <xsl:with-param name="include_other">false</xsl:with-param>
      </xsl:call-template>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier']">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='bibliographicCitation']">
    <field name="bibliographic_citation">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='citation']">
    <field name="bibliographic_citation">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='isbn']">
    <field name="isbn">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='issn']">
    <field name="issn">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='identifier' and @qualifier='uri']">
    <field name="handle">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='language']">
    <field name="language">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='note']">
    <field name="description_note">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='provenance']">
    <field name="provenance">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='publisher']">
    <field name="publisher">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartof']">
    <field name="is_part_of">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='relation' and @qualifier='ispartofseries']">
    <field name="series">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='relation' and @qualifier='uri']">
    <field name="related_url">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='rights']">
    <field name="rights_note">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='rights' and @qualifier='license']">
    <field name="license">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='rights' and @qualifier='uri']">
    <field name="rights_uri">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='source']">
    <field name="source">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='sponsor']">
    <field name="sponsor">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='subject']">
    <field name="keyword">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='subject' and @qualifier = 'lcc']">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='tableOfContents']">
    <field name="description_note">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='title']">
    <field name="title">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='title' and @qualifier='alternative']">
    <field name="alternative_title">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="dim:field[@mdschema='dc' and @element='type']">
    <field name="resource_type">
      <xsl:call-template name="type_map">
        <xsl:with-param name="value">
          <xsl:value-of select="text()"/>
        </xsl:with-param>
      </xsl:call-template>
    </field>
  </xsl:template>

  <xsl:template name="type_map">
    <xsl:param name="value" />
    <xsl:param name="include_other">true</xsl:param>
    <xsl:variable name="type">
      <xsl:value-of select="translate($value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$type = 'agenda'">Program</xsl:when>
      <xsl:when test="$type = 'animation'">Course Material</xsl:when>
      <xsl:when test="$type = 'article'">Article</xsl:when>
      <xsl:when test="$type = 'articles'">Article</xsl:when>
      <xsl:when test="$type = 'assessment tool'">Course Material</xsl:when>
      <xsl:when test="$type = 'blog'">Article</xsl:when>
      <xsl:when test="$type = 'book'">Book</xsl:when>
      <xsl:when test="$type = 'book chapter'">Book Chapter</xsl:when>
      <xsl:when test="$type = 'book review'">Book Review</xsl:when>
      <xsl:when test="$type = 'book chapter'">Book Chapter</xsl:when>
      <xsl:when test="$type = 'book review'">Book Review</xsl:when>
      <xsl:when test="$type = 'capstone project'">Undergraduate Project</xsl:when>
      <xsl:when test="$type = 'capstoneproject'">Undergraduate Project</xsl:when>
      <xsl:when test="$type = 'case study'">Report</xsl:when>
      <xsl:when test="$type = 'conference poster'">Poster</xsl:when>
      <xsl:when test="$type = 'conference proceeding'">Conference Proceeding</xsl:when>
      <xsl:when test="$type = 'conference program'">Program</xsl:when>
      <xsl:when test="$type = 'conference paper or proceedings'">Conference Proceeding</xsl:when>
      <xsl:when test="$type = 'conference program'">Program</xsl:when>
      <xsl:when test="$type = 'course materials'">Course Material</xsl:when>
      <xsl:when test="$type = 'dataset'">Dataset</xsl:when>
      <xsl:when test="$type = 'dissertation'">Dissertation</xsl:when>
      <xsl:when test="$type = 'doctoral project'">Doctoral Project</xsl:when>
      <xsl:when test="$type = 'exercise'">Course Material</xsl:when>
      <xsl:when test="$type = 'flyer'">Poster</xsl:when>
      <xsl:when test="$type = 'graduate project'">Graduate Project</xsl:when>
      <xsl:when test="$type = 'graph'">Dataset</xsl:when>
      <xsl:when test="$type = 'internal report'">Report</xsl:when>
      <xsl:when test="$type = 'interview'">Interview</xsl:when>
      <xsl:when test="$type = 'journal'">Journal Issue</xsl:when>
      <xsl:when test="$type = 'journal article'">Article</xsl:when>
      <xsl:when test="$type = 'journal issue'">Journal Issue</xsl:when>
      <xsl:when test="$type = 'learning object'">Course Material</xsl:when>
      <xsl:when test="$type = 'learning object repository'">Course Material</xsl:when>
      <xsl:when test="$type = 'letter'">Article</xsl:when>
      <xsl:when test="$type = 'liner notes'">Article</xsl:when>
      <xsl:when test="$type = 'masters thesis'">Masters Thesis</xsl:when>
      <xsl:when test="$type = 'monograph'">Book</xsl:when>
      <xsl:when test="$type = 'online course module'">Course Material</xsl:when>
      <xsl:when test="$type = 'open textbook'">Textbook</xsl:when>
      <xsl:when test="$type = 'oral presentation'">Presentation</xsl:when>
      <xsl:when test="$type = 'paper'">Article</xsl:when>
      <xsl:when test="$type = 'peer reviewed article'">Article</xsl:when>
      <xsl:when test="$type = 'periodical'">Journal Issue</xsl:when>
      <xsl:when test="$type = 'post-print'">Article</xsl:when>
      <xsl:when test="$type = 'poster'">Poster</xsl:when>
      <xsl:when test="$type = 'poster presentation'">Poster</xsl:when>
      <xsl:when test="$type = 'postprint'">Article</xsl:when>
      <xsl:when test="$type = 'preface'">Article</xsl:when>
      <xsl:when test="$type = 'preprint'">Article</xsl:when>
      <xsl:when test="$type = 'presentation'">Presentation</xsl:when>
      <xsl:when test="$type = 'project'">Undergraduate Project</xsl:when>
      <xsl:when test="$type = 'published article'">Article</xsl:when>
      <xsl:when test="$type = 'questionnaire'">Course Material</xsl:when>
      <xsl:when test="$type = 'recording, musical'">Performance</xsl:when>
      <xsl:when test="$type = 'report'">Report</xsl:when>
      <xsl:when test="$type = 'research paper'">Report</xsl:when>
      <xsl:when test="$type = 'review'">Book Review</xsl:when>
      <xsl:when test="$type = 'self assessment'">Course Material</xsl:when>
      <xsl:when test="$type = 'simulation'">Course Material</xsl:when>
      <xsl:when test="$type = 'slide'">Course Material</xsl:when>
      <xsl:when test="$type = 'slides'">Course Material</xsl:when>
      <xsl:when test="$type = 'software'">Course Material</xsl:when>
      <xsl:when test="$type = 'student presentation'">Presentation</xsl:when>
      <xsl:when test="$type = 'student research'">Undergraduate Project</xsl:when>
      <xsl:when test="$type = 'syllabus'">Course Material</xsl:when>
      <xsl:when test="$type = 'table'">Dataset</xsl:when>
      <xsl:when test="$type = 'technical report'">Report</xsl:when>
      <xsl:when test="$type = 'text'">Article</xsl:when>
      <xsl:when test="$type = 'thesis'">Masters Thesis</xsl:when>
      <xsl:when test="$type = 'tutorial'">Course Material</xsl:when>
      <xsl:when test="$type = 'working paper'">Article</xsl:when>
      <xsl:otherwise>
        <xsl:if test="$include_other = 'true'">
          <xsl:text>Other</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- remove any other non-matching element -->
  <xsl:template match="text()"/>

</xsl:stylesheet>
