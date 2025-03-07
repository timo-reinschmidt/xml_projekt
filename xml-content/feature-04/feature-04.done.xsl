<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>


    <xsl:template match="/">
        <html>
            <head>
                <title>Änderungen bestätigt</title>
                <link rel="stylesheet" type="text/css" href="../theme.css"/>
            </head>
            <body>
                <h1>Änderungen gespeichert!</h1>
                <div class="content">
                    <p>Die folgende Änderung wurde vorgenommen:</p>

                    <ul>
                        <li><strong>Aktion: </strong> <xsl:value-of select="/changes/action"/></li>
                        <li><strong>Plant: </strong> <xsl:value-of select="/changes/plant"/></li>
                        <li><strong>Anbieter: </strong> <xsl:value-of select="/changes/provider"/></li>
                        <xsl:apply-templates select="/changes/*[not(self::action or self::plant or self::provider)]"/>
                    </ul>

                    <a href="../feature-04.xml">Zurück</a>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*">
        <li><strong><xsl:value-of select="name()"/>: </strong> <xsl:value-of select="text()"/></li>
    </xsl:template>
</xsl:stylesheet>