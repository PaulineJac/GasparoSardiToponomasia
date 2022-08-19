<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:alto="http://www.loc.gov/standards/alto/ns-v4#"
    xpath-default-namespace="http://www.loc.gov/standards/alto/ns-v4#" version="2.0"
    exclude-result-prefixes="xs">
    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="yes"
        xpath-default-namespace="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="Cod174">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Toponomasia</title>
                        <author ref="http://viaf.org/viaf/29875955">Gasparo Sardi</author>
                        <respStmt>
                            <name/>
                            <resp>TEI encoding</resp>
                        </respStmt>
                    </titleStmt>
                    <publicationStmt>
                        <authority role="rightsHolder">Burgerbibliothek Bern</authority>
                        <availability status="restricted">
                            <licence n="cc by nc sa"
                                target="https://creativecommons.org/licenses/by-nc-sa/4.0/"/>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <country>Switzerland</country>
                                <settlement>Bern</settlement>
                                <repository>Burgerbibliothek<ref
                                        target="http://katalog.burgerbib.ch/detail.aspx?ID=340662"
                                    /></repository>
                                <idno type="cote">Cod. 174</idno>
                            </msIdentifier>
                            <msContents>
                                <summary/>
                                <msItem>
                                    <locus/>
                                    <title/>
                                </msItem>
                            </msContents>
                            <physDesc>
                                <objectDesc>
                                    <supportDesc>
                                        <support>
                                            <dim unit="cm">32,5 x 21,5</dim>
                                            <material>paper</material>
                                        </support>
                                        <extent>
                                            <measure unit="page" quantity="182"/>
                                        </extent>
                                    </supportDesc>
                                    <layoutDesc> </layoutDesc>
                                </objectDesc>
                            </physDesc>
                        </msDesc>
                    </sourceDesc>
                </fileDesc>
                <encodingDesc>
                    <projectDesc>
                        <p>This document was created within the framework of the Toponomasia project, which aims to create an application that allows the exploitation of one of the manuscripts containing the Toponomasia of Gasparo Sardi.</p>
                    </projectDesc>
                    <editorialDecl corresp="#automaticTranscription">
                        <correction>
                            <p>OCR uncorrected</p>
                        </correction>
                        <normalization>
                            <p>In order to remain as faithful as possible to the manuscript, the
                                transcription will be strictly diplomatic: we will report only the
                                raw data of the manuscript without resolving any abbreviation.
                                Either an allographic transcription with respect for accents,
                                punctuation, segmentation, spaces, line breaks and word
                                    spelling.<p>
                                    </p>Special characters should be encoded according
                                to MUFI standards to ensure interoperability.</p>
                        </normalization>
                        <punctuation>
                            <p>We maintain the original punctuation.</p>
                        </punctuation>
                    </editorialDecl>
                    <appInfo>
                        <application version="3.0.9" ident="Kraken" when="2022">
                            <label>Kraken</label>
                            <ptr target="https://github.com/mittagessen/kraken"/>
                        </application>
                        <application version="0.10.5c" ident="escriptorium" when="2022">
                            <label>escriptorium</label>
                            <ptr target="https://gitlab.com/scripta/escriptorium"/>
                        </application>
                    </appInfo>
                </encodingDesc>
                <profileDesc>
                    <langUsage>
                        <language ident="lat">latin</language>
                    </langUsage>
                </profileDesc>
                <revisionDesc>
                    <xsl:element name="change">
                        <xsl:attribute name="when">
                            <xsl:value-of select="
                                    format-date(current-date(),
                                    '[Y0001]-[M01]-[D01]')"/>
                        </xsl:attribute>
                        <xsl:attribute name="who">
                            <xsl:text>#PJ</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Creation of the TEI P5 file and encoding of the body
                        text</xsl:text>
                    </xsl:element>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:apply-templates/>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="alto/Tags"/>
    <xsl:template match="alto/Description"/>
    <xsl:template match="alto/Layout"/>
    <xsl:template match="alto">
        <xsl:element name="div" namespace="http://www.tei-c.org/ns/1.0" >
            <xsl:element name="pb" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:attribute name="n">
                    <xsl:value-of
                        select="substring-before(substring(Description/sourceImageInformation/fileName, 10), '.')"/>
                    <xsl:apply-templates/>
                </xsl:attribute>
                <xsl:attribute name="source">
                    <xsl:value-of select="Description/sourceImageInformation/fileName"/>
                    <xsl:apply-templates/>
                </xsl:attribute>
            </xsl:element>
            <xsl:for-each select="Layout/Page/PrintSpace/TextBlock">
                <xsl:choose>
                    <xsl:when test="@TAGREFS = 'BT99'">
                        <xsl:element name="head" namespace="http://www.tei-c.org/ns/1.0">
                            <xsl:for-each select="./TextLine/String">
                                <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                                <xsl:value-of select="@CONTENT"/>
                                <xsl:apply-templates/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@TAGREFS = 'BT98'">
                        <xsl:choose>
                            <xsl:when test=".//TextLine/String[matches(@CONTENT, '^([0-9]|[0-9][0-9]|[0-4][0-9][0-9])\s([A-Z]\S*)')]">
                                <xsl:for-each-group select = ".//String" group-starting-with="@CONTENT[matches(., '^([0-9]|[0-9][0-9]|[0-4][0-9][0-9])\s([A-Z]\S*)')]">
                                   <xsl:element name="list">
                                    <xsl:for-each select="current-group()"> 
                                       <xsl:element name="lb"/>
                                    <xsl:variable name="topo" select="./@CONTENT[ancestor::TextBlock[@TAGREFS = 'BT98']]"/>
                                    <xsl:analyze-string select="$topo" regex="^([0-9]|[0-9][0-9]|[0-4][0-9][0-9])\s([A-Z]\S*)">
                                        <xsl:matching-substring>
                                            <xsl:element name="item">
                                                <xsl:attribute name="n"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="regex-group(2)"/></xsl:attribute></xsl:element>
                                                    <xsl:element name="placeName"
                                                        namespace="http://www.tei-c.org/ns/1.0">
                                                        <xsl:value-of select="regex-group(2)"/>
                                                </xsl:element>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="current()"/>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                    
                                        </xsl:for-each>  
                                   </xsl:element>
                                </xsl:for-each-group>
                            </xsl:when>
                            <xsl:otherwise>
                                    <xsl:for-each
                                        select=".//TextLine/String">
                                        <xsl:element name="lb" namespace="http://www.tei-c.org/ns/1.0"/>
                                        <xsl:value-of select="@CONTENT"/>
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                
                            </xsl:otherwise>
                        </xsl:choose>
                        
                                
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>