<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">
    <html>
    <head><title>Katalog CD</title></head>
    <body>
    <h2>Katalog CD</h2>
    <xsl:apply-templates/>
    </body>
    </html>
</xsl:template>

<xsl:template match="catalog">
    <table>
    <tbody>
        <tr>
            <th>titul</th>
            <th>umělec</th>
        </tr>
        <xsl:apply-templates>
            <xsl:sort select="title"/>
        </xsl:apply-templates>
    </tbody>
    </table>
</xsl:template>

<xsl:template match="cd">
    <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="title">
    <td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="artist">
    <td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="*"/>

<xsl:strip-space elements="catalog cd"/>

</xsl:stylesheet>