<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />

    <xsl:variable name="newline">
        <xsl:text>
        </xsl:text>
    </xsl:variable>

    <xsl:key name="osoby" match="data/zamestnanci/osoba" use="kancelar"/>

    <xsl:template match="/data">
        <hmtl>
        <ul>
        <xsl:for-each select="mistnosti/mistnost">
        <xsl:sort select="nazev"/>
        <xsl:if test="patro = 1">
            <li>
                <xsl:value-of select="$newline"/>
                <strong><xsl:value-of select="nazev"/></strong><xsl:text>,</xsl:text>
                <xsl:value-of select="$newline"/>
                <xsl:text>budova </xsl:text><xsl:value-of select="budova"/>
                <xsl:text>, </xsl:text><xsl:value-of select="patro"/>
                <xsl:text>. patro</xsl:text>
                <xsl:for-each select="key('osoby', @id)">
                    <xsl:if test="position() = 1">
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="$newline"/>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="jmeno"/><xsl:text> </xsl:text><xsl:value-of select="prijmeni"/>
                </xsl:for-each>
                <xsl:value-of select="$newline"/>
            </li>
        </xsl:if>
        </xsl:for-each>
        </ul>
        </hmtl>
    </xsl:template>
    
    <xsl:strip-space elements="*"/>
</xsl:transform>
