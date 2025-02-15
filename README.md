# xml_projekt
Username: admin
Passwort: admin

# START
**Public SSH Key**
1) public SSH Key auf GIT hinterlegen
Schauen ob bereits einer existiert:
   ls ~/.ssh
   cat ~/.ssh/id_ed25519.pub
2) Falls keiner lokal erstellt ist:
   ssh-keygen -t ed25519 -C "deine-email@example.com"
- Wenn du nach einem Speicherort gefragt wirst, drücke einfach Enter, um den Standardpfad (~/.ssh/id_ed25519) zu verwenden. 
- Wenn du nach einer Passphrase gefragt wirst, kannst du entweder eine eingeben (empfohlen) oder Enter drücken, um keine zu setzen.
3) SSH Verbindung überprüfen:
   ssh -T git@github.com

**Projekt Klonen**
git clone git@github.com:timo-reinschmidt/xml_projekt.git
cd xml_projekt


**Nutzung von GIT im Terminal:**

**In welchen Branch befinde ich mich gerade:** (_der aktive branch ist markiert mit einem *_):
git branch

**Branch erstellen:**
git branch _branchNameEingeben_

**In den neuen Branch wechseln:**
git checkout _branchNameEingeben_

**Zur Sicherheit kontrollieren, ob man im richtigen Branch ist:**
git branch


**Änderungen Committen:**
git add .
git commit -m "Update README with latest changes"

**Änderungen Pushen:**
git push -u origin _branchNameEingeben_