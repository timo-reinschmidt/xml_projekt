<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <!-- hier werden die Resultate dem Benutzer im Frondend angezeigt -->

  <xsl:template match="results">
    <html>
      <head>
        <title>Berechnungsergebnisse</title>
        <link rel="stylesheet" type="text/css" href="/theme.css"/>
      </head>
      <body>
        <h1>Ergebnisse für <xsl:value-of select="calculatorResults/region"/></h1>
        <p>Jahresverbrauch: <strong><xsl:value-of select="calculatorResults/verbrauch"/> kWh</strong></p>

        <table border="1">
          <thead>
            <tr>
              <th>Anbieter</th>
              <th>Gesamtkosten (CHF)</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="calculatorResults/provider">
              <xsl:sort select="totalCost" data-type="number" order="ascending"/>
              <tr>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="totalCost"/> CHF</td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>

        <br/>
        <a href="../calculator.xml">Neue Berechnung starten</a>
      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>
