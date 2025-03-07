<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:template match="calculator">
    <html>
      <head>
        <title>Energieverbrauchsrechner</title>
        <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"/>
        <link rel="stylesheet" type="text/css" href="../theme.css"/>

      </head>

      <body class="w3-padding-large">

        <div class="w3-container w3-white w3-card w3-round-large w3-padding-large" style="max-width: 600px; margin: auto;">
          <h1 class="w3-center">⚡ Energieverbrauchsrechner</h1>

          <!-- Eingabeformular -->
          <form action="/energyCalculator/calculateCost" method="post" class="w3-container">
            <div class="w3-section">
              <!-- Dropdown für Region -->
              <label for="region" class="w3-text-teal"><b>Region auswählen:</b></label>
              <select id="region" name="region" class="w3-select w3-border w3-round">
                <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
              </select>
            </div>

            <div class="w3-section">
              <!-- Eingabefeld für Verbrauch -->
              <label for="verbrauch" class="w3-text-teal"><b>Jahresverbrauch (kWh):</b></label>
              <input type="number" id="verbrauch" name="verbrauch" class="w3-input w3-border w3-round"/>
            </div>

            <!-- Submit für Berechnen-->
            <div class="w3-center">
              <button type="submit" class="w3-button w3-teal w3-round-large ">Berechnen</button>
            </div>
          </form>
          <!-- Zurück-Button -->
          <div class="w3-center w3-margin-top">
            <a href="public.xml" class="w3-button w3-teal w3-round-large ">Zurück</a>
          </div>
        </div>

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
