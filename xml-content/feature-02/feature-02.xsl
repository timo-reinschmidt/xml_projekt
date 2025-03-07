<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:svg="http://www.w3.org/2000/svg">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>


    <!-- Transformation als HTML über das nachfolgende XSL-Template -->
    <xsl:template match="feature">
        <html>
            <head>
                <title>Plattform Infinergy</title>
                <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"/>
            </head>
            <body>
                <header>
                    <h1 class="w3-container w3-text-deep-purple">Aktuelle Preise in Ihrer Region</h1>
                    <nav class="w3-bar w3-text-deep-purple w3-padding">
                        <a href="public.xml" class="w3-bar-item w3-button">Zurück</a>
                        <!-- Bestehende Energiewerke der XML-Datenbank werden für die Abbildung der Navigationsleiste verwendet auf Basis des
                        template match="plant".
                        Dadurch soll sichergestellt werden, dass jede Überschrift eine eigene Verlinkung bekommt und somit der User schneller
                        zur jeweiligen Statistik kommt. Die Entwicklung der Lösung basiert auf:
                        1. W3schools (https://www.w3schools.com/xml/xsl_for_each.asp)
                        2. Vorlesungsunterlagen
                        3. Grundlagen aus dem Modul "Webtechnologien"
                        4. In Anlehnung an ChatGPT -->
                        <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                            <a href="#{translate(name, ' ', '_')}" class="w3-bar-item w3-button">
                                <xsl:value-of select="name"/>
                            </a>
                        </xsl:for-each>
                    </nav>
                    <hr/>
                </header>
                <div class="w3-padding">
                    <div>
                        <h2 id="Anleitung" class="w3-text-deep-purple">Die Preisansicht</h2>
                        <div class="w3-row-padding w3-text-deep-purple">
                            <p>
                                Die aktuelle Strompreisentwicklung Ihrer Region können Sie hier leicht
                                nachvollziehen.
                                Wählen Sie über die Navigation den entsprechenden Standort aus, um direkt zur
                                jeweiligen Statistik zu springen und die Preise je Stromanbieter einzusehen.
                            </p>
                        </div>
                    </div>
                </div>
                <hr/>
                <div class="w3-padding">
                    <!-- Navigation und Diagramme werden aus dem in Zeile 62 implementierten Templates generiert.-->
                    <xsl:apply-templates
                            select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Template für jedes Energiewerk (plant) Balkendiagramm.
    Für die Ableitung der Lösung wurden die nachfolgenden Hilfsmittel herangezogen:
    1. Vorlesungsunterlagen "XML & JSON Technologies" insbesondere zu SVG
    2. Vorlesungsunterlagen "Webtechnologien" insbesondere Einsatz von Canvas
    3. W3schools (https://www.w3schools.com/xml/xsl_functions.asp)
    4. Grundgerüst xml-example-node
    5. Anlehnung an ChatGPT
    6. SelfHTML (https://wiki.selfhtml.org/wiki/Datenvisualisierung/Balken-_und_Kreisdiagramme)-->
    <xsl:template match="plant">
        <div class="plant-container" style="margin-bottom:30px;" id="{translate(name, ' ', '_')}">
            <h2 class="w3-text-deep-purple">Stromanlage:
                <xsl:value-of select="name"/>
            </h2>
            <hr></hr>
            <!-- Parameter für das Balkendiagramm -->
            <xsl:variable name="marginLeft" select="20"/>
            <xsl:variable name="marginTop" select="10"/>
            <xsl:variable name="marginBottom" select="20"/>
            <xsl:variable name="barHeight" select="20"/>
            <xsl:variable name="barSpace" select="15"/>
            <!-- Gesamtanzahl der Balken: 1 für Selbstkosten + Anzahl der Anbieter -->
            <xsl:variable name="totalBars" select="1 + count(providers/provider)"/>
            <xsl:variable name="chartHeight"
                          select="$marginTop + $totalBars * ($barHeight + $barSpace) + $marginBottom"/>
            <!-- Definition des Startpunkts -->
            <xsl:variable name="xAxisY" select="$chartHeight - $marginBottom"/>

            <svg:svg width="100%" height="{$chartHeight}" viewBox="0 0 100% {$chartHeight}" style="overflow:visible;">
                <!-- x-Achse -->
                <svg:line x1="{$marginLeft}" y1="{$xAxisY}" x2="100%" y2="{$xAxisY}" stroke="black" stroke-width="1"/>
                <!-- y-Achse -->
                <svg:line x1="{$marginLeft}" y1="{$marginTop}" x2="{$marginLeft}" y2="{ $chartHeight - $marginBottom}"
                          stroke="black" stroke-width="1"/>


                <!-- Balken für "Herstellungskosten" (Letzter Preis) -->
                <xsl:variable name="selfCost" select="statistics/price[last()]"/>
                <xsl:variable name="selfCostValue" select="number($selfCost)"/>
                <!-- Die Breite des Balkens entspricht dem Datenwert multipliziert mit scale-Wert von 8 Pixeln -->
                <xsl:variable name="selfBarWidth" select="$selfCostValue * 8"/>
                <!-- Platzierung: erster Balken, oberster Balken -->
                <xsl:variable name="yPosSelf" select="$marginTop"/>
                <svg:rect x="{$marginLeft}" y="{$yPosSelf}" width="{$selfBarWidth}" height="{$barHeight}"
                          fill="#283593"/>
                <svg:text x="{ $marginLeft + $selfBarWidth + 5 }" y="{ $yPosSelf + $barHeight div 2 }" font-size="12"
                          fill="darkblue" text-anchor="start" dominant-baseline="middle">
                    Herstellungskosten des Kraftwerks:
                    <xsl:value-of select="$selfCost"/> Rappen pro kw/h
                </svg:text>

                <!-- Balken für die Anbieterpreise -->
                <xsl:for-each select="providers/provider">
                    <xsl:variable name="providerIndex" select="position()"/>
                    <!-- Berechnung der vertikalen Positionen des Balkens -->
                    <xsl:variable name="yPos" select="$marginTop + ($barHeight + $barSpace) * ($providerIndex)"/>
                    <xsl:variable name="provValue" select="number(calculated-price)"/>
                    <xsl:variable name="provBarWidth" select="$provValue * 8"/>
                    <svg:rect x="{$marginLeft}" y="{$yPos}" width="{$provBarWidth}" height="{$barHeight}"
                              fill="#00ACC1"/>
                    <svg:text x="{ $marginLeft + $provBarWidth + 5 }" y="{ $yPos + $barHeight div 2 }" font-size="12"
                              fill="darkblue" text-anchor="start" dominant-baseline="middle">
                        <xsl:value-of select="name"/>:
                        <xsl:value-of select="calculated-price"/> in Rappen pro kw/h
                    </svg:text>
                </xsl:for-each>

                <!-- Durchschnittslinie als vertikale Linie -->
                <xsl:variable name="providerPrices" select="providers/provider/calculated-price"/>
                <xsl:variable name="sumProvider" select="sum($providerPrices)"/>
                <xsl:variable name="avgProvider" select="$sumProvider div count($providerPrices)"/>
                <xsl:variable name="avgX" select="$marginLeft + $avgProvider * 8"/>
                <svg:line x1="{$avgX}"
                          y1="{$marginTop}"
                          x2="{$avgX}"
                          y2="{ $marginTop + $totalBars * ($barHeight + $barSpace) }"
                          stroke="grey" stroke-width="2" stroke-dasharray="5,5"/>
                <svg:text x="{ $avgX + 5 }"
                          y="{ $marginTop - 10}"
                          font-size="12" fill="darkblue" text-anchor="start" dominant-baseline="inherit">
                    Durchschnitt:
                    <xsl:value-of select="format-number($avgProvider, '0')"/> Rappen pro kw/h
                </svg:text>
            </svg:svg>
        </div>
    </xsl:template>
</xsl:stylesheet>
