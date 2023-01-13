<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

<xsl:output method="html" indent="yes"/>

    <xsl:key name="podsite" match="sit/podsit" use="@id"/>

    <xsl:template match="/filmoteka">
        <html>
        <head>
            <title>Filmoteka</title>
        </head>
        <body>
            <table>
                <xsl:for-each select="film">
                    <xsl:sort select="nazev"/>
                    <xsl:if test="herci/herec = 'Harrison Ford'">
                        <tr>
                            <td><xsl:value-of select="@id"/></td>
                            <td><xsl:value-of select="nazev"/></td>
                            <td><xsl:value-of select="rezie"/></td>
                            <td><xsl:value-of select="count(herci/herec)"/></td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>