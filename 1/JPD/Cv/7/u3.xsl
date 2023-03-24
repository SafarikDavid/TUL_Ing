<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">
    <html>
    <head><title>Seznam uzivatelu</title></head>
    <body>
    <h1>Seznam uzivatelu </h1>
    <dl>
    <xsl:apply-templates/>
    </dl>
    </body>
    </html>
</xsl:template>

<xsl:template match="osoba">
    <dt><strong><xsl:value-of select="jmeno" /></strong></dt>
    <dd>shell: <xsl:value-of select="shell" /><br/>
        web: <xsl:element name="a"><xsl:attribute name="href">/~<xsl:value-of select="jmeno"/></xsl:attribute>/~<xsl:value-of select="jmeno"/>
        </xsl:element>
    </dd>
</xsl:template>

</xsl:stylesheet>