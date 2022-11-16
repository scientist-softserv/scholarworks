<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:esploro="http://www.loc.gov/MARC21/slim"
                version="1.0">
  <!-- records -->
  <xsl:template match="/">
    <records>
      <xsl:for-each select="//oai:record">
        <record>
          <field name="source">
            <xsl:value-of select="oai:header/oai:identifier" />
          </field>
          <field name="external_id">
            <xsl:value-of select="oai:header/oai:identifier" />
          </field>
          <field name="external_modified_date">
            <xsl:value-of select="oai:header/oai:datestamp" />
          </field>
          <field name="external_url">
            <xsl:value-of select="oai:metadata/esploro:record/esploro:identifier.uri"/><xsl:text>#files_and_links</xsl:text>
          </field>
          <xsl:call-template name="action" />
          <xsl:apply-templates select="oai:metadata/esploro:record/esploro:data" />
        </record>
      </xsl:for-each>
    </records>
  </xsl:template>

  <!-- action -->
  <xsl:template name="action">
    <xsl:for-each select="oai:metadata/esploro:record/esploro:data">
      <xsl:if test="not(esploro:filesList) or not(esploro:identifier.handle)">
        <field name="action">
          <xsl:text>delete</xsl:text>
        </field>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="oai:header[@status='deleted']">
      <field name="action">
        <xsl:text>delete</xsl:text>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- resource type -->
  <xsl:template match="esploro:resourcetype.esploro">
      <xsl:choose>
        <xsl:when test="../esploro:etd/esploro:diss.type">
          <field name="resource_type">
            <xsl:choose>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Doctoral Thesis'">
                <xsl:text>Dissertation</xsl:text>
              </xsl:when>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Thesis'">
                <xsl:text>Masters Thesis</xsl:text>
              </xsl:when>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Project' and text() = 'etd.doctoral'">
                <xsl:text>Doctoral Project</xsl:text>
              </xsl:when>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Masters Project'">
                <xsl:text>Graduate Project</xsl:text>
              </xsl:when>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Project' and text() = 'etd.graduate'">
                <xsl:text>Graduate Project</xsl:text>
              </xsl:when>
              <xsl:when test="../esploro:etd/esploro:diss.type = 'Project'">
                <xsl:text>Undergraduate Project</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="../esploro:etd/esploro:diss.type"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:when>
        <xsl:when test="text() = 'creativeWork.fiction'">
          <field name="note">
            <xsl:text>Fiction</xsl:text>
          </field>
          <field name="resource_type">
            <xsl:text>Article</xsl:text>
          </field>
        </xsl:when>
        <xsl:when test="text() = 'creativeWork.poetry'">
          <field name="note">
            <xsl:text>Poetry</xsl:text>
          </field>
          <field name="resource_type">
            <xsl:text>Article</xsl:text>
          </field>
        </xsl:when>
        <xsl:when test="text() = 'publication.bookReview'">
          <field name="resource_type">
            <xsl:text>Book Review</xsl:text>
          </field>
          <field name="resource_type">
            <xsl:text>Article</xsl:text>
          </field>
        </xsl:when>
        <xsl:when test="text() = 'publication.encyclopediaEntry'">
          <field name="note">
            <xsl:text>Encyclopedia Entry</xsl:text>
          </field>
          <field name="resource_type">
            <xsl:text>Article</xsl:text>
          </field>
        </xsl:when>
        <xsl:otherwise>
          <field name="resource_type">
            <xsl:choose>
              <xsl:when test="text() = 'conference.conferencePaper'">Conference Paper</xsl:when>
              <xsl:when test="text() = 'conference.conferencePoster'">Poster</xsl:when>
              <xsl:when test="text() = 'creativeWork.film'">Film</xsl:when>
              <xsl:when test="text() = 'creativeWork.musicalComposition'">Performance</xsl:when>
              <xsl:when test="text() = 'dataset.dataset'">Dataset</xsl:when>
              <xsl:when test="text() = 'etd.graduate'">Masters Thesis</xsl:when>
              <xsl:when test="text() = 'other.other'">Other</xsl:when>
              <xsl:when test="text() = 'publication.book'">Book</xsl:when>
              <xsl:when test="text() = 'publication.bookChapter'">Book Chapter</xsl:when>
              <xsl:when test="text() = 'publication.conferenceProceeding'">Conference Proceeding</xsl:when>
              <xsl:when test="text() = 'publication.editedBook'">Book</xsl:when>
              <xsl:when test="text() = 'publication.journalArticle'">Article</xsl:when>
              <xsl:when test="text() = 'publication.journalIssue'">Journal Issue</xsl:when>
              <xsl:when test="text() = 'publication.magazineArticle'">Article</xsl:when>
              <xsl:when test="text() = 'publication.newsletterArticle'">Article</xsl:when>
              <xsl:when test="text() = 'publication.newspaperArticle'">Article</xsl:when>
              <xsl:when test="text() = 'publication.report'">Report</xsl:when>
              <xsl:when test="text() = 'publication.technicalDocumentation'">Report</xsl:when>
              <xsl:when test="text() = 'conference.conferencePresentation'">Presentation</xsl:when>
              <xsl:when test="text() = 'conference.conferenceProgram'">Program</xsl:when>
              <xsl:when test="text() = 'conference.presentation'">Presentation</xsl:when>
              <xsl:when test="text() = 'creativeWork.essay'">Article</xsl:when>
              <xsl:when test="text() = 'creativeWork.exhibitionCatalog'">Other</xsl:when>
              <xsl:otherwise>
                <xsl:text>Other</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- handle -->
  <xsl:template match="esploro:identifier.handle">
    <field name="handle">
      <xsl:text>http://hdl.handle.net/</xsl:text>
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- creator -->
  <xsl:template match="esploro:creators">
    <xsl:for-each select="esploro:creator">
      <field name="creator">
        <xsl:value-of select="esploro:creatorname"/>
        <xsl:call-template name="orcid" />
      </field>
    </xsl:for-each>
  </xsl:template>

  <!-- contributor -->
  <!-- advisor -->
  <!-- committee member -->
  <xsl:template match="esploro:contributors">
    <xsl:for-each select="esploro:contributor">
      <field>
        <xsl:attribute name="name">
          <xsl:choose>
            <xsl:when test="esploro:role = 'Committee Member'">
              <xsl:text>committee_member</xsl:text>
            </xsl:when>
            <xsl:when test="esploro:role = 'Advisor'">
              <xsl:text>advisor</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>contributor</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="esploro:contributorname"/>
        <xsl:call-template name="orcid" />
      </field>
    </xsl:for-each>
  </xsl:template>

  <!-- orcid subfield -->
  <xsl:template name="orcid">
    <xsl:if test="esploro:identifier.orcid">
      <xsl:text>:::::::::</xsl:text>
      <xsl:value-of select="esploro:identifier.orcid" />
    </xsl:if>
  </xsl:template>

  <!-- title -->
  <xsl:template match="esploro:title">
    <field name="title">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- date issued -->
  <xsl:template match="esploro:date.submitted">
    <field name="date_issued">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="esploro:date.published">
    <field name="date_issued">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <xsl:template match="esploro:conferencedate">
    <field name="date_issued">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- keyword -->
  <xsl:template match="esploro:keywords">
    <field name="keyword">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- department -->
  <xsl:template match="esploro:asset.affiliation">
    <field name="department">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- description -->
  <xsl:template match="esploro:description.abstract">
    <field name="description">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- language -->
  <xsl:template match="esploro:language">
    <field name="language">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- publisher (theses) -->
  <xsl:template match="esploro:etd/esploro:degree.grantor">
    <field name="publisher">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- degree level -->
  <xsl:template match="esploro:etd/esploro:degree.level">
    <xsl:if test="text() = 'Masters' or text() = 'Doctoral' or text() = 'Undergraduate'">
      <field name="degree_level">
        <xsl:value-of select="text()"/>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- degree name -->
  <xsl:template match="esploro:etd/esploro:degree.name">
    <field name="degree_name">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- degree program -->
  <xsl:template match="esploro:etd/esploro:degree.program">
    <field name="degree_program">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- doi -->
  <xsl:template match="esploro:identifier.doi">
    <field name="doi">
      <xsl:text>https://doi.org/</xsl:text><xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- other identifiers -->
  <xsl:template match="esploro:identifier.pmid">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>
  <xsl:template match="esploro:identifier.pmcid">
    <field name="identifier">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- related_url -->
  <xsl:template match="esploro:links">
    <xsl:for-each select="esploro:link">
      <xsl:if test="not(contains(esploro:link.url, 'doi.org'))">
        <field name="related_url">
          <xsl:value-of select="esploro:link.url" />
        </field>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="esploro:publisher">
    <field name="publisher">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="esploro:publication.place">
    <field name="place">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- discipline -->
  <xsl:template match="esploro:discipline.summon">
    <field name="subject">
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- journal -->
  <!-- publication title -->
  <xsl:template match="esploro:relationships">
    <xsl:for-each select="esploro:relationship">
      <xsl:if test="esploro:relationtype = 'ispartof'">
        <field name="publication_title">
          <xsl:value-of select="esploro:relationtitle" />
        </field>
        <xsl:apply-templates />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- pages -->
  <xsl:template match="esploro:spage">
    <field name="pages">
      <xsl:value-of select="text()" />
      <xsl:if test="../esploro:epage">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="../esploro:epage" />
      </xsl:if>
    </field>
  </xsl:template>

  <xsl:template match="esploro:pages">
    <field name="extent">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- volume -->
  <xsl:template match="esploro:volume">
    <field name="volume">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- issn -->
  <xsl:template match="esploro:isbn">
    <field name="isbn">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>
  <xsl:template match="esploro:eisbn">
    <field name="isbn">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- issn -->
  <xsl:template match="esploro:issn">
    <field name="issn">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>
  <xsl:template match="esploro:eissn">
    <field name="issn">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- conference location -->
  <xsl:template match="esploro:conferencelocation">
    <field name="place">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- conference location -->
  <xsl:template match="esploro:conferencename">
    <field name="meeting_name">
      <xsl:value-of select="text()" />
    </field>
  </xsl:template>

  <!-- remove any other non-matching element -->
  <xsl:template match="text()"/>

</xsl:stylesheet>
