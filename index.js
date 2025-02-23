const express = require('express')
const path = require('path')
const fs = require('fs')
const libxmljs = require('libxmljs2')
const app = express()

app.use(express.static(path.join(__dirname, 'xml-content')));
app.use(express.text());
app.use(express.urlencoded({ extended: false }));

app.get('/', (req, res) => {
    res.sendFile(path.resolve('xml-content', 'index.xml'));
})

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

    // validate new database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), 'utf-8');

    res.sendStatus(200);
});

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

    // validate database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), 'utf-8');

    res.redirect('/feature-04/feature-04.done.xsl');
});

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

    // Alle Anbieter für die gewählte Plant abrufen
    const providers = plantNode.find("providers/provider/name").map(provider => provider.text());

    res.json(providers);
});

app.post('/addProvider', (req, res) => {
    const { "provider-name": providerName, "base-fee": baseFee, threshold, factor } = req.body;

    if (!providerName || !baseFee || !threshold || !factor) {
        return res.status(400).send("All fields are required.");
    }

    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8');
    const xmlDocDatabase = libxmljs.parseXml(databaseXml);

    const providerID = "p" + Math.floor(Math.random() * 10000);

    const plants = xmlDocDatabase.find("//plant");
    plants.forEach(plant => {
        const providersNode = plant.get("providers");

        // Neuen Provider mit allen Details hinzufügen
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

    // validate new database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    fs.writeFileSync(databasePath, xmlDocDatabase.toString(true), "utf-8");

    res.sendStatus(200);
});

function validateDatabase(xmlDocDatabase) {
    const databaseXsd = fs.readFileSync(path.resolve('xml-content', 'database', 'database.xsd'), 'utf-8')
    const xmlDocDatabaseXsd = libxmljs.parseXml(databaseXsd)
    return xmlDocDatabase.validate(xmlDocDatabaseXsd)
}

app.listen(3000, () => {
    console.log('listen on port', 3000)
})
