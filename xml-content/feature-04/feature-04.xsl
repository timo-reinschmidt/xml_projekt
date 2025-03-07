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
                <script src="/updatingProviderListDropdown.js"></script>
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
                                <input type="text" name="price" id="price-input" placeholder="Min: 2 / Max: 20"/>
                            </div>
                            <button type="submit">Einfügen</button>
                        </form>

                        <hr/>

                        <h3>Strom Anbieter Übersicht</h3>

                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Anbieter Name</th>
                                    <th>Grundgebühr (CHF)</th>
                                    <th>Schwelle (kW)</th>
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
                                <!-- Einzigartige Anbieter sammeln -->
                                <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant/providers/provider[not(name=preceding::providers/provider/name)]">
                                    <xsl:variable name="providerName" select="name"/>

                                    <tr>
                                        <td><xsl:value-of select="$providerName"/></td>
                                        <td><xsl:value-of select="base-fee"/></td>
                                        <td><xsl:value-of select="tariff/threshold"/></td>

                                        <!-- Iteriere über alle Plants -->
                                        <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                                            <xsl:variable name="currentPlantName" select="name"/>

                                            <!-- Suche nach dem Provider in dieser Plant -->
                                            <xsl:variable name="providerData" select="providers/provider[name=$providerName]"/>

                                            <xsl:choose>
                                                <xsl:when test="$providerData">
                                                    <td>
                                                        <xsl:value-of select="$providerData/calculated-price"/> CHF
                                                        <br/>
                                                        <small>Faktor: <xsl:value-of select="$providerData/factor"/></small>
                                                    </td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td>Anbieter ist in dieser Region nicht verfügbar</td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </tr>
                                </xsl:for-each>
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
                                <input type="text" name="provider-name" id="provider-name" placeholder="Anbieter Name" required="required"/>
                            </div>
                            <div>
                                <label for="base-fee">Grundgebühr (CHF)</label>
                                <input type="number" name="base-fee" id="base-fee" placeholder="Min: 0 / Max: 100" required="required"/>
                            </div>
                            <div>
                                <label for="threshold">Schwelle (kW)</label>
                                <input type="number" name="threshold" id="threshold" placeholder="Min: 0 / Max: 1000" required="required"/>
                            </div>
                            <div>
                                <label for="factor-new">Faktor</label>
                                <input type="number" name="factor" id="factor-new" step="0.1" placeholder="Min: 0.1 / Max: 10" required="required"/>
                            </div>
                            <div>
                                <label for="plant">Plant(s) zuweisen:</label>
                                <div class="dropdown">
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

            <!-- Iteriere über alle Plants -->
            <xsl:for-each select="document('../database/database.xml')/energy-data/energy-plant/plant">
                <xsl:variable name="currentPlantName" select="name"/>

                <!-- Suche nach einem passenden Provider in dieser Plant -->
                <xsl:variable name="providerData" select="providers/provider[name=current()/../name]"/>

                <xsl:choose>
                    <xsl:when test="$providerData">
                        <td>
                            <xsl:value-of select="$providerData/calculated-price"/> CHF
                            <br/>
                            <small>Faktor: <xsl:value-of select="$providerData/factor"/></small>
                        </td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>Provider does not exist</td>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </tr>
    </xsl:template>
</xsl:stylesheet>