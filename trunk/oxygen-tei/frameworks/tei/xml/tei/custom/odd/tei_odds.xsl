<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output method="text"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <xsl:apply-templates select="/" mode="M5"/>
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
      <xsl:apply-templates select="/" mode="M16"/>
      <xsl:apply-templates select="/" mode="M17"/>
      <xsl:apply-templates select="/" mode="M18"/>
      <xsl:apply-templates select="/" mode="M19"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M22"/>
      <xsl:apply-templates select="/" mode="M23"/>
      <xsl:apply-templates select="/" mode="M24"/>
      <xsl:apply-templates select="/" mode="M25"/>
      <xsl:apply-templates select="/" mode="M26"/>
      <xsl:apply-templates select="/" mode="M27"/>
      <xsl:apply-templates select="/" mode="M28"/>
      <xsl:apply-templates select="/" mode="M29"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


<!--PATTERN att.datable-constraint-calendar-->


	<!--RULE -->
<xsl:template match="tei:*[@calendar]" priority="1000" mode="M5">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="string-length(.) gt 0"/>
         <xsl:otherwise>
            <xsl:message>
@calendar indicates the system or calendar to which the date represented by the content of this element
belongs, but this <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> element has no textual content. (string-length(.) gt 0)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>

   <!--PATTERN att.typed-constraint-subtypeTyped-->


	<!--RULE -->
<xsl:template match="*[@subtype]" priority="1000" mode="M6">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="@type"/>
         <xsl:otherwise>
            <xsl:message>The <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/> element should not be categorized in detail with @subtype
 unless also categorized in general with @type (@type)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN att.pointing-constraint-targetLang-->


	<!--RULE -->
<xsl:template match="tei:*[not(self::tei:schemaSpec)][@targetLang]"
                 priority="1000"
                 mode="M7">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(@target)"/>
         <xsl:otherwise>
            <xsl:message>@targetLang can only be used if @target is specified. (count(@target))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN att.spanning-constraint-spanTo-2-->


	<!--RULE -->
<xsl:template match="tei:*[@spanTo]" priority="1000" mode="M8">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="id(substring(@spanTo,2)) and following::*[@xml:id=substring(current()/@spanTo,2)]"/>
         <xsl:otherwise>
            <xsl:message>
The element indicated by @spanTo (<xsl:text/>
               <xsl:value-of select="@spanTo"/>
               <xsl:text/>) must follow the current element <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>
          (id(substring(@spanTo,2)) and following::*[@xml:id=substring(current()/@spanTo,2)])</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN att.styleDef-constraint-schemeVersionRequiresScheme-->


	<!--RULE -->
<xsl:template match="tei:*[@schemeVersion]" priority="1000" mode="M9">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="@scheme and not(@scheme = 'free')"/>
         <xsl:otherwise>
            <xsl:message>
              @schemeVersion can only be used if @scheme is specified.
             (@scheme and not(@scheme = 'free'))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN ptr-constraint-ptrAtts-->


	<!--RULE -->
<xsl:template match="tei:ptr" priority="1000" mode="M10">

		<!--REPORT -->
<xsl:if test="@target and @cRef">
         <xsl:message>Only one of the
attributes @target and @cRef may be supplied on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>. (@target and @cRef)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN ref-constraint-refAtts-->


	<!--RULE -->
<xsl:template match="tei:ref" priority="1000" mode="M11">

		<!--REPORT -->
<xsl:if test="@target and @cRef">
         <xsl:message>Only one of the
	attributes @target' and @cRef' may be supplied on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (@target and @cRef)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN relatedItem-constraint-targetorcontent1-->


	<!--RULE -->
<xsl:template match="tei:relatedItem" priority="1000" mode="M12">

		<!--REPORT -->
<xsl:if test="@target and count( child::* ) &gt; 0">
         <xsl:message>
If the @target attribute on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> is used, the
relatedItem element must be empty (@target and count( child::* ) &gt; 0)</xsl:message>
      </xsl:if>

		    <!--ASSERT -->
<xsl:choose>
         <xsl:when test="@target or child::*"/>
         <xsl:otherwise>
            <xsl:message>A relatedItem element should have either a 'target' attribute
        or a child element to indicate the related bibliographic item (@target or child::*)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN lg-constraint-atleast1oflggapl-->


	<!--RULE -->
