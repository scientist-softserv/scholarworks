<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/transaction">
        <html>
            <style>
                body {
                    font-family: "Courier New", sans-serif;
                    font-size: 13px;
                    background-color: #efefef;
                }
                dl {
                    margin-bottom: 7px;
                }
                dt {
                    font-weight: bold;
                    float: left;
                    width: 80px;
                    text-align: right;
                    min-height: 10px;
                }
                dd {
                    margin-left: 100px;
                    min-height: 10px;
                }
                ul {
                    margin-left: -2em;
                }

                .record {
                    border: 1px solid #ccc;
                    padding: 10px;
                    margin: 5px;
                    background-color: #fff;
                }
                .record-id {
                    float: left;
                    width: 200px;
                }
                .details {
                    margin-left: 200px;
                }
            </style>
            <body>
                <h1><xsl:value-of select="campus" /></h1>
                <p><strong>Date: </strong> <xsl:value-of select="date" /></p>
                <p><strong>Records to change</strong>: <xsl:value-of select="count(records/record)" /></p>
                <xsl:call-template name="records" />
            </body>
        </html>
    </xsl:template>

    <xsl:template name="records">
        <xsl:for-each select="records/record">
            <div class="record">
                <div class="record-id">
                    <h2><xsl:value-of select ="@id"/></h2>
                </div>
                <div class="details">
                    <xsl:for-each select="change">
                        <h3><xsl:value-of select ="@field"/></h3>
                        <xsl:for-each select="value">
                            <xsl:call-template name="field_value" />
                        </xsl:for-each>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="field_value">
        <dl>
            <dt><xsl:value-of select="@type"/></dt>
            <dd>
                <xsl:choose>
                    <xsl:when test="@multi = 'true'">
                        <ul>
                            <xsl:for-each select="part">
                                <li><xsl:value-of select="text()" /></li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="text()" />
                    </xsl:otherwise>
                </xsl:choose>
            </dd>
        </dl>
    </xsl:template>
</xsl:stylesheet>
