const express = require('express')
const path = require('path')
const fs = require('fs')
const libxmljs = require('libxmljs2')
const app = express()

app.use(express.static(path.join(__dirname, 'xml-content')));
app.use(express.text());
app.use(express.urlencoded({ extended: false }));

const changesLogPath = path.resolve('xml-content/database/last-changes.xml');

/**
 * Lädt die Hauptseite.
 * → XML-Technologie kann keine Server-Anfragen verarbeiten oder Dateien dynamisch bereitstellen.
 */
app.get('/', (req, res) => {
    res.sendFile(path.resolve('xml-content', 'index.xml'));
})

/**
 * Lädt das Änderungsprotokoll.
 * → XSLT kann keine Dateisystem-Operationen durchführen.
 */
app.get('/feature-04/done', (req, res) => {
    res.sendFile(changesLogPath);
});

/**
 * Speichert Änderungen in einer XML-Datei.
 * → XSLT kann keine Dateien auf dem Server erstellen oder bearbeiten.
 */
function saveChangeLog(action, plant, provider, details = {}) {
    const detailsXML = Object.entries(details)
        .map(([key, value]) => `<${key}>${value}</${key}>`)
        .join("\n    ");

    const changesXML = `<?xml version="1.0" encoding="UTF-8"?>
    <?xml-stylesheet type="text/xsl" href="../feature-04/feature-04.done.xsl"?>
    <changes>
        <action>${action}</action>
        <plant>${plant}</plant>
        <provider>${provider}</provider>
        ${detailsXML}
    </changes>`;

    fs.writeFileSync(changesLogPath, changesXML, 'utf-8');
}

/**
 * Konvertiert XML-Daten in ein PDF.
 * → XSLT allein kann keine externen Web-APIs aufrufen oder Binärdateien speichern.
 */
app.post('/convertToPdf', async (req, res) => {
    const response = await fetch('https://fop.xml.hslu-edu.ch/fop.php', {
        method: "POST",
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        body: req.body,
    });
    const responseText = await (await response.blob()).arrayBuffer()
    const buffer = Buffer.from(responseText)
    fs.writeFileSync(path.resolve('temp.pdf'), buffer)
    res.sendFile(path.resolve('temp.pdf'))
})

/**
 * Prüft Login-Daten anhand einer XML-Datenbank.
 * → XSLT kann keine Benutzeranfragen auswerten oder Sessions verwalten.
 */
app.post('/checkLogin', (req, res) => {
    // save the inputs of the user from the POST req body
    let inputUserName = req.body.username;
    let inputPW = req.body.password;

    // read database xml
    const databasePath = path.resolve('xml-content', 'loginDB', 'login.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8')
    const xmlDocDatabase = libxmljs.parseXml(databaseXml)

    // select node to check DB
    const logins = xmlDocDatabase.find(`//login`);

    let loginSuccessful = false;
    // loop through DB and check if userinput exists in the DB

    for (let i = 0; i < logins.length; i++) {

            const usernameNode = logins[i].get('userName');
            const passwordNode = logins[i].get('password');

            const usernameFromDB = usernameNode.text();
            const passwordFromDB = passwordNode.text();

            if (!inputUserName || !inputPW) {
                return res.status(400).send('Fehlende Anmeldedaten.');
            }
    
            if (usernameFromDB === inputUserName && passwordFromDB === inputPW) {
                loginSuccessful = true;
                break;
            }
        }
    if (loginSuccessful) {
        res.sendFile(path.resolve('xml-content', 'loggedIn.xml'));
    } else {
        res.status(401).send('Falscher Benutzername oder Passwort');
    }
})

/**
 * Aktualisiert den Preis einer Plant und speichert ihn in XML.
 * → XSLT kann XML nicht verändern oder auf dem Server speichern.
 */
