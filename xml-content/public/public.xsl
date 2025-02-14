<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:template match="menu">
        <html>
            <head>
                <title>INFINERGY PUBLIC</title>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
            </head>
            <body>

                <!-- title and nav  -->
                <h1>INFINERGY PUBLIC</h1>

                <small>
                    <a href="index.xml">Home</a>
                </small>
                <div class="content">
                   <p>
                        <i>The following functions are for the public</i>
                    </p>
                    <hr/>

                    <!-- render menu nav  -->
                    <ul>
                        <xsl:apply-templates select="item">
                            <xsl:sort select="index" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
                    </ul>
                    <hr></hr>
               
                </div>

            </body>
        </html>
    </xsl:template>

    <!-- single menu item  -->
    <xsl:template match="item">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <xsl:value-of select="text"/>
            </a>
        </li>
    </xsl:template>

</xsl:stylesheet>