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

                <h1>Feature #03</h1>
                <small>
                    <a href="loggedIn.xml">Back</a>
                </small>

                <div class="content">

                    <div>
                        <p>
                            <i>Hier können wir die Statistiken Exportieren:
                            </i>
                        </p>
                        <p>
                            <a href="fo.xml" target="_blank">FO download</a>
                            <small>(Direkt im Browser)</small>
                        </p>
                        <p>
                            <a href="#" onclick="createPdf()">PDF Download</a>
                            <small>(Die Daten werden als PDF gerendert und heruntergeladen)</small>
                                <!-- Dummy-Link für den PDF-Download -->
                            <a id="dummyLink"></a>
                        </p>
                        <p>
                            <a href="#" onclick="createCSV()">CSV Download</a>
                            <small>(Die Daten werden als CSV gerendert und heruntergeladen)</small>
                                <!-- Dummy-Link für den CSV-Download -->
                            <a id="dummyLinkCSV"></a>
                        </p>
          
                    </div>

                </div>
                <!-- Javascript-Funktionen für FO-Transformation -->
                <script src="feature-03/fo-functions.js" type="text/javascript"></script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
