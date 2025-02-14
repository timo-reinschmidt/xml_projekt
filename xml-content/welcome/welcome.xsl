<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="menu">
        <html>
            <head>
                <title>INFINERGY</title>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
            </head>
            <body>

                <!-- title and nav  -->
                <h1>INFINERGY</h1>

                <div class="content">

                    <p>
                        <i>Welcome to INFINERGY</i>
                        <br/><br/>
                        <i>the new Informationplattform for Energy and Gas</i>
                    </p>
                    <hr/>
                     <div class="content">
                    <form action="/checkLogin" method="post">
                        <div>
                            <label for="username">Username: </label>
                            <input type="text" name="username" id="username-input" placeholder="username"/>
                        </div>
                        <div>
                            <label for="password">Password: </label>
                            <input type="text" name="password" id="password-input" placeholder="******"/>
                        </div>
                        <button type="submit">Insert</button>
                    </form>
                    </div>
                    <!-- render menu nav  -->
                
                        <xsl:apply-templates select="item">
                            <xsl:sort select="index" data-type="text" order="ascending"/>
                        </xsl:apply-templates>
                
                </div>
                <div class="content">
                    <a href="database/database.xml" target="_blank">
                    show Database
                    </a>
                </div>

            </body>
        </html>
    </xsl:template>

    <!-- single menu item  -->
    <xsl:template match="item">
        <div class="content">
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                <xsl:value-of select="text"/>
            </a>
        </li>
        </div>
    </xsl:template>

</xsl:stylesheet>
