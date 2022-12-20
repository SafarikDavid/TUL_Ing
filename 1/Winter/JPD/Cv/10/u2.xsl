<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>


<xsl:template match="/synopsis">
<xsl:element name="html"> 
<xsl:element name="head"/>
<xsl:element name="body"> 
<xsl:element name="table"> 

    <xsl:element name="tr">
        <xsl:element name="td">#</xsl:element>
        <xsl:element name="td">dějství</xsl:element>
        <xsl:element name="td">scéna</xsl:element>
        <xsl:element name="td">lokace</xsl:element>
    </xsl:element>    
  
    <xsl:for-each select="act/scene">

        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:number value="position()" format="1." />
            </xsl:element>
            
            <xsl:element name="td">
                <xsl:value-of select="substring(../act_number,5)"/>
            </xsl:element>
            
            <xsl:element name="td">
                <xsl:value-of select="substring(scene_number,7)"/>
            </xsl:element>
            
            <xsl:element name="td">
                <xsl:value-of select="normalize-space(location)"/>
            </xsl:element>
        </xsl:element> 
        
    </xsl:for-each>
    
</xsl:element>
</xsl:element>
</xsl:element>  
</xsl:template>

</xsl:stylesheet> 