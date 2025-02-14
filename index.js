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

app.post('/updateData', (req, res) => {
    const dataToUpdate = req.body
    // read database xml
    const databasePath = path.resolve('xml-content', 'database', 'database.xml');
    const databaseXml = fs.readFileSync(databasePath, 'utf-8')
    const xmlDocDatabase = libxmljs.parseXml(databaseXml)
    // select node to update
    const plantStatistics = xmlDocDatabase.get(`//plant[name="${dataToUpdate.plant}"]/statistics`);

    // create new node with attribute etc.
    plantStatistics.node('price', dataToUpdate.price).attr('date', dataToUpdate.date)

    console.log(xmlDocDatabase.toString())

    // validate new database against schema
    const valid = validateDatabase(xmlDocDatabase)
    if (!valid) {
        res.status(400).send('Invalid XML')
        return
    }

    // write new database.xml
    fs.writeFileSync(databasePath, xmlDocDatabase.toString(), 'utf-8')

    res.sendStatus(200)
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

function validateDatabase(xmlDocDatabase,nameOfDB) {
    const databaseXsd = fs.readFileSync(path.resolve('xml-content', nameOfDB, nameOfDB + '.xsd'), 'utf-8')
    const xmlDocDatabaseXsd = libxmljs.parseXml(databaseXsd)
    return xmlDocDatabase.validate(xmlDocDatabaseXsd)
}

app.listen(3000, () => {
    console.log('listen on port', 3000)
})
