<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />

    <xsl:variable name="newline">
        <xsl:text>
        </xsl:text>
    </xsl:variable>

    <xsl:key name="celed" match="atlas/system/celed" use="@id"/>

    <xsl:template match="/atlas">
        <html>
            <body>
                <table>
                    <xsl:for-each select="seznam/houba">
                        <xsl:sort select="nazev"/>
                        <xsl:if test="jedlost = 'jedlá'">
                            <tr>
                                <td><xsl:value-of select="nazev"/></td>
                                <td><xsl:value-of select="key('celed', @celed)/nazev"/></td>
                                <td><xsl:value-of select="vyskyt"/></td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
    
</xsl:transform>
