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
                            <i>Let's create a printable energie statistics:
                            </i>
                        </p>
                        <p>
                            <a href="fo.xml" target="_blank">create FO</a>
                            <small>(directly in browser with XSTL)</small>
                        </p>
                        <p>
                            <a href="#" onclick="createPdf()">create PDF</a>
                            <small>(create FO and render as PDF via web service)</small>
                        </p>
                        <!-- Dummy-Link for PDF-Download -->
                        <a id="dummyLink"></a>
                    </div>

                </div>
                <!-- Javascript-Functions for FO-Transformation -->
                <script src="feature-03/fo-functions.js" type="text/javascript"></script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
