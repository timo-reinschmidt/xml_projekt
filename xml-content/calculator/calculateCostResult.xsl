<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <!-- hier werden die Resultate dem Benutzer im Frontend angezeigt -->

  <xsl:template match="results">
    <html>
      <head>
        <title>Berechnungsergebnisse - Infinergy</title>
        <!-- W3.CSS einbinden -->
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"/>
      </head>
      <body class="w3-light-green w3-padding-large">

        <div class="w3-container w3-white w3-card w3-round-large w3-padding-large" style="max-width: 800px; margin: auto;">
          <h1 class="w3-center w3-text-green">🌱 Infinergy - Ihre Berechnungsergebnisse</h1>
          <h2 class="w3-center w3-text-blue">
            Ihre Region: <xsl:value-of select="calculatorResults/region"/>
          </h2>
          <h3 class="w3-center w3-text-teal">
            Ihr Jahresverbrauch: <strong><xsl:value-of select="calculatorResults/verbrauch"/> kWh</strong>
          </h3>

          <table class="w3-table w3-bordered w3-striped w3-hoverable w3-white">
            <thead class="w3-green">
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
          <div class="w3-center">
            <a href="../calculator.xml" class="w3-button w3-green w3-round-large w3-hover-blue ">Neue Berechnung starten</a>
          </div>
        </div>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
