<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
    <xsl:template match="menu">
        <html>
            <head>
                <title>INFINERGY PORTAL</title>
                <link rel="stylesheet" type="text/css" href="https://www.w3schools.com/w3css/4/w3.css"/>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
            </head>
            <body>
                <div class="w3-container w3-padding-16 w3-center">
                    <h1>⚡ INFINERGY PORTAL ⚡ </h1>
                </div>
                <div class="w3-bar w3-padding w3-large w3-center">
                    <a href="about.xml" class="w3-bar-item w3-button ">Über uns</a>
                </div>
                <div class="w3-container w3-padding">
                    <h2 class="w3-center "><i>Willkommen auf der Infinergy Informationsplattform</i></h2>
                    <hr/>
                    <div class="w3-container w3-padding">
                        <div class="w3-row-padding w3-margin-top">
                            <div class="w3-half">
                                <div class="w3-card  w3-padding w3-margin">
                                    <h2 class="w3-center">Portal für Anbieter</h2>
                                    <form action="/checkLogin" method="post">
                                        <label>Benutzername:</label>
                                        <input class="w3-input w3-border" type="text" name="username" placeholder="Benutzername"/>
                                        <label>Passwort:</label>
                                        <input class="w3-input w3-border" type="password" name="password" placeholder="Passwort"/>
                                        <button class="w3-button w3-khaki ">Anmelden</button>
                                    </form>
                                </div>
                            </div>
                            <div class="w3-half">
                                <div class="w3-card w3-padding w3-margin">
                                    <h2 class="w3-center ">Haushaltsportal</h2>
                                    <p class="w3-center">Zugang zu Informationen wie Preisvergleichen und Statistiken</p>
                                    <a href="public.xml" class="w3-button w3-khaki ">Mehr erfahren</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="item">
        <li class="w3-padding w3-hover-light-gray">
            <a class="w3-text-green" href="{link}">
                <xsl:value-of select="text"/>
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>