<xsl:template match="tei:lg" priority="1000" mode="M13">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0"/>
         <xsl:otherwise>
            <xsl:message>An lg element
        must contain at least one child l, lg or gap element. (count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0)</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN quotation-constraint-quotationContents-->


	<!--RULE -->
<xsl:template match="tei:quotation" priority="1000" mode="M14">

		<!--REPORT -->
<xsl:if test="not(@marks) and not (tei:p)">
         <xsl:message>
On <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>, either the @marks attribute should be used, or a paragraph of description provided (not(@marks) and not (tei:p))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN moduleRef-constraint-modref-->


	<!--RULE -->
<xsl:template match="tei:moduleRef" priority="1000" mode="M15">

		<!--REPORT -->
<xsl:if test="* and @key">
         <xsl:message>
Child elements of <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> are only allowed when an external module is being loaded
         (* and @key)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN moduleRef-constraint-not-same-prefix-->


	<!--RULE -->
<xsl:template match="tei:moduleRef" priority="1000" mode="M16">

		<!--REPORT -->
<xsl:if test="//*[ not( generate-id(.) eq generate-id(      current() ) ) ]/@prefix = @prefix">
         <xsl:message>The prefix attribute
	    of <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> should not match that of any other
	    element (it would defeat the purpose) (//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN constraintSpec-constraint-sch-->


	<!--RULE -->
<xsl:template match="tei:constraintSpec" priority="1000" mode="M17">

		<!--REPORT -->
<xsl:if test="tei:constraint/s:* and    not(@scheme='schematron')">
         <xsl:message>
	Rules in the Schematron 1.* language must be inside
	a constraint with a value of 'schematron' on the scheme attribute
       (tei:constraint/s:* and not(@scheme='schematron'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN constraintSpec-constraint-isosch-->


	<!--RULE -->
<xsl:template match="tei:constraintSpec" priority="1000" mode="M18">

		<!--REPORT -->
<xsl:if test="tei:constraint/sch:* and    not(@scheme='isoschematron')">
         <xsl:message>
	Rules in the ISO Schematron language must be inside
	a constraint with a value of 'isoschematron' on the scheme attribute
       (tei:constraint/sch:* and not(@scheme='isoschematron'))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN attDef-constraint-attDefContents-->


	<!--RULE -->
<xsl:template match="tei:attDef" priority="1000" mode="M19">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="   @mode eq 'change'       or @mode eq 'delete'       or tei:datatype       or tei:valList[@type='closed']       "/>
         <xsl:otherwise>
            <xsl:message>Attribute: the definition of the @<xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/> attribute in the <xsl:text/>
               <xsl:value-of select="ancestor::*[@ident][1]/@ident"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:value-of select="' '"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:value-of select="local-name(ancestor::*[@ident][1])"/>
               <xsl:text/> should have a closed valList or a datatype (@mode eq 'change' or @mode eq 'delete' or tei:datatype or tei:valList[@type='closed'])</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN att.identified-constraint-spec-in-module-->


	<!--RULE -->
<xsl:template match="tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]"
                 priority="1000"
                 mode="M20">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="         (not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or         (not(@module) or          (not(//tei:moduleSpec) and not(//tei:moduleRef))  or         (//tei:moduleSpec[@ident = current()/@module]) or          (//tei:moduleRef[@key = current()/@module]))         "/>
         <xsl:otherwise>
            <xsl:message>
        Specification <xsl:text/>
               <xsl:value-of select="@ident"/>
               <xsl:text/>: the value of the module attribute ("<xsl:text/>
               <xsl:value-of select="@module"/>
               <xsl:text/>") 
should correspond to an existing module, via a moduleSpec or
      moduleRef ((not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module])))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN att.deprecated-constraint-deprecated-->


	<!--RULE -->
<xsl:template match="tei:*[@validUntil]" priority="1001" mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="@validUntil cast as xs:date ge current-date()"/>
         <xsl:otherwise>
            <xsl:message>
               <xsl:text/>
               <xsl:value-of select="if (@ident) then concat('The ',@ident) else concat('This ',local-name(.),' of ',ancestor::tei:*[@ident][1]/@ident)"/>
               <xsl:text/> construct is outdated (as of <xsl:text/>
               <xsl:value-of select="@validUntil"/>
               <xsl:text/>); ODD processors may ignore it, and it should probably be removed (@validUntil cast as xs:date ge current-date())</xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="@validUntil cast as xs:date eq current-date()">
         <xsl:message>
            <xsl:text/>
            <xsl:value-of select="if (@ident) then concat('The ',@ident) else concat('This ',local-name(.),' of ',ancestor::tei:*[@ident][1]/@ident)"/>
            <xsl:text/> construct will be outdated as of tomorrow; ODD processors may then ignore it, and thus it should probably be removed soon (@validUntil cast as xs:date eq current-date())</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
<xsl:template match="tei:*[@validUntil]" priority="1000" mode="M21">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="(@validUntil cast as xs:date - current-date()) lt (30*xs:dayTimeDuration('P1D'))"/>
         <xsl:otherwise>
            <xsl:message>
               <xsl:text/>
               <xsl:value-of select="if (@ident) then concat('The ',@ident) else concat('This ',local-name(.),' of ',ancestor::tei:*[@ident][1]/@ident)"/>
               <xsl:text/> construct is outdated (as of <xsl:text/>
               <xsl:value-of select="@validUntil"/>
               <xsl:text/>); ODD processors may ignore it, and it should probably be removed ((@validUntil cast as xs:date - current-date()) lt (30*xs:dayTimeDuration('P1D')))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
<xsl:if test="@validUntil cast as xs:date eq current-date()">
         <xsl:message>
            <xsl:text/>
            <xsl:value-of select="if (@ident) then concat('The ',@ident) else concat('This ',local-name(.),' of ',ancestor::tei:*[@ident][1]/@ident)"/>
            <xsl:text/> construct will be outdated as of tomorrow; ODD processors may then ignore it, and thus it should probably be removed soon (@validUntil cast as xs:date eq current-date())</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN link-constraint-linkTargets1-->


	<!--RULE -->
<xsl:template match="tei:link" priority="1000" mode="M22">

		<!--REPORT -->
<xsl:if test="@target and @targets">
         <xsl:message>You may not supply both @target and @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (@target and @targets)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN link-constraint-linkTargets2-->


	<!--RULE -->
<xsl:template match="tei:link" priority="1000" mode="M23">

		<!--REPORT -->
<xsl:if test="not(@target) and not(@targets)">
         <xsl:message>You must supply either @target or @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (not(@target) and not(@targets))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN link-constraint-linkTargets3-->


	<!--RULE -->
<xsl:template match="tei:link" priority="1000" mode="M24">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains(@targets,' ') or contains(@target,' ')"/>
         <xsl:otherwise>
            <xsl:message>You must supply at least two values for  @target or @targets on <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>
          (contains(@targets,' ') or contains(@target,' '))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN join-constraint-joinTargets1-->


	<!--RULE -->
<xsl:template match="tei:join" priority="1000" mode="M25">

		<!--REPORT -->
<xsl:if test="@target and @targets">
         <xsl:message>
You may not supply both @target and @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (@target and @targets)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN join-constraint-joinTargets2-->


	<!--RULE -->
<xsl:template match="tei:join" priority="1000" mode="M26">

		<!--REPORT -->
<xsl:if test="not(@target) and not(@targets)">
         <xsl:message>
You must supply either @target or @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (not(@target) and not(@targets))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN join-constraint-joinTargets3-->


	<!--RULE -->
<xsl:template match="tei:join" priority="1000" mode="M27">

		<!--ASSERT -->
<xsl:choose>
         <xsl:when test="contains(@target,' ')"/>
         <xsl:otherwise>
            <xsl:message>
You must supply at least two values for @target on <xsl:text/>
               <xsl:value-of select="name(.)"/>
               <xsl:text/>
          (contains(@target,' '))</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN alt-constraint-altTargets1-->


	<!--RULE -->
<xsl:template match="tei:alt" priority="1000" mode="M28">

		<!--REPORT -->
<xsl:if test="@target and @targets">
         <xsl:message>You may not supply both 
	@target and @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (@target and @targets)</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN alt-constraint-altTargets2-->


	<!--RULE -->
<xsl:template match="tei:alt" priority="1000" mode="M29">

		<!--REPORT -->
<xsl:if test="not(@target) and not(@targets)">
         <xsl:message>You must
	supply either @target or @targets on <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
          (not(@target) and not(@targets))</xsl:message>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
</xsl:stylesheet>
