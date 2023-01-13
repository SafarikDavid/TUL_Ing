<xsl:stylesheet 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

    <xsl:output method="html" indent="yes"/>
    
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>

    <xsl:template match="/">
        <html>
            <table>
                <xsl:apply-templates>
                    <xsl:sort select="x"/>
                </xsl:apply-templates>
            </table>
        </html>
    </xsl:template>

    <xsl:template match="grprvek">
        <tr>
            <td><xsl:value-of select="@id"/></td>
            <td><xsl:value-of select="@typ"/></td>
            <td><xsl:value-of select="pozice/x"/></td>
            <td><xsl:value-of select="pozice/y"/></td>
        </tr>
    </xsl:template>

<xsl:strip-space elements="*"/>

</xsl:stylesheet>