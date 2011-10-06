<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                
                version="2.0"
                exclude-result-prefixes="cals ve o r m v wp w10 w wne mml tbx iso tei a xs pic fn">
	
	  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI Utility stylesheet for making Word docx files from TEI XML (see tei-docx.xsl)</p>
         <p> This library is free software; you can redistribute it and/or
			modify it under the terms of the GNU Lesser General Public License as
			published by the Free Software Foundation; either version 2.1 of the
			License, or (at your option) any later version. This library is
			distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
			without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
			PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
			details. You should have received a copy of the GNU Lesser General Public
			License along with this library; if not, write to the Free Software
			Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id: iso-variables.xsl 7608 2010-05-24 15:39:43Z rahtz $</p>
         <p>Copyright: 2008, TEI Consortium</p>
      </desc>
   </doc>
	
	
	  <xsl:variable name="ANNEX">ANNEX</xsl:variable>
	  <xsl:variable name="BibliographyHeading">zzBiblio</xsl:variable>
	  <xsl:variable name="BibliographyItem">Bibliography</xsl:variable>
	  <xsl:variable name="BibliographyReference">BibliographyReference</xsl:variable>
	  <xsl:variable name="DefinitionList">dl</xsl:variable>
	  <xsl:variable name="ExampleHeadingChar">Example Heading Char</xsl:variable>
	  <xsl:variable name="ExtXref">ExtXref</xsl:variable>
	  <xsl:variable name="FigureHeadingChar">Figure Heading Char</xsl:variable>
	  <xsl:variable name="Figuretitle">Figure title</xsl:variable>
	  <xsl:variable name="ForewordHeading">zzForeword</xsl:variable>
	  <xsl:variable name="FormulaReference">FormulaReference</xsl:variable>
	  <xsl:variable name="HeadingChar">Heading Char</xsl:variable>
	  <xsl:variable name="HeadingCharFr">Titre de note Car</xsl:variable>
	  <xsl:variable name="IntroductionHeading">Introduction</xsl:variable>
	  <xsl:variable name="NoteHeadingChar">Note Heading Char</xsl:variable>
	  <xsl:variable name="TableFootnote">Table footnote</xsl:variable>
	  <xsl:variable name="TableHeadingChar">Table Heading Char</xsl:variable>
	  <xsl:variable name="TableNote">Table note</xsl:variable>
	  <xsl:variable name="TableNoteHeadingChar">TableNoteHeading Char</xsl:variable>
	  <xsl:variable name="Tabletitle">Table title</xsl:variable>
	  <xsl:variable name="TermNum">TermNum</xsl:variable>
	  <xsl:variable name="Terms">termPreferred</xsl:variable>
	  <xsl:variable name="a2">a2</xsl:variable>
	  <xsl:variable name="a3">a3</xsl:variable>
	  <xsl:variable name="a4">a4</xsl:variable>
	  <xsl:variable name="a5">a5</xsl:variable>
	  <xsl:variable name="a6">a6</xsl:variable>
	  <xsl:variable name="pA2">pA2</xsl:variable>
	  <xsl:variable name="pA3">pA3</xsl:variable>
	  <xsl:variable name="pA4">pA4</xsl:variable>
	  <xsl:variable name="pA5">pA5</xsl:variable>
	  <xsl:variable name="pA6">pA6</xsl:variable>
	  <xsl:variable name="frScope">Domaine d'application</xsl:variable>
	  <xsl:variable name="zzIntroductionHeading">zzIntroduction</xsl:variable>

</xsl:stylesheet>