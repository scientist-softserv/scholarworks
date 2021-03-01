<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:epdcx="http://purl.org/eprint/epdcx/2006-11-16/"
                xmlns:pq="http://www.etdadmin.com/ns/etdsword"
                xmlns:mets="http://www.loc.gov/METS/"
                version="1.0">
  <xsl:template match="text()" />
  <xsl:template match="/">
    <record>
      <xsl:call-template name="standard" />
      <xsl:call-template name="embargos" />
      <xsl:call-template name="authors" />
      <xsl:call-template name="subjects" />
      <xsl:call-template name="dates" />
      <xsl:call-template name="identifiers" />
      <xsl:call-template name="rights" />
      <xsl:call-template name="descriptions" />
      <xsl:call-template name="relations" />
      <xsl:call-template name="theses" />
      <xsl:call-template name="proquest" />
    </record>
  </xsl:template>

  <!-- STANDARD FIELDS -->
  <xsl:template name="standard">
    <xsl:for-each select="//epdcx:statement">

      <!-- title -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/title'">
        <field name="title">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- alternate title -->
      <xsl:if test="./@epdcx:attributeName='dcTitleAlternate'">
        <field name="alternative_title">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- resource type -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/type' and ./@epdcx:vesURI='http://purl.org/eprint/terms/Type'">
        <field name="resource_type">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='type'">
        <field name="resource_type">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='typeGenre'">
        <field name="resource_type">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- language -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/language' and ./@epdcx:vesURI='http://purl.org/dc/terms/RFC3066'">
        <field name="language">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='recordLanguage'">
        <field name="language">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- citation -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/eprint/terms/bibliographicCitation'">
        <field name="citation">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- EMBARGO FIELDS -->
  <xsl:template name="embargos">
    <xsl:for-each select="//epdcx:statement">

      <!-- embargo until -->
      <xsl:if test="./@epdcx:attributeName='embargoLift' or ./@epdcx:attributeName='embargountil'">
        <field name="embargo_until">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- embargo terms -->
      <xsl:if test="./@epdcx:attributeName='embargoterms'">
        <field name="embargo_terms">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- AUTHOR FIELDS -->
  <xsl:template name="authors">
    <xsl:for-each select="//epdcx:statement">

      <!-- creator -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/creator'">
        <field name="creator">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- photographer -->
      <xsl:if test="./@epdcx:attributeName='dcContributorPhotographer'">
        <field name="contributor" modifier="photographer">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- sponsor -->
      <xsl:if test="./@epdcx:attributeName='dcContributorSponsor'">
        <field name="contributor" modifier="sponsor">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- videographer -->
      <xsl:if test="./@epdcx:attributeName='dcContributorVideographer'">
        <field name="contributor" modifier="videographer">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- player -->
      <xsl:if test="./@epdcx:attributeName='dcContributorPlayer'">
        <field name="contributor" modifier="player">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- speaker -->
      <xsl:if test="./@epdcx:attributeName='dcContributorSpeaker'">
        <field name="contributor" modifier="speaker">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- presenter -->
      <xsl:if test="./@epdcx:attributeName='presenter'">
        <field name="contributor" modifier="presenter">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- contributor -->
      <xsl:if test="./@epdcx:attributeName='contributor'">
        <field name="contributor">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- contributor -->
      <xsl:if test="./@epdcx:attributeName='localContributor'">
        <field name="contributor" modifier="local">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- editor -->
      <xsl:if test="./@epdcx:attributeName='dcContributorEditor'">
        <field name="editor">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- statement of responsibility -->
      <xsl:if test="./@epdcx:attributeName='statementOfResponsibility'">
        <field name="statement_of_responsibility">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- publisher -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/publisher'">
        <field name="publisher">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- SUBJECT FIELDS -->
  <xsl:template name="subjects">
    <xsl:for-each select="//epdcx:statement">

      <!-- subject -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/subject'">
        <field name="subject">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- subject -->
      <xsl:if test="./@epdcx:attributeName='subjectLCC'">
        <field name="subject">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- subject -->
      <xsl:if test="./@epdcx:attributeName='subjectLCSH'">
        <field name="subject">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- subject -->
      <xsl:if test="./@epdcx:attributeName='dcSubjectCategory'">
        <field name="subject">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- subject -->
      <xsl:if test="./@epdcx:attributeName='subjectGeneral'">
        <field name="subject">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- keyword -->
      <xsl:if test="./@epdcx:attributeName='subjectKeywords'">
        <field name="keyword">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- geographical area -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/coverage' and ./@epdcx:vesURI='http://purl.org/dc/terms/spatial'">
        <field name="geographical_area">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='dcCoverageSpatial'">
        <field name="geographical_area">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- DATE FIELDS -->
  <xsl:template name="dates">
    <xsl:for-each select="//epdcx:statement">

      <!-- date created -->
      <xsl:if test="./@epdcx:attributeName='dcDateCreated'">
        <field name="date_created">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- date issued -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/terms/available'">
        <field name="date_issued">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='dcDatePublished'">
        <field name="date_issued">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- copyright date -->
      <xsl:if test="./@epdcx:attributeName='copyrightDate'">
        <field name="date_copyright">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- IDENTIFIER FIELDS -->
  <xsl:template name="identifiers">
    <xsl:for-each select="//epdcx:statement">

      <!-- isbn -->
      <xsl:if test="./@epdcx:attributeName='dcIdentifierIsbn'">
        <field name="isbn">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- identifier -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/elements/1.1/identifier'">
        <field name="identifier">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='dcIdentifierOther'">
        <field name="identifier">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- RIGHTS FIELDS -->
  <xsl:template name="rights">
    <xsl:for-each select="//epdcx:statement">

      <!-- rights holder -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/eprint/terms/copyrightHolder'">
        <field name="rights_holder">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- rights uri -->
      <xsl:if test="./@epdcx:attributeName='rightsURI'">
        <field name="rights_uri">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- license -->
      <xsl:if test="./@epdcx:attributeName='rightsLicense'">
        <field name="license">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- DESCRIPTION FIELDS -->
  <xsl:template name="descriptions">
    <xsl:for-each select="//epdcx:statement">

      <!-- abstract -->
      <xsl:if test="./@epdcx:propertyURI='http://purl.org/dc/terms/abstract'">
        <field name="description">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- oer -->
      <xsl:if test="./@epdcx:attributeName='dcDescriptionOer'">
        <field name="description_note" modifier="oer">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- access -->
      <xsl:if test="./@epdcx:attributeName='dcDescriptionAccess'">
        <field name="description_note" modifier="access">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- feedback -->
      <xsl:if test="./@epdcx:attributeName='dcDescriptionFeedback'">
        <field name="description_note" modifier="feedback">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- description note -->
      <xsl:if test="./@epdcx:attributeName='description'">
        <field name="description_note">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- extent -->
      <xsl:if test="./@epdcx:attributeName='extent'">
        <field name="extent">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- RELATION FIELDS -->
  <xsl:template name="relations">
    <xsl:for-each select="//epdcx:statement">

      <!-- is version of -->
      <xsl:if test="./@epdcx:attributeName='relationIsVersionOf'">
        <field name="relation" modifier="is_version_of">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- has version -->
      <xsl:if test="./@epdcx:attributeName='relationHasVersion'">
        <field name="relation" modifier="has_version">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- replaced by -->
      <xsl:if test="./@epdcx:attributeName='relationIsReplacedBy'">
        <field name="relation" modifier="is_replaced_by">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- replaces -->
      <xsl:if test="./@epdcx:attributeName='relationReplaces'">
        <field name="relation" modifier="replaces">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- requires -->
      <xsl:if test="./@epdcx:attributeName='relationRequires'">
        <field name="relation" modifier="requires">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is part of -->
      <xsl:if test="./@epdcx:attributeName='relationIsPartOf'">
        <field name="is_part_of">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- has part -->
      <xsl:if test="./@epdcx:attributeName='relationHasPart'">
        <field name="relation" modifier="has_part">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is referenced by -->
      <xsl:if test="./@epdcx:attributeName='relationIsReferencedBy'">
        <field name="relation" modifier="is_referenced_by">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is format of -->
      <xsl:if test="./@epdcx:attributeName='relationIsFormatOf'">
        <field name="relation" modifier="is_format_of">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is required by -->
      <xsl:if test="./@epdcx:attributeName='relationIsRequiredBy'">
        <field name="relation" modifier="is_required_by">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- references -->
      <xsl:if test="./@epdcx:attributeName='relationReferences'">
        <field name="relation" modifier="references">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- has format of -->
      <xsl:if test="./@epdcx:attributeName='relationHasFormatOf'">
        <field name="relation" modifier="has_format_of">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- conforms to -->
      <xsl:if test="./@epdcx:attributeName='relationConformsTo'">
        <field name="relation" modifier="conforms_to">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is based on -->
      <xsl:if test="./@epdcx:attributeName='relationIsBasedOn'">
        <field name="relation" modifier="is_based_on">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- is part of series -->
      <xsl:if test="./@epdcx:attributeName='relationIsPartOfSeries'">
        <field name="relation" modifier="is_part_of_series">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- journal -->
      <xsl:if test="./@epdcx:attributeName='relationJournal'">
        <field name="relation" modifier="journal">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- uri -->
      <xsl:if test="./@epdcx:attributeName='relationUri'">
        <field name="relation" modifier="uri">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- relation -->
      <xsl:if test="./@epdcx:attributeName='relation'">
        <field name="relation">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

  <!-- THESIS FIELDS -->
  <xsl:template name="theses">
    <xsl:for-each select="//epdcx:statement">

      <!-- advisor -->
      <xsl:if test="./@epdcx:attributeName='advisor'">
        <field name="advisor">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- committee member -->
      <xsl:if test="./@epdcx:attributeName='committeeMember'">
        <field name="committee_member">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- course description -->
      <xsl:if test="./@epdcx:attributeName='dcCourseDescription'">
        <field name="description_note" modifier="course_description">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- course number -->
      <xsl:if test="./@epdcx:attributeName='dcCourseNumber'">
        <field name="description_note" modifier="course_number">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- course textbook -->
      <xsl:if test="./@epdcx:attributeName='dcCourseTextbook'">
        <field name="description_note" modifier="course_textbook">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- course uri -->
      <xsl:if test="./@epdcx:attributeName='dcCourseUri'">
        <field name="identifier_uri" modifier="course_uri">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- course faculty -->
      <xsl:if test="./@epdcx:attributeName='dcCourseFaculty'">
        <field name="description_note" modifier="course_faculty">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- degree name -->
      <xsl:if test="./@epdcx:attributeName='degree'">
        <field name="degree_name">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>
      <xsl:if test="./@epdcx:attributeName='dcDegree'">
        <field name="degree_name">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

      <!-- department -->
      <xsl:if test="./@epdcx:attributeName='department'">
        <field name="department">
          <xsl:value-of select="epdcx:valueString" />
        </field>
      </xsl:if>

    </for-each>
  </xsl:template>

  <!-- PROQUEST ETD ADMINISTRATOR -->
  <xsl:template name="proquest">
    <xsl:for-each select="//pq:DISS_submission/pq:DISS_description">

      <!-- extent -->
      <xsl:if test="@page_count">
        <field name="extent">
          <xsl:value-of select="@page_count" />
          <xsl:text> pages</xsl:text>
        </field>
      </xsl:if>

      <!-- degree name -->
      <xsl:if test="pq:DISS_degree">
        <field name="degree_name">
          <xsl:value-of select="pq:DISS_degree" />
        </field>
      </xsl:if>

      <!-- degree level -->
      <xsl:if test="@type">
        <field name="degree_level">
          <xsl:value-of select="@type" />
        </field>
      </xsl:if>

      <!-- date issued -->
      <xsl:for-each select="pq:DISS_dates">
        <field name="date_issued">
          <xsl:value-of select="pq:DISS_comp_date" />
        </field>
      </xsl:for-each>

      <!-- department -->
      <xsl:for-each select="pq:DISS_institution">
        <field name="department">
          <xsl:value-of select="pq:DISS_inst_contact" />
        </field>
      </xsl:for-each>

      <!-- advisor -->
      <xsl:for-each select="pq:DISS_advisor/pq:DISS_name">
        <field name="advisor">
          <xsl:call-template name="pq_author" />
        </field>
      </xsl:for-each>

      <!-- committee members -->
      <xsl:for-each select="pq:DISS_cmte_member/pq:DISS_name">
        <field name="committee_member">
          <xsl:call-template name="pq_author" />
        </field>
      </xsl:for-each>

      <!-- subjects -->
      <xsl:for-each select="pq:DISS_categorization/pq:DISS_category">
        <field name="subject">
          <xsl:value-of select="pq:DISS_cat_desc" />
        </field>
      </xsl:for-each>

      <!-- keywords -->
      <xsl:for-each select="pq:DISS_categorization/pq:DISS_keyword">
        <xsl:call-template name="split">
          <xsl:with-param name="pText" select="text()" />
          <xsl:with-param name="pElementName">keyword</xsl:with-param>
          <xsl:with-param name="pSlitter">, </xsl:with-param>
        </xsl:cal-template>
      </xsl:for-each>

    </xsl:for-each>
  </xsl:template>

  <!-- format proquest author -->
  <xsl:template name="pq_author">
    <xsl:value-of select="pq:DISS_fname" />
    <xsl:text>
    </xsl:text>
    <xsl:value-of select="pq:DISS_middle" />
    <xsl:text>
    </xsl:text>
    <xsl:value-of select="pq:DISS_surname" />
  </xsl:template>

  <!-- split a field based on delimiter -->
  <xsl:template match="text()" name="split">
    <xsl:param name="pText" />
    <xsl:param name="pElementName" />
    <xsl:param name="pSlitter" />
    <xsl:if test="string-length($pText) > 0">
      <xsl:variable name="vNextItem" select="substring-before(concat($pText, $pSlitter), $pSlitter)"/>
      <xsl:element name="{$pElementName}">
        <xsl:value-of select="$vNextItem"/>
      </xsl:element>
      <xsl:call-template name="split">
        <xsl:with-param name="pText" select="substring-after($pText, $pSlitter)"/>
        <xsl:with-param name="pElementName" select="$pElementName"/>
        <xsl:with-param name="pSlitter" select="$pSlitter"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
