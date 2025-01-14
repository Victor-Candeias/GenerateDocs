<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <html>
            <head>
                <title>Documentation - <xsl:value-of select="doc/assembly/name" /></title>
            </head>
			<body style="background-color: black">
				<div>
					<p style="font-size: 36px; color: #e74c3c; text-align: center; border: 1px solid white; border-radius: 5px; padding: 10px; margin: 10px; word-break: break-all; overflow-wrap: break-word;">
						Documentation - <xsl:value-of select="doc/assembly/name" />
					</p>
				</div>
				<xsl:apply-templates select="doc/members/member" />
			</body>
        </html>
    </xsl:template>

    <xsl:template match="member">
            <div class="member" style="border: 1px solid whitesmoke; border-radius: 5px; padding: 10px; margin: 10px;">
				<h2 style="color: yellow;">
					<xsl:call-template name="wrap-text-at-breaks">
						<xsl:with-param name="text" select="substring(@name, 3)" />
						<xsl:with-param name="type" select="substring(@name, 1, 1)" />
					</xsl:call-template>
				</h2>
			<xsl:apply-templates select="*" />
        </div>
    </xsl:template>
	
    <xsl:template match="summary">		
        <p style="color: yellow; font-size: 18px;">Summary: </p>
		<p style="color: white; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." /></p>
    </xsl:template>

    <xsl:template match="returns">
        <p style="color: yellow; font-size: 18px;">Returns: </p>
	    <p style="color: white; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." /></p>
    </xsl:template>

    <xsl:template match="param">
        <p style="color: yellow; font-size: 18px;">Parameter: </p>
		<p style="color: white; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." /></p>
    </xsl:template>

    <xsl:template match="code">
        <p style="color: #44bd32; font-size: 18px;">Code: </p>
		<p style="color: #e67e22; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." /></p>
    </xsl:template>

	<xsl:template match="exception">
		<p style="color: #e74c3c; font-size: 18px;">Exception: </p>
		<p style="color: white; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." />
		</p>
	</xsl:template>
	
    <xsl:template match="remarks">
        <p style="color: yellow; font-size: 18px;">Remarks: </p>
		<p style="color: white; font-size: 20px;">
			&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="." /></p>
    </xsl:template>
	
    <xsl:template name="wrap-text-at-breaks">
        <xsl:param name="text"/>
		<xsl:param name="type"/>

		<!-- Check the type -->
		<xsl:choose>
			<!-- enum values -->
			<xsl:when test="$type = 'F'">
				<span style="font-size: 30px; color: #009432;">
					<xsl:text>Field/Enum: </xsl:text>
				</span>
			</xsl:when>

			<!-- methods -->
			<xsl:when test="$type = 'M'">
				<span style="font-size: 30px; color: #9c88ff;">
					<xsl:text>Method: </xsl:text>
				</span>
			</xsl:when>

			<!-- properties -->
			<xsl:when test="$type = 'P'">
				<span style="font-size: 30px; color: #EE5A24;">
					<xsl:text>Property: </xsl:text>
				</span>
			</xsl:when>

			<xsl:otherwise>
				<!-- classes -->
				<span style="font-size: 30px; color: #227093;">
					<xsl:text>Class: </xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
            <xsl:when test="contains($text, '(')">
                 <!--Get the part before the break--> 
                <xsl:value-of select="substring-before($text, '(')" />
                 <!--Line break--> 
				<br />
				<xsl:text>&#160;&#160;&#160; (</xsl:text>
                 <!--Get the part after the break--> 
                <xsl:value-of select="substring-after($text, '(')" />
            </xsl:when>
            <xsl:otherwise>
                <!-- If no break character, just output the text -->
                <xsl:value-of select="$text"/>
				<xsl:if test="$type = 'M'">
					<xsl:text>()</xsl:text>
				</xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
