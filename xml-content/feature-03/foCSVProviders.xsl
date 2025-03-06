<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <!--  Titel -->
        <xsl:text>Kanton;Anbieter Name;Grundkosten (CHF); Faktor; Tariff (Threshold); Kalkulierter Preis (CHF)&#10;</xsl:text>
        
        <!-- Jede Plant aus der Datenbank auswählen -->
        <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
    </xsl:template>

    <!-- Plant und Anbieter wählen -->
    <xsl:template match="plant">
        <xsl:variable name="kanton" select="name"/>

        <xsl:apply-templates select="providers/provider">
            <xsl:with-param name="kanton" select="$kanton"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Jeden einzelnen Provider der Plants anwählen -->
    <xsl:template match="provider">
        <xsl:param name="kanton"/>

        <!-- Formatierung damit Kanton , Anbieter,Grundkosten, Faktor, Tariff und Kalkulierter Preis in verschiedenen Spalten sind-->
        <xsl:value-of select="$kanton"/>;<xsl:value-of select="name"/>;<xsl:value-of select="base-fee"/>;<xsl:value-of select="factor"/>;<xsl:value-of select="tariff/threshold"/>;<xsl:value-of select="calculated-price"/>
        <!-- Das ist ein Zeilenumbruch damit es auf der nächsten Zeile weitergehen kann-->
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

</xsl:stylesheet>