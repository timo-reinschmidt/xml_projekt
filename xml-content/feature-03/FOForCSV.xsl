<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <!--  Titel -->
        <xsl:text>Plant Name;Date;Price (CHF)&#10;</xsl:text>
        
        <!-- Jede Plant aus der Datenbank auswäählen -->
        <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
    </xsl:template>

    <!-- Name und Preis wählen -->
    <xsl:template match="plant">
        <xsl:variable name="plantName" select="name"/>

        <xsl:apply-templates select="statistics/price">
            <xsl:with-param name="plantName" select="$plantName"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Jeden einzelnen Preis der Plants anwählen -->
    <xsl:template match="price">
        <xsl:param name="plantName"/>

        <!-- Formatierung damit Name , Datum und Preis in verschiedenen Spalten sind-->
        <xsl:value-of select="$plantName"/>;<xsl:value-of select="@date"/>;<xsl:value-of select="."/>
        <!-- Das ist ein Zeilenumbruch damit es auf der nächsten Zeile weitergehen kann-->
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

</xsl:stylesheet>