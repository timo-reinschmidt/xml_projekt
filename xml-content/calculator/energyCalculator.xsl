<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:template match="calculator">
    <html>

      <head>
        <title>Energieverbrauchsrechner</title>
        <link rel="stylesheet" type="text/css" href="/theme.css"/>
      </head>

      <body>
        <h1>Energieverbrauchsrechner</h1>

        <!-- Eingabeformular -->
        <form action="/energyCalculator/calculateCost" method="post">
          <div>
            <!-- Dropdown für Region -->
            <label for="region">Region auswählen:</label>
            <select id="region" name="region">
              <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
            </select>
          </div>

          <div>
            <!-- Eingabefeld für Verbrauch -->
            <label for="verbrauch">Jahresverbrauch (kWh):</label>
            <input type="number" id="verbrauch" name="verbrauch"/>
          </div>

          <!-- Submit für Berechnen-->
          <button type="submit">Berechnen</button>

        </form>
      </body>
    </html>
  </xsl:template>

  <!-- Regionen (Plant) als <option> generieren -->
  <xsl:template match="plant">
    <option value="{name}">
      <xsl:value-of select="name"/>
    </option>
  </xsl:template>
</xsl:stylesheet>