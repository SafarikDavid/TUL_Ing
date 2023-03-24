<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:key name="place" match="synopsis/act/scene" use="location"/>

<xsl:template match="/">
<xsl:element name="locations">


<xsl:for-each select="synopsis/act/scene/location[not(.=preceding::*)]">
    <xsl:sort select="../location"/>
    <xsl:element name="location">

        <xsl:element name="location_name">
            <xsl:value-of select="normalize-space(../location)"/>
        </xsl:element>
        
        <xsl:for-each select="key('place', ../location)">
            <xsl:element name="location_use">
                
                <xsl:element name="act_number">
                    <xsl:value-of select="../act_number"/>
                </xsl:element>
                
                <xsl:element name="scene_number">
                    <xsl:value-of select="scene_number"/>
                </xsl:element>

            </xsl:element>
        </xsl:for-each>

    </xsl:element>
</xsl:for-each>

</xsl:element>
</xsl:template>

</xsl:stylesheet>