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

                <!-- Title and nav  -->

                <small>
                    <a href="loggedIn.xml">zurück</a>
                </small>

                <div class="content">

                    <div>
                        <p>
                            <i>Hier können Sie  die Statistiken der Einzelnen Plants Exportieren:
                            </i>
                        </p>
                        <div>
                        <p>
                            <a href="foPlants.xml" target="_blank">FO herunterladen</a>
                            <small>(Direkt im Browser)</small>
                        </p>
                        <p>
                            <a href="#" onclick="createPdf('../foPlants.xml','../feature-03/foPlants.xsl')">PDF herunterladen</a>
                            <small>(Daten als PDF heruntergeladen)</small>
                                <!-- Dummy-Link für den PDF-Download -->
                            <a id="dummyLink"></a>
                        </p>
                        <p>
                            <a href="#" onclick="createCSV('../foPlants.xml','../feature-03/foCSVPlants.xsl')">CSV herunterladen</a>
                            <small>(Daten  als CSV heruntergeladen)</small>
                                <!-- Dummy-Link für den CSV-Download -->
                            <a id="dummyLinkCSV"></a>
                        </p> <br/>
                        </div>
                           <p>
                            <i>Hier können Sie die Statistiken der Einzelnen Stromanbieter Exportieren:
                            </i>
                        </p>
                        <div>
                        <p>
                            <a href="foProviders.xml" target="_blank">FO herunterladen</a>
                            <small>(Direkt im Browser)</small>
                        </p>
                        <p>
                            <a href="#" onclick="createPdf('../foProviders.xml','../feature-03/foProviders.xsl')">PDF herunterladen</a>
                            <small>(Daten als PDF heruntergeladen)</small>
                                <!-- Dummy-Link für den PDF-Download -->
                            <a id="dummyLink"></a>
                        </p>
                        <p>
                            <a href="#" onclick="createCSV('../foProviders.xml','../feature-03/foCSVProviders.xsl')">CSV herunterladen</a>
                            <small>(Daten  als CSV heruntergeladen)</small>
                                <!-- Dummy-Link für den CSV-Download -->
                            <a id="dummyLinkCSV"></a>
                        </p>
                        </div>
          
                    </div>

                </div>
                <!-- Javascript-Funktionen für FO-Transformation -->
                <script src="feature-03/fo-functions.js" type="text/javascript"></script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
