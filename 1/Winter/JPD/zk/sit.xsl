<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

<xsl:output method="xml" indent="yes"/>

    <xsl:key name="podsite" match="sit/podsit" use="@id"/>

    <xsl:template match="/sit">
        <html>
        <head>
            <title>Seznam hostů sítě</title>
        </head>
        <body>
            <xsl:for-each select="katedra">
                <h2><xsl:value-of select="nazev"/></h2>
                <ul>
                <xsl:for-each select="host">
                    <xsl:if test="@typ = 'pc'">
                        <li><xsl:value-of select="jmeno"/><xsl:text>.</xsl:text>
                        <xsl:value-of select="../domena"/><xsl:text> </xsl:text>
                        <xsl:text>(</xsl:text><xsl:value-of select="@typ"/><xsl:text>) </xsl:text>
                        <xsl:value-of select="key('podsite', podsit)/ip"/></li>
                    </xsl:if>
                </xsl:for-each>
                </ul>
            </xsl:for-each>
        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>