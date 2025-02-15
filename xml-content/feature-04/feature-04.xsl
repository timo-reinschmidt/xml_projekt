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
                                            select="document('../database/database.xml')/energy-data/energy-plant/plant"
                                    >
                                    </xsl:apply-templates>
                                </select>
                            </div>
                            <div>
                                <label for="date-input">Neues Datum</label>
                                <input type="date" name="date" id="date-input"
                                       placeholder="Neues Datum"
                                />
                            </div>
                            <div>
                                <label for="price-input">Neuer Preis</label>
                                <input type="text" name="price" id="price-input"
                                       placeholder="Neuer Preis"
                                />
                            </div>
                            <button type="submit">Einfügen</button>
                        </form>

                        <hr/>

                        <form action="/updateProviderPrice" method="post">
                            <div>
                                <label for="provider-input">Strom Anbiet</label>
                                <select name="provider" id="provider-input">
                                    <xsl:apply-templates select="document('../database/database.xml')/energy-data/provider-data/provider"/>
                                </select>
                            </div>
                            <div>
                                <label for="pricePerKW-input">Neuer Preis pro KW</label>
                                <input type="text" name="pricePerKW" id="pricePerKW-input" placeholder="Neuer Preis pro KW"/>
                            </div>
                            <button type="submit">Preis Aktualisieren</button>
                        </form>

                        <h3>Strom Anbieter</h3>

                        <table>
                            <thead>
                                <tr>
                                    <th>Anbieter Name</th>
                                    <th>Grundgebühr (kW)</th>
                                    <th>Schwelle (kW)</th>
                                    <th>Preis pro kW (CHF)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="document('../database/database.xml')/energy-data/provider-data/provider" mode="table"/>
                            </tbody>
                        </table>

                        <hr/>

                        <h3>Neuen Strom Anbieter hinzufügen</h3>

                        <form action="/addProvider" method="post">
                            <div class="form-group">
                                <label for="provider-name">Anbieter Name</label>
                                <input type="text" name="provider-name" id="provider-name" placeholder="Anbieter Name eingeben" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="base-fee">Grundgebühr (CHF)</label>
                                <input type="number" name="base-fee" id="base-fee" placeholder="Grundgebühr eingeben" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="threshold">Schwelle (kW)</label>
                                <input type="number" name="threshold" id="threshold" placeholder="Schwelle angeben" required="required"/>
                            </div>
                            <div class="form-group">
                                <label for="pricePerKW">Preis pro kW (CHF)</label>
                                <input type="number" name="pricePerKW" id="pricePerKW" placeholder="Preis pro kW eingeben" required="required"/>
                            </div>
                            <div class="button-group">
                                <button type="submit">Anbieter Hinzufügen</button>
                            </div>
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
            <td><xsl:value-of select="tariff/pricePerKW"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>