const express = require('express');
const path = require('path');
const fs = require('fs');
const libxmljs = require('libxmljs2');

const router = express.Router();
router.post('/calculateCost', (req, res) => {
  const { region, verbrauch } = req.body;

  if (!region || isNaN(verbrauch) || verbrauch <= 0) {
    return res.status(400).send("Fehler: Ungültige Eingaben.");
  }

  const databasePath = path.resolve('xml-content', 'database', 'database.xml');
  const databaseXml = fs.readFileSync(databasePath, 'utf-8');
  const xmlDocDatabase = libxmljs.parseXml(databaseXml);

  const plantNode = xmlDocDatabase.get(`//plant[name[text()='${region}']]`);
  if (!plantNode) {
    return res.status(400).send("Fehler: Keine Region gefunden.");
  }

  const providers = plantNode.find("providers/provider");
  if (!providers.length) {
    return res.status(400).send("Fehler: Keinen Anbieter gefunden.");
  }

  // XML-Datei für die Ergebnisse erstellen
  let xmlResult = `<?xml version="1.0" ?> 
<?xml-stylesheet type="text/xsl" href="calculateCostResult.xsl"?>
<results><calculatorResults><region>${region}</region><verbrauch>${verbrauch}</verbrauch>`;

  providers.forEach(provider => {
    const name = provider.get("name").text();
    const baseFee = parseFloat(provider.get("base-fee").text());
    const factor = parseFloat(provider.get("factor").text());
    const threshold = parseFloat(provider.get("tariff/threshold").text());

    let totalCost;
    if (verbrauch > threshold) {
      totalCost = baseFee + (threshold * factor) + ((verbrauch - threshold) * (factor * 1.2));
    } else {
      totalCost = baseFee + (verbrauch * factor);
    }

    xmlResult += `
  <provider>
    <name>${name}</name>
    <totalCost>${totalCost.toFixed(2)}</totalCost>
  </provider>`;
  });

  xmlResult += `</calculatorResults></results>`;

// Datei speichern in calculateResult.xml
  const resultPath = path.resolve('xml-content/calculator/calculateResult.xml');
  console.log("XML-Inhalt vor dem Speichern:\n", xmlResult);
  fs.writeFileSync(resultPath, xmlResult, 'utf-8');
  res.redirect('/calculator/calculateResult.xml');
});

module.exports = router;