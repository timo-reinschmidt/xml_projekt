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

                <h1>Feature #04</h1>
                <small>
                    <a href="index.xml">Home</a>
                </small>

                <div class="content">

                    <div>
                        <p>
                            <i>Class successfully updated:</i><br/>
                            <small>(hit CTRL+F5 to clear cache)</small>
                        </p>

                        <ul>
                            <xsl:apply-templates
                                    select="document('../database/database.xml')/school-register/statistics"
                            >
                            </xsl:apply-templates>
                        </ul>

                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="class">
        <li>
            Class <xsl:value-of select="@name"/>:
            <strong>
                <xsl:value-of select="text()"/>
            </strong>
        </li>
    </xsl:template>

</xsl:stylesheet>