app.post('/updateData', (req, res) => {
    const { plant, date, price } = req.body;

    if (!plant || !date || !price) {
        return res.status(400).send('Missing plant, date, or price.');
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    const plantNode = xmlDocDatabase.get(`//plant[name[text()='${plant}']]`);
    if (!plantNode) {
        return res.status(404).send("Plant not found.");
    }

    // Neuen Preis zur Plant hinzufügen
    const statisticsNode = plantNode.get("statistics");
    statisticsNode.node("price", price).attr("date", date);

    // Berechne `calculated-price` für alle Provider dieser Plant neu
    updateCalculatedPrice(xmlDocDatabase);

    saveChangeLog('Plant Preis wurde angepasst', plant, 'N/A', { date, price });

    // validate new database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), 'utf-8');

    res.redirect('/feature-04/done');
});

/**
 * Aktualisiert den Faktor eines Anbieters in XML.
 * → XSLT kann keine XML-Daten auf dem Server verändern.
 */
app.post('/updateProviderFactor', (req, res) => {
    const { plant, provider, factor } = req.body;

    if (!plant || !provider || !factor) {
        return res.status(400).send("Missing plant, provider, or factor.");
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    const plantNode = xmlDocDatabase.get(`//plant[name='${plant}']`);
    if (!plantNode) {
        return res.status(404).send("Plant not found.");
    }

    // Suche den Provider anhand des Namens
    const providerNodes = plantNode.find("providers/provider");
    const providerNode = providerNodes.find(node => node.get("name").text() === provider);

    if (!providerNode) {
        return res.status(404).send("Provider not found in selected plant.");
    }

    // Faktor aktualisieren
    providerNode.get("factor").text(factor);

    // `calculated-price` aktualisieren
    updateCalculatedPrice(xmlDocDatabase);

    saveChangeLog('Anbieter Faktor wurde aktualisiert', plant, provider, { factor });

    // validate database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), 'utf-8');

    res.redirect('/feature-04/done');
});

/**
 * Berechnet die neuen Preise anhand des Faktors und speichert sie in XML.
 * → XSLT kann keine serverseitigen Berechnungen durchführen oder XML-Daten verändern.
 */
function updateCalculatedPrice(xmlDocDatabase) {
    const plants = xmlDocDatabase.find("//plant");

    plants.forEach(plant => {
        const latestPriceNode = plant.get("statistics/price[last()]");
        const latestPrice = latestPriceNode ? parseFloat(latestPriceNode.text()) : 0;

        const providers = plant.find("providers/provider");
        providers.forEach(provider => {
            const factorNode = provider.get("factor");
            if (!factorNode) return;

            const factor = parseFloat(factorNode.text());
            const calculatedPrice = (latestPrice * factor).toFixed(2);

            let priceNode = provider.get("calculated-price");
            if (priceNode) {
                priceNode.text(calculatedPrice);
            } else {
                provider.node("calculated-price", calculatedPrice);
            }
        });
    });
}

/**
 * Gibt alle Anbieter einer Plant zurück.
 * → XSLT kann keine serverseitigen JSON-Responses erzeugen.
 */
app.get('/getProviders', (req, res) => {
    const { plant } = req.query;

    if (!plant) {
        return res.status(400).json({ error: "Plant not specified" });
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    const plantNode = xmlDocDatabase.get(`//plant[name[text()='${plant}']]`);
    if (!plantNode) {
        return res.status(404).json({ error: `Plant '${plant}' not found` });
    }

    const providersSet = new Set();
    plantNode.find("providers/provider/name").forEach(provider => providersSet.add(provider.text()));

    res.json(Array.from(providersSet));
});

/**
 * Fügt einen neuen Anbieter hinzu und speichert ihn in XML.
 * → XSLT kann keine XML-Daten auf dem Server verändern oder speichern.
 */
app.post('/addProvider', (req, res) => {
    const { "provider-name": providerName, "base-fee": baseFee, threshold, factor, plants } = req.body;

    if (!providerName || !baseFee || !threshold || !factor || !plants) {
        return res.status(400).send("All fields are required.");
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    // Plants aus Mehrfachauswahl
    const selectedPlants = Array.isArray(plants) ? plants : [plants];

    selectedPlants.forEach(plantName => {
        const plantNode = xmlDocDatabase.get(`//plant[name[text()='${plantName}']]`);
        if (!plantNode) {
            console.error(`Plant '${plantName}' not found.`);
            return;
        }

        const providersNode = plantNode.get("providers");

        // Neuen Provider hinzufügen
        const newProvider = new libxmljs.Element(xmlDocDatabase, "provider");
        newProvider.node("name", providerName);
        newProvider.node("base-fee", baseFee);
        newProvider.node("factor", factor);

        const tariff = newProvider.node("tariff");
        tariff.node("threshold", threshold);

        providersNode.addChild(newProvider);
    });

    // Berechne den `calculated-price` neu
    updateCalculatedPrice(xmlDocDatabase);

    saveChangeLog('Anbieter wurde hinzugefügt', selectedPlants.join(', '), providerName, { baseFee, threshold, factor });

    // Validate XML
    const valid = validateDatabase(xmlDocDatabase);
    if (!valid) {
        res.status(400).send('Invalid XML');
        return;
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), "utf-8");

    res.redirect('/feature-04/done');
});

/**
 * Entfernt einen Anbieter aus der XML-Datenbank.
 * → XSLT kann keine XML-Daten löschen.
 */
app.post('/removeProvider', (req, res) => {
    const { plant, provider } = req.body;

    if (!plant || !provider) {
        return res.status(400).send("Plant oder Provider nicht ausgewählt.");
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    const plantNode = xmlDocDatabase.get(`//plant[name[text()='${plant}']]`);
    if (!plantNode) {
        return res.status(404).send("Plant nicht gefunden.");
    }

    const providerNode = plantNode.get(`providers/provider[name[text()='${provider}']]`);
    if (!providerNode) {
        return res.status(404).send("Provider existiert nicht in dieser Plant.");
    }

    providerNode.remove();

    saveChangeLog('Anbieter wurde entfernt', plant, provider, {});

    // Validierung gegen Schema
    const valid = validateDatabase(xmlDocDatabase);
    if (!valid) {
        return res.status(400).send("Invalid XML-Datenstruktur.");
    }

    // Speichert die aktualisierte XML-Datei
    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), 'utf-8');

    res.redirect('/feature-04/done');
});

function validateDatabase(xmlDocDatabase) {
    const databaseXsd = fs.readFileSync(path.resolve('xml-content', 'database', 'database.xsd'), 'utf-8')
    const xmlDocDatabaseXsd = libxmljs.parseXml(databaseXsd)
    return xmlDocDatabase.validate(xmlDocDatabaseXsd)
}

// Einbindung des Energieverbrauchsrechners
const energyCalculatorRouter = require('./xml-content/calculator/energyCalculator');
app.use('/energyCalculator', energyCalculatorRouter);
app.use('/calculator', express.static(path.join(__dirname, 'xml-content/calculator')));

app.listen(3000, () => {
    console.log('listen on port', 3000)
})
