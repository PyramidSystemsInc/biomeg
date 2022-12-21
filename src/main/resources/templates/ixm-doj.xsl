<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:nc="http://release.niem.gov/niem/niem-core/4.0/" xmlns:ebts="http://cjis.fbi.gov/fbi_ebts/11.0" xmlns:itl="http://biometrics.nist.gov/standard/2011" xmlns:j="http://release.niem.gov/niem/domains/jxdm/6.0/" xmlns:biom="http://publication.niem.gov/niem/domains/biometrics/4.0/1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:scr="http://niem.gov/niem/domains/screening/2.1" xmlns:j4="http://niem.gov/niem/domains/jxdm/4.1" xmlns:biom1="http://niem.gov/niem/biometrics/1.0" xmlns:ident="http://visit.dhs.gov/ident/6" xmlns:nc2="http://niem.gov/niem/niem-core/2.0" exclude-result-prefixes="nc2 j4 biom1 ident">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="compressionCodeMap">
		<entry key="None">0</entry>
		<entry key="WSQ20">1</entry>
		<entry key="JPEGB">2</entry>
		<entry key="JPEGL">3</entry>
		<entry key="JP2">4</entry>
		<entry key="JP2L">5</entry>
		<entry key="PNG">6</entry>
	</xsl:variable>
	<xsl:template match="/ident:IdentifyResponse">
		<xsl:variable name="varActivity" as="node()?" select="ident:Identity/ident:Encounter/ident:Activity"/>
		<itl:NISTBiometricInformationExchangePackage>
			<itl:PackageInformationRecord>
				<itl:Transaction>
					<itl:TransactionDate>
						<xsl:value-of select="format-dateTime(ident:ActivityResultDate/nc2:DateTime, '[Y0001]-[M01]-[D01]')"/>
					</itl:TransactionDate>
					<itl:TransactionDestinationAgency>
						<nc:IdentificationID>
						</nc:IdentificationID>
					</itl:TransactionDestinationAgency>
					<itl:TransactionOriginatingAgency>
						<nc:IdentificationID>
							<xsl:value-of select="$varActivity/j4:OrganizationORIIdentification/nc2:IdentificationID"/>
						</nc:IdentificationID>
					</itl:TransactionOriginatingAgency>
					<itl:TransactionUTCDate>
						<xsl:value-of select="$varActivity/nc2:ActivityDate/nc2:DateTime"/>
					</itl:TransactionUTCDate>
					<itl:TransactionControlNumberID>
						<xsl:value-of select="$varActivity/nc2:ActivityIdentification/nc2:IdentificationID"/>
					</itl:TransactionControlNumberID>
					<!--TCR 1.010, Optional-->
					<itl:TransactionControlReferenceNumberID>
					</itl:TransactionControlReferenceNumberID>
					<itl:TransactionDomain>
						<!-- DVN -->
						<itl:DomainVersionNumberID>EBTS 11.0</itl:DomainVersionNumberID>
						<!-- DNM -->
						<itl:TransactionDomainName>NORAM</itl:TransactionDomainName>
					</itl:TransactionDomain>
					<!--APS 1.016, Optional -->
					<itl:TransactionApplicationProfile>
						<!--APO-->
						<biom:ApplicationProfileOrganizationName>DoD</biom:ApplicationProfileOrganizationName>
						<!--APN-->
						<biom:ApplicationProfileName>EBTS</biom:ApplicationProfileName>
						<!--APV-->
						<itl:ApplicationProfileVersionNumberID>3.0</itl:ApplicationProfileVersionNumberID>
					</itl:TransactionApplicationProfile>
					<itl:TransactionImageResolutionDetails>
						<!--NSR 1.011-->
						<biom:NativeScanningResolutionValue>00.00</biom:NativeScanningResolutionValue>
						<!--NTR 1.012-->
						<biom:NominalTransmittingResolutionValue>00.00</biom:NominalTransmittingResolutionValue>
					</itl:TransactionImageResolutionDetails>
					<itl:TransactionMajorVersionValue>05</itl:TransactionMajorVersionValue>
					<itl:TransactionMinorVersionValue>00</itl:TransactionMinorVersionValue>
					<ebts:TransactionCategoryCode>SRT</ebts:TransactionCategoryCode>
					<itl:TransactionContentSummary>
						<!-- CRC -->
						<itl:ContentRecordQuantity><xsl:value-of select="count(ident:Identity/ident:Encounter/ident:BiometricDetails/*)+1"/></itl:ContentRecordQuantity>
						<itl:ContentRecordSummary>
							<!-- IDC -->
							<biom:ImageReferenceID>00</biom:ImageReferenceID>
							<!-- REC -->
							<itl:RecordCategoryCode>02</itl:RecordCategoryCode>
						</itl:ContentRecordSummary>
						<xsl:for-each select="ident:Identity/ident:Encounter/ident:BiometricDetails/*">
							<itl:ContentRecordSummary>
								<biom:ImageReferenceID>
									<xsl:value-of select="*/biom1:ImageReferenceIdentification/nc2:IdentificationID"/>
								</biom:ImageReferenceID>
								<itl:RecordCategoryCode><xsl:value-of select="*/biom1:RecordCategoryCode"/></itl:RecordCategoryCode>
							</itl:ContentRecordSummary>
						</xsl:for-each>
					</itl:TransactionContentSummary>
				</itl:Transaction>
			</itl:PackageInformationRecord>
			<itl:PackageDescriptiveTextRecord>
				<!-- IDC 2.002-->
				<biom:ImageReferenceID>00</biom:ImageReferenceID>
				<itl:UserDefinedDescriptiveDetail>
					<ebts:DomainDefinedDescriptiveFields>
						<!-- SCO 2.007, Optional (0..9)-->
						<!--ATN 2.006, Optional-->
						<!-- NIR 2.2010 -->
						<ebts:RecordImagesRequestedQuantity>1</ebts:RecordImagesRequestedQuantity>
						<ebts:RecordTransactionData>
							<!--NCR 2.079-->
							<ebts:TransactionImagesRequestedQuantity>2</ebts:TransactionImagesRequestedQuantity>
							<ebts:TransactionResponseData>
								<ebts:TransactionCandidateList>
									<xsl:apply-templates select="ident:Identity/ident:Encounter/ident:BiographicDetails"/>
								</ebts:TransactionCandidateList>
								<!--MSG 2.060, Optional-->
								<ebts:TransactionStatusText>MATCH MADE AGAINST SUBJECTS FINGERPRINTS ON 05/01/94. PLEASE NOTIFY SUBMITTING STATE IF MATCH RESULTS</ebts:TransactionStatusText>
							</ebts:TransactionResponseData>
						</ebts:RecordTransactionData>
						<ebts:RecordTransactionActivity>
							<!-- OCA 2.009, Optional-->
							<nc:CaseTrackingID>Q880312465</nc:CaseTrackingID>
							<!--CRI 2.073 (0..3)-->
							<ebts:RecordControllingAgencyID>
								<xsl:value-of select="$varActivity/ident:OrganizationCRIIdentification/nc2:IdentificationID"/>
							</ebts:RecordControllingAgencyID>
						</ebts:RecordTransactionActivity>
						<ebts:RecordSubject>
							<!--RES 2.041, Optional-->
							<ebts:PersonResidenceLocation>
								<nc:Address>
									<nc:LocationStreet>
										<nc:StreetNumberText>5021</nc:StreetNumberText>
										<nc:StreetName>OAK LEAF DRIVE</nc:StreetName>
									</nc:LocationStreet>
									<nc:LocationCityName>BUFFALO</nc:LocationCityName>
									<nc:LocationState>
										<ebts:LocationStateCode>NY</ebts:LocationStateCode>
									</nc:LocationState>
									<nc:LocationPostalCode>14204</nc:LocationPostalCode>
								</nc:Address>
							</ebts:PersonResidenceLocation>
							<ebts:PersonEmployment>
								<!--OCP 2.040, Optional-->
								<nc:EmployeeOccupationText>PLUMBER</nc:EmployeeOccupationText>
								<!--EAD 2.039, Optional-->
								<nc:OrganizationName>ACE CONSTRUCTION COMPANY</nc:OrganizationName>
								<!--EAD 2.039, Optional-->
								<nc:Address>
									<nc:LocationStreet>
										<nc:StreetNumberText>327 </nc:StreetNumberText>
										<nc:StreetName>MAPLE AVE</nc:StreetName>
									</nc:LocationStreet>
									<nc:LocationCityName>BUFFALO</nc:LocationCityName>
									<nc:LocationState>
										<ebts:LocationStateCode>NY</ebts:LocationStateCode>
									</nc:LocationState>
									<nc:LocationPostalCode>14204</nc:LocationPostalCode>
								</nc:Address>
							</ebts:PersonEmployment>
							<ebts:FrictionRidgeInformation>
								<ebts:PersonFingerprintSet>
									<!--AMP 2.084 (0..13)-->
									<ebts:FingerprintImageFingerMissing>
										<!--FGP 2.084A-->
										<biom:ExemplarFingerPositionCode>3</biom:ExemplarFingerPositionCode>
										<!--AMPCD 2.084B-->
										<biom:FingerMissingCode>XX</biom:FingerMissingCode>
									</ebts:FingerprintImageFingerMissing>
								</ebts:PersonFingerprintSet>
							</ebts:FrictionRidgeInformation>
						</ebts:RecordSubject>
					</ebts:DomainDefinedDescriptiveFields>
				</itl:UserDefinedDescriptiveDetail>
			</itl:PackageDescriptiveTextRecord>
			<xsl:apply-templates select="ident:Identity/ident:Encounter/ident:BiometricDetails/*"/>
		</itl:NISTBiometricInformationExchangePackage>
	</xsl:template>
	<xsl:template match="text()"/>
	<xsl:template match="ident:EncounterBiographic">
		<ebts:Candidate>
			<xsl:apply-templates select="scr:PersonIdentification"/>
			<xsl:apply-templates select="ident:PersonBiographic/nc2:PersonName"/>
		</ebts:Candidate>
	</xsl:template>
	<xsl:template match="nc2:PersonName">
		<nc:PersonName>
			<nc:PersonGivenName>
				<xsl:value-of select="nc2:PersonGivenName"/>
			</nc:PersonGivenName>
			<nc:PersonMiddleName>
				<xsl:value-of select="nc2:PersonMiddleName"/>
			</nc:PersonMiddleName>
			<nc:PersonSurName>
				<xsl:value-of select="nc2:PersonSurName"/>
			</nc:PersonSurName>
		</nc:PersonName>
	</xsl:template>
	<xsl:template match="scr:PersonIdentification">
		<j:PersonFBIIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="nc2:IdentificationID"/>
			</nc:IdentificationID>
		</j:PersonFBIIdentification>
	</xsl:template>
	<xsl:template match="ident:FingerprintImageSet/itl:PackageFingerprintImageRecord">
		<itl:PackageFingerImpressionImageRecord>
			<biom:ImageReferenceID>
				<xsl:value-of select="biom1:ImageReferenceIdentification/nc2:IdentificationID"/>
			</biom:ImageReferenceID>
			<nc:Base64BinaryObject>
				<xsl:value-of select="biom1:FingerImpressionImage/nc2:BinaryBase64Object"/>
			</nc:Base64BinaryObject>
			<xsl:apply-templates/>
		</itl:PackageFingerImpressionImageRecord>
	</xsl:template>
	<xsl:template match="biom1:FingerImpressionImage">
		<biom:FingerImpressionImageDetail>
			<xsl:apply-templates/>
		</biom:FingerImpressionImageDetail>
	</xsl:template>
	<xsl:template match="biom1:ImageCaptureDetail">
		<biom:ImageCaptureDetail>
			<xsl:apply-templates/>
		</biom:ImageCaptureDetail>
	</xsl:template>
	<xsl:template match="biom1:CaptureDate">
		<biom:CaptureDate>
			<xsl:apply-templates/>
		</biom:CaptureDate>
	</xsl:template>
	<xsl:template match="nc2:Date">
		<nc:Date>
			<xsl:value-of select="."/>
		</nc:Date>
	</xsl:template>
	<xsl:template match="nc2:DateTime">
		<nc:DateTime>
			<xsl:value-of select="."/>
		</nc:DateTime>
	</xsl:template>
	<xsl:template match="biom1:CaptureOrganization">
		<biom:CaptureOrganization>
			<nc:OrganizationIdentification>
				<nc:IdentificationID>
					<xsl:value-of select="nc2:OrganizationIdentification/nc2:IdentificationID"/>
				</nc:IdentificationID>
			</nc:OrganizationIdentification>
			<nc:OrganizationName>
				<xsl:value-of select="nc2:OrganizationName"/>
			</nc:OrganizationName>
		</biom:CaptureOrganization>
	</xsl:template>
	<xsl:template match="biom1:ImageCompressionAlgorithmText">
		<xsl:variable name="varImageCompressionAlgorithmText" select="xs:string(.)"/>
		<biom:ImageCompressionAlgorithmCode>
			<xsl:value-of select="$compressionCodeMap/entry[@key=$varImageCompressionAlgorithmText]"/>
		</biom:ImageCompressionAlgorithmCode>
	</xsl:template>
	<xsl:template match="biom1:ImageHorizontalLineLengthPixelQuantity">
		<biom:HorizontalLineLengthPixelQuantity>
			<xsl:value-of select="xs:string(.)"/>
		</biom:HorizontalLineLengthPixelQuantity>
	</xsl:template>
	<xsl:template match="biom1:ImageHorizontalPixelDensityValue">
		<biom:ImageHorizontalPixelDensityValue>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageHorizontalPixelDensityValue>
	</xsl:template>
	<xsl:template match="biom1:ImageScaleUnitsCode">
		<biom:ImageScaleUnitsCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageScaleUnitsCode>
	</xsl:template>
	<xsl:template match="biom1:ImageVerticalLineLengthPixelQuantity">
		<biom:VerticalLineLengthPixelQuantity>
			<xsl:value-of select="xs:string(.)"/>
		</biom:VerticalLineLengthPixelQuantity>
	</xsl:template>
	<xsl:template match="biom1:ImageVerticalPixelDensityValue">
		<biom:ImageVerticalPixelDensityValue>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ImageVerticalPixelDensityValue>
	</xsl:template>
	<xsl:template match="biom1:FingerprintImageImpressionCaptureCategoryCode">
		<biom:FrictionRidgeImageImpressionCaptureCategoryCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:FrictionRidgeImageImpressionCaptureCategoryCode>
	</xsl:template>
	<xsl:template match="biom1:FingerPositionCode[parent::biom1:FingerImpressionImage]">
		<biom:ExemplarFingerPositionCode>
			<xsl:value-of select="xs:string(.)"/>
		</biom:ExemplarFingerPositionCode>
	</xsl:template>
	<xsl:template match="biom1:FingerprintImageMajorCasePrint">
		<biom:FingerprintImageMajorCasePrint>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom1:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:MajorCasePrintCode>
				<xsl:value-of select="biom1:MajorCasePrintCode"/>
			</biom:MajorCasePrintCode>
			<xsl:apply-templates/>
		</biom:FingerprintImageMajorCasePrint>
	</xsl:template>
	<xsl:template match="biom1:MajorCasePrintSegmentOffset">
		<biom:MajorCasePrintSegmentOffset>
			<biom:FingerprintCoordinate>
				<biom:SegmentBottomVerticalCoordinateValue>
					<xsl:value-of select="biom1:SegmentBottomVerticalCoordinateValue"/>
				</biom:SegmentBottomVerticalCoordinateValue>
				<biom:SegmentLeftHorizontalCoordinateValue>
					<xsl:value-of select="biom1:SegmentLeftHorizontalCoordinateValue"/>
				</biom:SegmentLeftHorizontalCoordinateValue>
				<biom:SegmentRightHorizontalCoordinateValue>
					<xsl:value-of select="biom1:SegmentRightHorizontalCoordinateValue"/>
				</biom:SegmentRightHorizontalCoordinateValue>
				<biom:SegmentTopVerticalCoordinateValue>
					<xsl:value-of select="biom1:SegmentTopVerticalCoordinateValue"/>
				</biom:SegmentTopVerticalCoordinateValue>
			</biom:FingerprintCoordinate>
			<biom:SegmentLocationCode>
				<xsl:value-of select="biom1:SegmentLocationCode"/>
			</biom:SegmentLocationCode>
			<biom:SegmentFingerViewCode>
				<xsl:value-of select="biom1:SegmentFingerViewCode"/>
			</biom:SegmentFingerViewCode>
		</biom:MajorCasePrintSegmentOffset>
	</xsl:template>
	<xsl:template match="biom1:FingerprintImageFingerMissing">
		<biom:FingerprintImageFingerMissing>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom1:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:FingerMissingCode>
				<xsl:value-of select="biom1:FingerMissingCode"/>
			</biom:FingerMissingCode>
		</biom:FingerprintImageFingerMissing>
	</xsl:template>
	<xsl:template match="biom1:FingerprintImageSegmentPositionSquare">
		<biom:FingerprintImageSegmentPositionSquare>
			<biom:FingerPositionCode>
				<xsl:value-of select="biom1:FingerPositionCode"/>
			</biom:FingerPositionCode>
			<biom:SegmentBottomVerticalCoordinateValue>
				<xsl:value-of select="biom1:SegmentBottomVerticalCoordinateValue"/>
			</biom:SegmentBottomVerticalCoordinateValue>
			<biom:SegmentLeftHorizontalCoordinateValue>
				<xsl:value-of select="biom1:SegmentLeftHorizontalCoordinateValue"/>
			</biom:SegmentLeftHorizontalCoordinateValue>
			<biom:SegmentRightHorizontalCoordinateValue>
				<xsl:value-of select="biom1:SegmentRightHorizontalCoordinateValue"/>
			</biom:SegmentRightHorizontalCoordinateValue>
			<biom:SegmentTopVerticalCoordinateValue>
				<xsl:value-of select="biom1:SegmentTopVerticalCoordinateValue"/>
			</biom:SegmentTopVerticalCoordinateValue>
		</biom:FingerprintImageSegmentPositionSquare>
	</xsl:template>
	<xsl:template name="FingerprintImageQualityType">
		<biom:FingerPositionCode>
			<xsl:value-of select="biom1:FingerPositionCode"/>
		</biom:FingerPositionCode>
		<biom:QualityAlgorithmProductID>
			<xsl:value-of select="biom1:QualityAlgorithmProductIdentification/nc2:IdentificationID"/>
		</biom:QualityAlgorithmProductID>
		<biom:QualityAlgorithmVendorID>
			<xsl:value-of select="biom1:QualityAlgorithmVendorIdentification/nc2:IdentificationID"/>
		</biom:QualityAlgorithmVendorID>
		<biom:QualityValue>
			<xsl:value-of select="biom1:QualityValue"/>
		</biom:QualityValue>
	</xsl:template>
	<xsl:template match="biom1:FingerprintImageQuality">
		<biom:FingerprintImageQuality>
			<xsl:call-template name="FingerprintImageQualityType"/>
		</biom:FingerprintImageQuality>
	</xsl:template>
</xsl:stylesheet>
