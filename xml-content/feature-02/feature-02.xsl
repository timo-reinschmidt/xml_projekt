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

                <h1>Feature #02</h1>
                <small>
                    <a href="public.xml">Back</a>
                </small>

                <div class="content">

                    <div>
                        <p>
                            <i>Here's a logo and some data visualization:</i>
                        </p>

                        <!-- include logo  -->
                        <xsl:call-template name="logo">
                        </xsl:call-template>

                        <!-- include statistics visualization  -->
                        <xsl:apply-templates
                                select="document('../database/database.xml')/energie-data/energie-plant/plant"
                        >
                        </xsl:apply-templates>

                    </div>

                </div>

            </body>
        </html>
    </xsl:template>


    <!-- Global variables -->
    <xsl:variable name="baseline" select="200"/>

    <!-- stats header -->
    <xsl:template match="plant">
        <svg:svg width="600" height="300">

            <svg:text font-size="20" fill="white" x="0" y="50">
                Price statistics <xsl:value-of select="name"/>:
            </svg:text>

            <xsl:apply-templates/>
        </svg:svg>
    </xsl:template>

    <!-- stats bars -->
    <xsl:template match="price">

        <xsl:variable name="x-offset" select="(position() * 50)"/>
        <xsl:variable name="y-offset" select="$baseline"/>
        <xsl:variable name="y" select="$y-offset - text()*8"/>

        <!-- bar -->
        <svg:path>
            <xsl:attribute name="style">
                <xsl:text>fill:</xsl:text>
                rosybrown
            </xsl:attribute>

            <xsl:attribute name="d">
                <!-- move to the lower left corner of the rectangle -->
                <xsl:text>M </xsl:text>
                <xsl:value-of select="$x-offset - 10"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y-offset"/>
                <!-- draw line to the upper left corner of the rectangle -->
                <xsl:text> L </xsl:text>
                <xsl:value-of select="$x-offset - 10"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y"/>
                <!-- draw line to the upper right corner of the rectangle -->
                <xsl:text> L </xsl:text>
                <xsl:value-of select="$x-offset + 10"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y"/>
                <!-- draw line to the lower right corner of the rectangle -->
                <xsl:text> L </xsl:text>
                <xsl:value-of select="$x-offset + 10"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y-offset"/>
                <!-- close path and fill the rectangle -->
                <xsl:text> Z</xsl:text>
            </xsl:attribute>
        </svg:path>

        <!-- bar value -->
        <svg:text style="writing-mode:tb">
            <xsl:attribute name="x">
                <xsl:value-of select="$x-offset"/>
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$y-offset - text()*8"/>
            </xsl:attribute>
            <xsl:value-of select="text()"/>
        </svg:text>

        <!-- bar legend -->
        <svg:text
                fill="white"
        >
            <xsl:attribute name="x">
                <xsl:value-of select="$x-offset - 7"/>
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$baseline + 25"/>
            </xsl:attribute>
            <xsl:value-of select="@date"/>
        </svg:text>

    </xsl:template>

    <!-- logo template -->
    <xsl:template name="logo">
        <svg:svg width="600" height="300">

            <svg:defs>
                <svg:pattern id="img" patternUnits="userSpaceOnUse" width="150" height="50">
                    <svg:image
                            xlink:href="https://www.hslu.ch/-/media/campus/common/images/header/hslu-logo-hslu.svg"
                            width="100" height="50" x="0" y="0"/>
                </svg:pattern>
            </svg:defs>

            <svg:ellipse cx="100" cy="100" rx="100" ry="75" fill="url(#img)" stroke="1"/>

        </svg:svg>
    </xsl:template>

</xsl:stylesheet>
