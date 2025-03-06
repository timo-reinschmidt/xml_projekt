<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:output method="xml" encoding="UTF-8"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="stats" page-height="29.7cm" page-width="21cm"
                                       margin-top="1cm" margin-bottom="2cm"
                                       margin-left="2.5cm" margin-right="2.5cm">
                    <fo:region-body margin-top="1cm"/>
                    <fo:region-before extent="2cm"/>
                    <fo:region-after extent="3cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="stats">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center" font-size="8pt">
                        Infinergy - Anbieter Preis Statistiken
                        <fo:page-number/>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="19pt" font-family="sans-serif"
                              line-height="24pt" space-after.optimum="20pt"
                              color="black" text-align="left">
                        Infinergy - Anbieter Preis Statistiken
                    </fo:block>

                    <fo:table space-after.optimum="20pt" width="100%" font-size="11pt">
                        <fo:table-column column-width="20%"/>
                        <fo:table-column column-width="20%"/>
                        <fo:table-column column-width="15%"/>
                        <fo:table-column column-width="15%"/>
                        <fo:table-column column-width="15%"/>
                        <fo:table-column column-width="15%"/>

                        <fo:table-header>
                            <fo:table-row background-color="black" color="white">
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Kanton</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Anbieter Name</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Grundkosten (CHF)</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Faktor</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Tariff (Threshold)</fo:block>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <fo:block font-weight="bold" text-align="left">Kalkulierter Preis (CHF)</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body>
                            <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
                        </fo:table-body>
                    </fo:table>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <!-- Plant mit Kanton (Name) auslesen -->
    <xsl:template match="plant">
        <xsl:variable name="kanton" select="name"/>
        <xsl:apply-templates select="providers/provider">
            <xsl:with-param name="kanton" select="$kanton"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Anbieter-Daten mit Kanton ausgeben  -->
    <xsl:template match="provider">
        <xsl:param name="kanton"/>
        <fo:table-row>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="$kanton"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="name"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="base-fee"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="factor"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="tariff/threshold"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="5pt">
                <fo:block text-align="left">
                    <xsl:value-of select="calculated-price"/> CHF
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

</xsl:stylesheet>