<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE rdf:RDF [
 <!ENTITY  xsd  "http://www.w3.org/2001/XMLSchema#"> 
 <!ENTITY bibo  "http://purl.org/ontology/bibo/">
 <!ENTITY foaf  "http://xmlns.com/foaf/0.1/">
 <!ENTITY  geo  "http://www.w3.org/2003/01/geo/wgs84_pos#"> 
 <!ENTITY skos  "http://www.w3.org/2004/02/skos/core#">
 <!ENTITY doac  "http://ramonantonio.net/doac/0.1/">
 <!ENTITY bio   "http://purl.org/vocab/bio/0.1/"> 
 <!ENTITY vcard "http://www.w3.org/2006/vcard/ns#"> 
 <!ENTITY obo   "http://purl.obolibrary.org/obo/">
 <!ENTITY vivo  "http://vivoweb.org/ontology/core#">
]>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:bio="http://purl.org/vocab/bio/0.1/" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:doac="http://ramonantonio.net/doac/0.1/" 
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:oai="http://www.openarchives.org/OAI/2.0/"
		xmlns:mets="http://www.loc.gov/METS/"
		xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
		xmlns:fgvterms="http://www.fgv.br/terms/"
		xmlns:mods="http://www.loc.gov/mods/v3" 
		xmlns:event="http://purl.org/NET/c4dm/event.owl#" 
		xmlns:gn="http://www.geonames.org/ontology#" 
		xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" 
		xmlns:vivo="http://vivoweb.org/ontology/core#" 
		xmlns:bibo="http://purl.org/ontology/bibo/" 
		xmlns:vcard="http://www.w3.org/2006/vcard/ns#" 
		xmlns:obo="http://purl.obolibrary.org/obo/" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:template match="oai:OAI-PMH">
    <rdf:RDF>
      <xsl:attribute name="xml:base">
        <xsl:value-of select="concat(normalize-space(oai:request),'/set/',oai:request/@set)"/>
      </xsl:attribute>
      <xsl:apply-templates select="oai:ListRecords" />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="oai:ListRecords">
    <xsl:apply-templates select="oai:record" />
  </xsl:template>

  <xsl:template match="oai:record">
    <rdf:Description rdf:about="{normalize-space(oai:header/oai:identifier)}">
      <xsl:attribute name="xml:base">
        <xsl:value-of select="normalize-space(oai:header/oai:identifier)"/>
      </xsl:attribute>
      <xsl:apply-templates select="oai:metadata"/>
    </rdf:Description>
    <xsl:apply-templates select="descendant::mods:name" />
  </xsl:template>

  <xsl:template match="oai:metadata">
    <xsl:apply-templates select="mets:mets"/>
  </xsl:template>

  <xsl:template match="mets:mets">
    <xsl:apply-templates select="mets:dmdSec"/> 
  </xsl:template>

  <xsl:template match="mets:dmdSec">
    <xsl:apply-templates select="mets:mdWrap"/> 
  </xsl:template>

  <xsl:template match="mets:mdWrap[@MDTYPE='MODS']">
    <xsl:apply-templates select="mets:xmlData"/>
  </xsl:template>

  <xsl:template match="mods:titleInfo[mods:title]">
    <xsl:value-of select="mods:title"/>
  </xsl:template>

  <xsl:template match="mods:titleInfo[not(mods:title)]">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="mets:xmlData[mods:mods]">
    <xsl:apply-templates select="mods:mods"/>
  </xsl:template>

  <xsl:template match="mets:xmlData[not(mods:mods)]">
    <xsl:call-template name="content"/>
  </xsl:template>

  <xsl:template match="mods:mods">
    <xsl:call-template name="content" />
  </xsl:template>

  <xsl:template name="content">
    <dc:title><xsl:apply-templates select="mods:titleInfo"/></dc:title>
    <rdfs:label><xsl:apply-templates select="mods:titleInfo"/></rdfs:label>
    <xsl:apply-templates select="mods:originInfo" />
    <xsl:apply-templates select="mods:identifier" />
    <dc:language> <xsl:value-of select="mods:language/mods:languageTerm"/> </dc:language>
    <xsl:apply-templates select="mods:subject" />
    <xsl:apply-templates select="mods:abstract" />
  </xsl:template>

  <xsl:template match="mods:genre">
    <xsl:if test="normalize-space(.) = 'Dissertation'">
      <rdf:type rdf:resource="&bibo;Thesis"/>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:subject[mods:topic]">
    <dcterms:subject> <xsl:value-of select="mods:topic" /> </dcterms:subject>
  </xsl:template>

  <xsl:template match="mods:subject[@authority]">
    <dcterms:subject> <xsl:value-of select="." /> </dcterms:subject>
  </xsl:template>

  <xsl:template match="mods:identifier[@type='uri']">
    <obo:ARG_2000028>
      <rdf:Description>
	<rdf:type rdf:resource="&vcard;Kind"/>
	<vcard:hasURL>
	  <rdf:Description>
	    <rdf:type rdf:resource="&vcard;URL"/>
	    <vivo:rank rdf:datatype="&xsd;int">1</vivo:rank>
	    <vcard:url> <xsl:value-of select="."/> </vcard:url>
	    <rdfs:label>full text</rdfs:label>
	  </rdf:Description>
	</vcard:hasURL>
      </rdf:Description>
    </obo:ARG_2000028>
  </xsl:template>

  <xsl:template match="mods:originInfo">
    <xsl:apply-templates select="mods:dateIssued"/>
  </xsl:template>

  <xsl:template match="mods:dateIssued">
    <vivo:dateTimeValue>
      <rdf:Description>
	<rdf:type rdf:resource="&vivo;DateTimeValue"/>
	<vivo:dateTimePrecision rdf:resource="&vivo;yearMonthDayPrecision"/>
	<vivo:dateTime> <xsl:value-of select="." /> </vivo:dateTime>
      </rdf:Description>
    </vivo:dateTimeValue>
  </xsl:template>

  <xsl:template match="mods:abstract">
    <bibo:abstract>
      <xsl:value-of select="." />
    </bibo:abstract>
  </xsl:template>

  <xsl:template match="mods:name[normalize-space(mods:role/mods:roleTerm) = 'advisor']">
    <rdf:Description>
      <rdf:type rdf:resource="&vivo;AdvisingRelationship"/>
      <vivo:relates>
	<xsl:apply-templates select="mods:namePart"/>
      </vivo:relates>
      <vivo:relates>
	<xsl:apply-templates select="../mods:name[normalize-space(mods:role/mods:roleTerm) = 'author']" mode="ref"/> 
      </vivo:relates>
      <vivo:relates>
	<rdf:Description>
	  <rdf:type rdf:resource="&vivo;AdviseeRole"/>
	  <obo:RO_0000052>
	    <xsl:apply-templates select="../mods:name[normalize-space(mods:role/mods:roleTerm) = 'author']" mode="ref"/>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description>
	  <rdf:type rdf:resource="&vivo;AdvisorRole"/>
	  <obo:RO_0000052>
	    <xsl:apply-templates select="mods:namePart" mode="ref"/>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
    </rdf:Description>	
  </xsl:template>

  <xsl:template match="mods:name[normalize-space(mods:role/mods:roleTerm) = 'author']">
    <rdf:Description>
      <rdf:type rdf:resource="&vivo;Authorship"/>
      <vivo:rank rdf:datatype="&xsd;int">1</vivo:rank>
      <vivo:relates><xsl:apply-templates select="mods:namePart"/></vivo:relates>
      <vivo:relates rdf:resource="{ancestor::oai:record/oai:header/oai:identifier}"/>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="mods:namePart">
    <rdf:Description rdf:nodeID="{generate-id(.)}"> 
      <rdf:type rdf:resource="&foaf;Person"/>
      <rdfs:label><xsl:value-of select="."/></rdfs:label>
      <obo:ARG_2000028>
	<rdf:Description>  
	  <rdf:type rdf:resource="&vcard;Individual"/>
	  <vcard:hasName>
	    <rdf:Description>
	      <rdf:type rdf:resource="&vcard;Name"/>
	      <vcard:fn> <xsl:value-of select="."/> </vcard:fn>
	    </rdf:Description>
	  </vcard:hasName>
	</rdf:Description>
      </obo:ARG_2000028>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="mods:name" mode="ref">
    <xsl:apply-templates select="mods:namePart" mode="ref"/>
  </xsl:template>

  <xsl:template match="mods:namePart" mode="ref">
    <xsl:attribute name="rdf:nodeID">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*|@*">
  </xsl:template>

</xsl:stylesheet>
