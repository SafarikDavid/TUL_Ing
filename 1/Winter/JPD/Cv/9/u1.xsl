<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/uzivatele">
    <xsl:copy>
        <xsl:for-each select="osoba">
            <xsl:sort select="jmeno"/>
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>