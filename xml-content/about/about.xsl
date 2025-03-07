<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="about">
        <html>
            <head>
                <title>INFINERGY Über Uns</title>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
            </head>
            <body>

                <h1>INFINERGY</h1>
                <small>
                    <a href="index.xml">Startseite</a>
                </small>

                <div class="content">

                    <p>
                        Version:
                        <xsl:value-of select="version"/>
                    </p>
                    <p>
                        Datum:
                        <xsl:value-of select="date"/>
                    </p>

                    <p>
                        Autoren:
                        <xsl:value-of select="authors"/>
                  
                    </p>
                </div>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
