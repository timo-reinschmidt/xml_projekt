<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
                xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
>
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="feature">
        <html>
            <head>
                <title>Energiewerke Mittelland Reloaded</title>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
                <script>
                    function updateProviders() {
                        const plantSelect = document.getElementById("plant");
                        const providerSelect = document.getElementById("provider");
                        providerSelect.innerHTML = "";

                        fetch(`/getProviders?plant=${encodeURIComponent(plantSelect.value)}`)
                                .then(response => response.json())
                                .then(providers => {

                                    const defaultOption = document.createElement("option");
                                    defaultOption.value = "";
                                    defaultOption.textContent = "Bitte wählen";
                                    defaultOption.disabled = true;
                                    defaultOption.selected = true;
                                    providerSelect.appendChild(defaultOption);

                                    providers.forEach(providerName => {
                                        const option = document.createElementNS("http://www.w3.org/1999/xhtml", "option");
                                        option.setAttribute("value", providerName); // Statt option.value
                                        option.textContent = providerName;
                                        providerSelect.appendChild(option);
                                    });

                                })
                                .catch(error => console.error("Fehler beim Abrufen der Anbieter:", error));
                    }

                    function updateProvidersForRemoval() {
                        const plantSelect = document.getElementById("remove-plant");
                        const providerSelect = document.getElementById("remove-provider");
                        providerSelect.innerHTML = "";

                        if (!plantSelect.value) return;

                        fetch(`/getProviders?plant=${encodeURIComponent(plantSelect.value)}`)
                                .then(response => response.json())
                                .then(providers => {
                                    const defaultOption = document.createElement("option");
                                    defaultOption.value = "";
                                    defaultOption.textContent = "Bitte wählen";
                                    defaultOption.disabled = true;
                                    defaultOption.selected = true;
                                    providerSelect.appendChild(defaultOption);

                                    providers.forEach(providerName => {
                                        const option = document.createElementNS("http://www.w3.org/1999/xhtml", "option");
                                        option.value = providerName;
                                        option.textContent = providerName;
                                        providerSelect.appendChild(option);
                                    });
                                })
                                .catch(error => console.error("Fehler beim Abrufen der Anbieter:", error));
                    }
                </script>
            </head>
            <body>

                <h1>Feature #04</h1>
                <small>
                    <a href="loggedIn.xml">Zurück</a>
                </small>

                <div class="content">
                    <div>
                        <h2>Ihr Portal für Preis Anpassungen:</h2>

                        <form action="/updateData" method="post">
                            <div>
                                <label for="plant-input">Plant</label>
                                <select name="plant" id="plant-input">
                                    <xsl:apply-templates
                                            select="document('../database/database.xml')/energy-data/energy-plant/plant">
                                    </xsl:apply-templates>
                                </select>
                            </div>
                            <div>
                                <label for="date-input">Neues Datum</label>
                                <input type="date" name="date" id="date-input" placeholder="Neues Datum"/>
                            </div>
                            <div>
                                <label for="price-input">Neuer Preis</label>
                                <input type="text" name="price" id="price-input" placeholder="Neuer Preis"/>
                            </div>
                            <button type="submit">Einfügen</button>
                        </form>

                        <hr/>

                        <h3>Strom Anbieter</h3>

                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Anbieter Name</th>
                                    <th>Grundgebühr (CHF)</th>
                                    <th>Schwelle (kW)</th>
                                    <th>Faktor</th>
                                    <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                                        <xsl:variable name="latestPriceNode" select="statistics/price[last()]"/>
                                        <xsl:variable name="latestPrice" select="$latestPriceNode"/>
                                        <xsl:variable name="latestDate" select="$latestPriceNode/@date"/>

                                        <th>
                                            <xsl:value-of select="name"/> (<xsl:value-of select="$latestPrice"/> CHF/KW)
                                            <br/>
                                            <small>Zuletzt Aktualisiert: <xsl:value-of select="$latestDate"/></small>
                                        </th>
                                    </xsl:for-each>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="document('../database/database.xml')/energy-data/provider-data/provider" mode="table"/>
                            </tbody>
                        </table>

                        <h3>Strom Anbieter Faktor Aktualisieren</h3>

                        <form action="/updateProviderFactor" method="post">
                            <div>
                                <label for="plant">Plant wählen:</label>
                                <select name="plant" id="plant" onchange="updateProviders()">
                                    <option value="" disabled="disabled" selected="selected">Bitte wählen</option>
                                    <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
                                </select>
                            </div>
                            <div>
                                <label for="provider">Anbieter wählen:</label>
                                <select name="provider" id="provider">
                                    <option value="" disabled="disabled" selected="selected">Bitte Plant zuerest wählen</option>
                                </select>
                            </div>
                            <div>
                                <label for="factor-update">Neuer Faktor:</label>
                                <input type="number" name="factor" id="factor-update" step="0.1" placeholder="Faktor eingeben" required="required"/>
                            </div>
                            <button type="submit">Faktor Aktualisieren</button>
                        </form>

                        <h3>Neuen Strom Anbieter hinzufügen</h3>

                        <form action="/addProvider" method="post">
                            <div>
                                <label for="provider-name">Anbieter Name</label>
                                <input type="text" name="provider-name" id="provider-name" required="required"/>
                            </div>
                            <div>
                                <label for="base-fee">Grundgebühr (CHF)</label>
                                <input type="number" name="base-fee" id="base-fee" required="required"/>
                            </div>
                            <div>
                                <label for="threshold">Schwelle (kW)</label>
                                <input type="number" name="threshold" id="threshold" required="required"/>
                            </div>
                            <div>
                                <label for="factor-new">Faktor</label>
                                <input type="number" name="factor" id="factor-new" step="0.1" required="required"/>
                            </div>
                            <div>
                                <label for="plant">Plant(s) zuweisen:</label>
                                <div class="dropdown">
                                    <button class="dropbtn">Auswahl</button>
                                    <div class="dropdown-content">
                                        <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                                            <label>
                                                <input type="checkbox" name="plants" value="{name}"/>
                                                <xsl:value-of select="name"/>
                                            </label>
                                        </xsl:for-each>
                                    </div>
                                </div>
                            </div>
                            <div class="button-group">
                                <button type="submit">Anbieter Hinzufügen</button>
                            </div>
                        </form>

                        <h3>Strom Anbieter aus Plant entfernen</h3>

                        <form action="/removeProvider" method="post">
                            <div>
                                <label for="remove-plant">Plant wählen:</label>
                                <select name="plant" id="remove-plant" onchange="updateProvidersForRemoval()">
                                    <option value="" disabled="disabled" selected="selected">Bitte wählen</option>
                                    <xsl:apply-templates select="document('../database/database.xml')/energy-data/energy-plant/plant"/>
                                </select>
                            </div>
                            <div>
                                <label for="remove-provider">Anbieter wählen:</label>
                                <select name="provider" id="remove-provider">
                                    <option value="" disabled="disabled" selected="selected">Bitte Plant zuerst wählen</option>
                                </select>
                            </div>
                            <button type="submit">Anbieter Entfernen</button>
                        </form>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="plant">
        <option>
            <xsl:value-of select="name"/>
        </option>
    </xsl:template>

    <xsl:template match="plants">
        <option value="{name}">
            <xsl:value-of select="name"/>
        </option>
    </xsl:template>

    <xsl:template match="provider">
        <option>
            <xsl:value-of select="name"/>
        </option>
    </xsl:template>

    <xsl:template match="provider" mode="table">
        <tr>
            <td><xsl:value-of select="name"/></td>
            <td><xsl:value-of select="base-fee"/></td>
            <td><xsl:value-of select="tariff/threshold"/></td>
            <td><xsl:value-of select="factor"/></td>

            <xsl:variable name="providerFactor" select="factor"/>

            <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                <xsl:variable name="latestPrice" select="statistics/price[last()]"/>

                <xsl:variable name="calculatedPrice">
                    <xsl:choose>
                        <xsl:when test="string-length($latestPrice) > 0 and string-length($providerFactor) > 0">
                            <xsl:value-of select="format-number($latestPrice * $providerFactor, '0.00')"/>
                        </xsl:when>
                        <xsl:otherwise>N/A</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <td>
                    <xsl:text>Berechneter CHF/KW: </xsl:text>
                    <xsl:value-of select="$calculatedPrice"/> CHF
                </td>
            </xsl:for-each>
        </tr>
    </xsl:template>
</xsl:stylesheet>