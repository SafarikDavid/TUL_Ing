<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

<xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Adresář</title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="adresar">
        <xsl:apply-templates select="nazev"/>
        <ul>
            <li><xsl:apply-templates select="adresar"/></li>
            <xsl:apply-templates select="soubor"/>
        </ul>
    </xsl:template>

    <xsl:template match="adresar/nazev">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <xsl:template match="soubor">
        <li><xsl:value-of select="nazev"/><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="velikost">
        <xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="nazev"/>

    <xsl:strip-space elements="*"/>

</xsl:stylesheet>