<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:nc4="http://release.niem.gov/niem/niem-core/4.0/" xmlns:ebts="http://cjis.fbi.gov/fbi_ebts/11.0" xmlns:itl="http://biometrics.nist.gov/standard/2011" xmlns:j6="http://release.niem.gov/niem/domains/jxdm/6.0/" xmlns:biom4="http://publication.niem.gov/niem/domains/biometrics/4.0/1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:j="http://niem.gov/niem/domains/jxdm/4.1" xmlns:biom="http://niem.gov/niem/biometrics/1.0" xmlns:ident="http://visit.dhs.gov/ident/6" xmlns:nc="http://niem.gov/niem/niem-core/2.0" xmlns:scr="http://niem.gov/niem/domains/screening/2.1" exclude-result-prefixes="nc4 ebts j6 biom4">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="compressionCodeMap">
		<entry key="0">None</entry>
		<entry key="1">WSQ20</entry>
		<entry key="2">JPEGB</entry>
		<entry key="3">JPEGL</entry>
		<entry key="4">JP2</entry>
		<entry key="5">JP2L</entry>
		<entry key="6">PNG</entry>
	</xsl:variable>
	<xsl:variable name="varPackageInformationRecord" as="node()?" select="/itl:NISTBiometricInformationExchangePackage/itl:PackageInformationRecord"/>
	<xsl:variable name="varPackageDescriptiveTextRecord" as="node()?" select="/itl:NISTBiometricInformationExchangePackage/itl:PackageDescriptiveTextRecord"/>
	<xsl:variable name="varTransaction" as="node()?" select="$varPackageInformationRecord/itl:Transaction"/>
	<xsl:variable name="varTransactionCategoryCode" as="xs:string" select="$varTransaction/ebts:TransactionCategoryCode"/>
	<xsl:variable name="varTransactionContentSummary" as="node()?" select="$varTransaction/itl:TransactionContentSummary"/>
	<xsl:variable name="varSubject" select="$varPackageDescriptiveTextRecord/itl:UserDefinedDescriptiveDetail/ebts:DomainDefinedDescriptiveFields/ebts:RecordSubject"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$varTransactionCategoryCode='TPIS'">
				<ident:IdentifyRequest>
					<ident:IdentifyOptions>
						<xsl:call-template name="Options"/>
					</ident:IdentifyOptions>
					<xsl:call-template name="Encounter"/>
				</ident:IdentifyRequest>
			</xsl:when>
			<xsl:when test="$varTransactionCategoryCode='FVR'">
				<ident:VerifyRequest>
					<ident:VerifyOptions>
						<xsl:call-template name="Options"/>
					</ident:VerifyOptions>
					<ident:EncounterIdentificationQuery>
						<nc:EncounterIdentification>
							<nc:IdentificationID>10000000047</nc:IdentificationID>
							<nc:IdentificationCategoryDescriptionText>EID</nc:IdentificationCategoryDescriptionText>
						</nc:EncounterIdentification>
					</ident:EncounterIdentificationQuery>
					<xsl:call-template name="Encounter"/>
				</ident:VerifyRequest>
			</xsl:when>
			<xsl:otherwise>
				<!-- alternative action -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()"/>
	<xsl:template match="ebts:FrictionRidgeInformation"/>
	<xsl:template name="Options">
		<ident:EncounterRetentionOptions>
			<ident:EncounterRetentionCode>Always</ident:EncounterRetentionCode>
			<ident:MatcherEnrollCode>Always</ident:MatcherEnrollCode>
		</ident:EncounterRetentionOptions>
		<ident:ResultSetOptions>
			<ident:EncounterFormatOptions>
				<ident:ResultDetailLevelCode>List</ident:ResultDetailLevelCode>
				<ident:ResultVersionCompatibilityCode>6090</ident:ResultVersionCompatibilityCode>
			</ident:EncounterFormatOptions>
			<ident:EncounterFilterOptions>
				<ident:EncounterOrderingCode>Derogatory All</ident:EncounterOrderingCode>
			</ident:EncounterFilterOptions>
		</ident:ResultSetOptions>
	</xsl:template>
	<xsl:template name="Encounter">
		<ident:Encounter>
			<ident:Activity>
				<nc:ActivityIdentification>
					<nc:IdentificationID>
						<xsl:value-of select="$varTransaction/itl:TransactionControlNumberID"/>
					</nc:IdentificationID>
					<nc:IdentificationCategoryDescriptionText>TCN</nc:IdentificationCategoryDescriptionText>
				</nc:ActivityIdentification>
				<nc:ActivityCategoryText>Identity Investigation</nc:ActivityCategoryText>
				<nc:ActivityReasonText>ENTRY AT PRIMARY INSPECTION</nc:ActivityReasonText>
				<nc:ActivityDate>
					<nc:Date>
						<xsl:value-of select="$varTransaction/itl:TransactionDate"/>
					</nc:Date>
				</nc:ActivityDate>
				<ident:OriginatingOrganization>
					<nc:OrganizationName>DOJ</nc:OrganizationName>
					<nc:OrganizationUnitName>CON-AFF</nc:OrganizationUnitName>
					<nc:OrganizationSubUnitName>IV</nc:OrganizationSubUnitName>
				</ident:OriginatingOrganization>
				<xsl:apply-templates select="$varTransaction/itl:TransactionOriginatingAgency"/>
				<xsl:apply-templates select="$varPackageDescriptiveTextRecord/itl:UserDefinedDescriptiveDetail/ebts:DomainDefinedDescriptiveFields/ebts:RecordTransactionActivity"/>
				<scr:ActivitySiteID>CPN</scr:ActivitySiteID>
				<scr:ActivityTerminalID>IVVTAF</scr:ActivityTerminalID>
			</ident:Activity>
			<ident:BiographicDetails>
				<ident:EncounterBiographic>
					<ident:PersonBiographic>
						<xsl:apply-templates select="$varSubject"/>
					</ident:PersonBiographic>
				</ident:EncounterBiographic>
			</ident:BiographicDetails>
			<ident:BiometricDetails>
				<xsl:for-each select="itl:NISTBiometricInformationExchangePackage/itl:PackageFingerImpressionImageRecord">
					<ident:FingerprintImageSet>
						<xsl:variable name="varImageReferenceID" as="xs:integer" select="./biom4:ImageReferenceID"/>
						<itl:PackageFingerprintImageRecord>
							<biom:RecordCategoryCode>
								<xsl:value-of select="$varTransactionContentSummary/itl:ContentRecordSummary[biom4:ImageReferenceID=$varImageReferenceID]/itl:RecordCategoryCode"/>
							</biom:RecordCategoryCode>
							<biom:ImageReferenceIdentification>
								<nc:IdentificationID>
									<xsl:value-of select="$varImageReferenceID"/>
								</nc:IdentificationID>
							</biom:ImageReferenceIdentification>
							<biom:FingerImpressionImage>
								<nc:BinaryBase64Object>
									<xsl:value-of select="nc4:Base64BinaryObject"/>
								</nc:BinaryBase64Object>
								<xsl:apply-templates select="biom4:FingerImpressionImageDetail/biom4:FingerprintImageQuality/preceding-sibling::*"/>
								<xsl:apply-templates select="biom4:FingerImpressionImageDetail/biom4:FingerprintImageSegmentationQuality"/>
								<xsl:apply-templates select="biom4:FingerImpressionImageDetail/biom4:FingerprintImageQuality"/>
								<xsl:apply-templates select="biom4:FingerImpressionImageDetail/biom4:FingerprintImageSegmentationQuality/following-sibling::*"/>
							</biom:FingerImpressionImage>
						</itl:PackageFingerprintImageRecord>
					</ident:FingerprintImageSet>
				</xsl:for-each>
			</ident:BiometricDetails>
		</ident:Encounter>
	</xsl:template>
	<xsl:template match="ebts:PersonResidenceLocation">
		<ident:PersonAddress>
			<nc:StructuredAddress>
				<nc:LocationStreet>
					<nc:StreetNumberText>
						<xsl:value-of select="nc4:Address/nc4:LocationStreet/nc4:StreetNumberText"/>
					</nc:StreetNumberText>
					<nc:StreetName>
						<xsl:value-of select="nc4:Address/nc4:LocationStreet/nc4:StreetName"/>
					</nc:StreetName>
				</nc:LocationStreet>
				<nc:LocationCityName>
					<xsl:value-of select="nc4:Address/nc4:LocationCityName"/>
				</nc:LocationCityName>
				<ident:LocationStateCode>
					<xsl:value-of select="nc4:Address/nc4:LocationState/ebts:LocationStateCode"/>
				</ident:LocationStateCode>
				<nc:LocationPostalCode>
					<xsl:value-of select="nc4:Address/nc4:LocationPostalCode"/>
				</nc:LocationPostalCode>
			</nc:StructuredAddress>
			<ident:LocationCategoryCode>Home</ident:LocationCategoryCode>
		</ident:PersonAddress>
	</xsl:template>
	<xsl:template match="nc4:PersonName">
		<nc:PersonName>
			<nc:PersonGivenName>
				<xsl:value-of select="nc4:PersonGivenName"/>
			</nc:PersonGivenName>
			<nc:PersonMiddleName>
				<xsl:value-of select="nc4:PersonMiddleName"/>
			</nc:PersonMiddleName>
			<nc:PersonSurName>
				<xsl:value-of select="nc4:PersonSurName"/>
			</nc:PersonSurName>
		</nc:PersonName>
	</xsl:template>
	<xsl:template match="nc4:PersonBirthDate">
		<nc:PersonBirthDate>
			<nc:Date>
				<xsl:value-of select="nc4:Date"/>
			</nc:Date>
		</nc:PersonBirthDate>
	</xsl:template>
	<xsl:template match="biom4:ImageCaptureDetail">
		<biom:ImageCaptureDetail>
			<xsl:apply-templates/>
		</biom:ImageCaptureDetail>
	</xsl:template>
	<xsl:template match="biom4:CaptureDate">
		<biom:CaptureDate>
			<xsl:apply-templates/>
		</biom:CaptureDate>
	</xsl:template>
	<xsl:template match="nc4:Date">
		<nc:Date>
			<xsl:value-of select="."/>
		</nc:Date>
	</xsl:template>
	<xsl:template match="nc4:DateTime">
		<nc:DateTime>
			<xsl:value-of select="."/>
		</nc:DateTime>
	</xsl:template>
	<xsl:template match="biom4:ImageCompressionAlgorithmCode">
		<xsl:variable name="varImageCompressionAlgorithmCode" select="xs:string(.)"/>
		<biom:ImageCompressionAlgorithmText>
			<xsl:value-of select="$compressionCodeMap/entry[@key=$varImageCompressionAlgorithmCode]"/>
		</biom:ImageCompressionAlgorithmText>
	</xsl:template>
	<xsl:template match="biom4:HorizontalLineLengthPixelQuantity">
		<biom:ImageHorizontalLineLengthPixelQuantity>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageHorizontalLineLengthPixelQuantity>
	</xsl:template>
	<xsl:template match="biom4:ImageHorizontalPixelDensityValue">
		<biom:ImageHorizontalPixelDensityValue>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageHorizontalPixelDensityValue>
	</xsl:template>
	<xsl:template match="biom4:ImageScaleUnitsCode">
		<biom:ImageScaleUnitsCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageScaleUnitsCode>
	</xsl:template>
	<xsl:template match="biom4:VerticalLineLengthPixelQuantity">
		<biom:ImageVerticalLineLengthPixelQuantity>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageVerticalLineLengthPixelQuantity>
	</xsl:template>
	<xsl:template match="biom4:ImageVerticalPixelDensityValue">
		<biom:ImageVerticalPixelDensityValue>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageVerticalPixelDensityValue>
	</xsl:template>
	<xsl:template match="biom4:FrictionRidgeImageImpressionCaptureCategoryCode">
		<biom:FingerprintImageImpressionCaptureCategoryCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:FingerprintImageImpressionCaptureCategoryCode>
	</xsl:template>
	<xsl:template match="biom4:ExemplarFingerPositionCode">
		<biom:FingerPositionCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:FingerPositionCode>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageMajorCasePrint">
		<biom:FingerprintImageMajorCasePrint>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom4:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:MajorCasePrintCode>
				<xsl:value-of select="biom4:MajorCasePrintCode"/>
			</biom:MajorCasePrintCode>
			<xsl:apply-templates/>
		</biom:FingerprintImageMajorCasePrint>
	</xsl:template>
	<xsl:template match="biom4:MajorCasePrintSegmentOffset">
		<biom:MajorCasePrintSegmentOffset>
			<biom:SegmentBottomVerticalCoordinateValue>
				<xsl:value-of select="biom4:FingerprintCoordinate/biom4:SegmentBottomVerticalCoordinateValue"/>
			</biom:SegmentBottomVerticalCoordinateValue>
			<biom:SegmentLocationCode>
				<xsl:value-of select="biom4:SegmentLocationCode"/>
			</biom:SegmentLocationCode>
			<biom:SegmentFingerViewCode>
				<xsl:value-of select="biom4:SegmentFingerViewCode"/>
			</biom:SegmentFingerViewCode>
			<biom:SegmentLeftHorizontalCoordinateValue>
				<xsl:value-of select="biom4:FingerprintCoordinate/biom4:SegmentLeftHorizontalCoordinateValue"/>
			</biom:SegmentLeftHorizontalCoordinateValue>
			<biom:SegmentRightHorizontalCoordinateValue>
				<xsl:value-of select="biom4:FingerprintCoordinate/biom4:SegmentRightHorizontalCoordinateValue"/>
			</biom:SegmentRightHorizontalCoordinateValue>
			<biom:SegmentTopVerticalCoordinateValue>
				<xsl:value-of select="biom4:FingerprintCoordinate/biom4:SegmentTopVerticalCoordinateValue"/>
			</biom:SegmentTopVerticalCoordinateValue>
		</biom:MajorCasePrintSegmentOffset>
	</xsl:template>
	<xsl:template match="biom4:CaptureDeviceMakeText">
		<biom:CaptureDeviceMakeText>>
			<xsl:value-of select="."/>
		</biom:CaptureDeviceMakeText>
	</xsl:template>
	<xsl:template match="biom4:CaptureDeviceModelText">
		<biom:CaptureDeviceModelText>>
			<xsl:value-of select="."/>
		</biom:CaptureDeviceModelText>
	</xsl:template>
	<xsl:template match="biom4:CaptureDeviceSerialNumberText">
		<biom:CaptureDeviceSerialNumberText>>
			<xsl:value-of select="."/>
		</biom:CaptureDeviceSerialNumberText>
	</xsl:template>
	<xsl:template match="biom4:CaptureOrganization">
		<biom:CaptureOrganization>
			<nc:OrganizationIdentification>
				<nc:IdentificationID>
					<xsl:value-of select="nc4:OrganizationIdentification/nc4:IdentificationID"/>
				</nc:IdentificationID>
			</nc:OrganizationIdentification>
			<nc:OrganizationName>
				<xsl:value-of select="nc4:OrganizationName"/>
			</nc:OrganizationName>
		</biom:CaptureOrganization>
	</xsl:template>
	<xsl:template match="itl:TransactionOriginatingAgency">
		<j:OrganizationORIIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="nc4:IdentificationID"/>
			</nc:IdentificationID>
			<nc:IdentificationCategoryDescriptionText>ORI</nc:IdentificationCategoryDescriptionText>
		</j:OrganizationORIIdentification>
	</xsl:template>
	<xsl:template match="ebts:RecordTransactionActivity">
		<ident:OrganizationCRIIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="ebts:RecordControllingAgencyID"/>
			</nc:IdentificationID>
			<nc:IdentificationCategoryDescriptionText>CRI</nc:IdentificationCategoryDescriptionText>
		</ident:OrganizationCRIIdentification>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageSegmentPositionSquare">
		<biom:FingerprintImageSegmentPositionSquare>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom4:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:SegmentBottomVerticalCoordinateValue>
				<xsl:value-of select="biom4:SegmentBottomVerticalCoordinateValue"/>
			</biom:SegmentBottomVerticalCoordinateValue>
			<biom:SegmentLeftHorizontalCoordinateValue>
				<xsl:value-of select="biom4:SegmentLeftHorizontalCoordinateValue"/>
			</biom:SegmentLeftHorizontalCoordinateValue>
			<biom:SegmentRightHorizontalCoordinateValue>
				<xsl:value-of select="biom4:SegmentRightHorizontalCoordinateValue"/>
			</biom:SegmentRightHorizontalCoordinateValue>
			<biom:SegmentTopVerticalCoordinateValue>
				<xsl:value-of select="biom4:SegmentTopVerticalCoordinateValue"/>
			</biom:SegmentTopVerticalCoordinateValue>
		</biom:FingerprintImageSegmentPositionSquare>
	</xsl:template>
	<xsl:template name="FingerprintImageQualityType">
		<biom:FingerPositionCode>
			<xsl:value-of select="biom4:FingerPositionCode"/>
		</biom:FingerPositionCode>
		<biom:QualityAlgorithmProductIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="biom4:QualityAlgorithmProductID"/>
			</nc:IdentificationID>
		</biom:QualityAlgorithmProductIdentification>
		<biom:QualityAlgorithmVendorIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="biom4:QualityAlgorithmVendorID"/>
			</nc:IdentificationID>
		</biom:QualityAlgorithmVendorIdentification>
		<biom:QualityValue>
			<xsl:value-of select="biom4:QualityValue"/>
		</biom:QualityValue>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageSegmentationQuality">
		<biom:FingerprintImageSegmentationQuality>
			<xsl:call-template name="FingerprintImageQualityType"/>
		</biom:FingerprintImageSegmentationQuality>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageQuality">
		<biom:FingerprintImageQuality>
			<xsl:call-template name="FingerprintImageQualityType"/>
		</biom:FingerprintImageQuality>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageFingerMissing">
		<biom:FingerprintImageFingerMissing>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom4:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:FingerMissingCode>
				<xsl:value-of select="biom4:FingerMissingCode"/>
			</biom:FingerMissingCode>
		</biom:FingerprintImageFingerMissing>
	</xsl:template>
	<xsl:template match="biom4:PositionPolygonVertex">
		<biom:PositionPolygonVertex>
			<biom:PositionHorizontalCoordinateValue>
				<xsl:value-of select="biom4:PositionHorizontalCoordinateValue"/>
			</biom:PositionHorizontalCoordinateValue>
			<biom:PositionVerticalCoordinateValue>
				<xsl:value-of select="biom4:PositionVerticalCoordinateValue"/>
			</biom:PositionVerticalCoordinateValue>
		</biom:PositionPolygonVertex>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageSegmentPositionPolygon">
		<biom:FingerprintImageSegmentPositionPolygon>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom4:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:PositionPolygonVertexQuantity>
				<xsl:value-of select="biom4:PositionPolygonVertexQuantity"/>
			</biom:PositionPolygonVertexQuantity>
			<xsl:apply-templates/>
		</biom:FingerprintImageSegmentPositionPolygon>
	</xsl:template>
	<xsl:template match="biom4:FingerprintImageAcquisitionProfileCode">
		<biom:FingerprintImageAcquisitionProfileCode>
			<xsl:value-of select="."/>
		</biom:FingerprintImageAcquisitionProfileCode>
	</xsl:template>
</xsl:stylesheet>
