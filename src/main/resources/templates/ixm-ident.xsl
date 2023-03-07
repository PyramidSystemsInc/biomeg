<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ident="http://visit.dhs.gov/ident/6" xmlns:nc="http://niem.gov/niem/niem-core/2.0" xmlns:j="http://niem.gov/niem/domains/jxdm/4.1" xmlns:scr="http://niem.gov/niem/domains/screening/2.1" xmlns:itl="http://biometrics.nist.gov/standard/2011" xmlns:biom="http://niem.gov/niem/biometrics/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="varActivity" as="node()?" select="/ident:IdentifyRequest/ident:Encounter/ident:Activity"/>
	<xsl:template match="/">
		<ident:IdentifyResponse>
			<nc:ActivityIdentification>
				<nc:IdentificationID>123456</nc:IdentificationID>
				<nc:IdentificationCategoryDescriptionText>SystemId</nc:IdentificationCategoryDescriptionText>
			</nc:ActivityIdentification>
			<ident:ActivityResultDate>
				<nc:DateTime>
					<xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]T[H01]:[m01]')"/>
				</nc:DateTime>
			</ident:ActivityResultDate>
			<ident:ResponseTypeCode>Final</ident:ResponseTypeCode>
			<nc:EncounterIdentification>
				<nc:IdentificationID>987654</nc:IdentificationID>
				<nc:IdentificationCategoryDescriptionText>EID</nc:IdentificationCategoryDescriptionText>
			</nc:EncounterIdentification>
			<ident:IdentifyStatusCode>Hit</ident:IdentifyStatusCode>
			<ident:Identity>
				<ident:IdentityIdentification>
					<nc:IdentificationID>11223344</nc:IdentificationID>
					<nc:IdentificationCategoryDescriptionText>FIN</nc:IdentificationCategoryDescriptionText>
				</ident:IdentityIdentification>
				<ident:IdentityWatchListCode>Recidivist</ident:IdentityWatchListCode>
				<ident:IdentityFlagSummary>
					<ident:IdentityFlagCategoryText>SPC</ident:IdentityFlagCategoryText>
				</ident:IdentityFlagSummary>
				<ident:Encounter>
					<nc:EncounterIdentification>
						<nc:IdentificationID>123456</nc:IdentificationID>
						<nc:IdentificationCategoryDescriptionText>EID</nc:IdentificationCategoryDescriptionText>
					</nc:EncounterIdentification>
					<ident:SystemLoadDateTime>
						<nc:DateTime>
							<xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f03]Z')"/>
						</nc:DateTime>
					</ident:SystemLoadDateTime>
					<ident:EncounterWatchListCode>Recidivist</ident:EncounterWatchListCode>
					<ident:Activity>
						<xsl:call-template name="Activity"/>
					</ident:Activity>
					<ident:BiographicDetails>
						<ident:EncounterBiographic>
							<scr:PersonIdentification>
								<nc:IdentificationID>M50P509TR</nc:IdentificationID>
								<nc:IdentificationCategoryDescriptionText>FBI</nc:IdentificationCategoryDescriptionText>
							</scr:PersonIdentification>
							<ident:PersonBiographic>
								<nc:PersonName>
									<nc:PersonGivenName>ANTHONY</nc:PersonGivenName>
									<nc:PersonMiddleName>PAUL</nc:PersonMiddleName>
									<nc:PersonSurName>JONES</nc:PersonSurName>
								</nc:PersonName>
								<ident:PersonAddress>
									<nc:StructuredAddress>
										<nc:LocationStreet>
											<nc:StreetFullText>5021 OAK LEAF DRIVE</nc:StreetFullText>
										</nc:LocationStreet>
										<nc:LocationCityName>BUFFALO</nc:LocationCityName>
										<ident:LocationStateCode>NY</ident:LocationStateCode>
										<nc:LocationCountryName>USA</nc:LocationCountryName>
										<nc:LocationPostalCode>14204</nc:LocationPostalCode>
									</nc:StructuredAddress>
									<ident:LocationCategoryCode>Home</ident:LocationCategoryCode>
								</ident:PersonAddress>
							</ident:PersonBiographic>
						</ident:EncounterBiographic>
					</ident:BiographicDetails>
					<ident:BiometricDetails>
						<ident:FingerprintImageSet>
							<itl:PackageFingerprintImageRecord>
								<biom:RecordCategoryCode>14</biom:RecordCategoryCode>
								<biom:ImageReferenceIdentification>
									<nc:IdentificationID>2</nc:IdentificationID>
								</biom:ImageReferenceIdentification>
								<biom:FingerImpressionImage>
									<nc:BinaryBase64Object>mrHbPdrko3u1s7ahtgPBjtmO1s85tfG2U7bpofY94Czu2SbY7d7wF9fQ7ZptgGrtkO2a2dsJ7wZbe 8BlzvAmQ7xq+Y94GoHeEsR3ikWd4DIGhzmp3k42d4DRmzs94DKveDTB3hqw6PeBLrtpPep0H/+h </nc:BinaryBase64Object>
									<biom:ImageCaptureDetail>
										<biom:CaptureDate>
											<nc:Date>2007-01-01</nc:Date>
										</biom:CaptureDate>
										<biom:CaptureOrganization>
											<nc:OrganizationIdentification>
												<nc:IdentificationID>WI013415Y</nc:IdentificationID>
											</nc:OrganizationIdentification>
											<nc:OrganizationName>WI CRIME INFORMATION BUREAU</nc:OrganizationName>
										</biom:CaptureOrganization>
									</biom:ImageCaptureDetail>
									<biom:ImageCompressionAlgorithmText>None</biom:ImageCompressionAlgorithmText>
									<biom:ImageHorizontalLineLengthPixelQuantity>65535</biom:ImageHorizontalLineLengthPixelQuantity>
									<biom:ImageHorizontalPixelDensityValue>1000</biom:ImageHorizontalPixelDensityValue>
									<biom:ImageScaleUnitsCode>1</biom:ImageScaleUnitsCode>
									<biom:ImageVerticalLineLengthPixelQuantity>65535</biom:ImageVerticalLineLengthPixelQuantity>
									<biom:ImageVerticalPixelDensityValue>1000</biom:ImageVerticalPixelDensityValue>
									<biom:FingerprintImageImpressionCaptureCategoryCode>2</biom:FingerprintImageImpressionCaptureCategoryCode>
									<biom:FingerPositionCode>19</biom:FingerPositionCode>
									<biom:FingerprintImageFingerMissing>
										<biom:FingerPositionCode>10</biom:FingerPositionCode>
										<biom:FingerMissingCode>XX</biom:FingerMissingCode>
									</biom:FingerprintImageFingerMissing>
									<biom:FingerprintImageSegmentPositionSquare>
										<biom:FingerPositionCode>8</biom:FingerPositionCode>
										<biom:SegmentBottomVerticalCoordinateValue>50</biom:SegmentBottomVerticalCoordinateValue>
										<biom:SegmentLeftHorizontalCoordinateValue>10</biom:SegmentLeftHorizontalCoordinateValue>
										<biom:SegmentRightHorizontalCoordinateValue>30</biom:SegmentRightHorizontalCoordinateValue>
										<biom:SegmentTopVerticalCoordinateValue>10</biom:SegmentTopVerticalCoordinateValue>
									</biom:FingerprintImageSegmentPositionSquare>
									<biom:FingerprintImageQuality>
										<biom:FingerPositionCode>8</biom:FingerPositionCode>
										<biom:QualityAlgorithmProductIdentification>
											<nc:IdentificationID>28495</nc:IdentificationID>
										</biom:QualityAlgorithmProductIdentification>
										<biom:QualityAlgorithmVendorIdentification>
											<nc:IdentificationID>FFFF</nc:IdentificationID>
										</biom:QualityAlgorithmVendorIdentification>
										<biom:QualityValue>100</biom:QualityValue>
									</biom:FingerprintImageQuality>
								</biom:FingerImpressionImage>
							</itl:PackageFingerprintImageRecord>
						</ident:FingerprintImageSet>
					</ident:BiometricDetails>
				</ident:Encounter>
			</ident:Identity>
		</ident:IdentifyResponse>
	</xsl:template>
	<xsl:template name="Activity">
		<nc:ActivityIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="$varActivity/nc:ActivityIdentification/nc:IdentificationID"/>
			</nc:IdentificationID>
			<nc:IdentificationCategoryDescriptionText>
				<xsl:value-of select="$varActivity/nc:ActivityIdentification/nc:IdentificationCategoryDescriptionText"/>
			</nc:IdentificationCategoryDescriptionText>
		</nc:ActivityIdentification>
		<nc:ActivityCategoryText>
			<xsl:value-of select="$varActivity/nc:ActivityCategoryText"/>
		</nc:ActivityCategoryText>
		<nc:ActivityDate>
			<nc:Date>
				<xsl:value-of select="$varActivity/nc:ActivityDate/nc:Date"/>
			</nc:Date>
		</nc:ActivityDate>
		<ident:OriginatingOrganization>
			<nc:OrganizationName>
				<xsl:value-of select="$varActivity/nc:OriginatingOrganization/nc:OrganizationName"/>
			</nc:OrganizationName>
		</ident:OriginatingOrganization>
		<j:OrganizationORIIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="$varActivity/j:OrganizationORIIdentification/nc:IdentificationID"/>
			</nc:IdentificationID>
			<nc:IdentificationCategoryDescriptionText>
				<xsl:value-of select="$varActivity/j:OrganizationORIIdentification/nc:IdentificationCategoryDescriptionText"/>
			</nc:IdentificationCategoryDescriptionText>
		</j:OrganizationORIIdentification>
		<ident:OrganizationCRIIdentification>
			<nc:IdentificationID>
				<xsl:value-of select="$varActivity/ident:OrganizationCRIIdentification/nc:IdentificationID"/>
			</nc:IdentificationID>
			<nc:IdentificationCategoryDescriptionText>
				<xsl:value-of select="$varActivity/ident:OrganizationCRIIdentification/nc:IdentificationCategoryDescriptionText"/>
			</nc:IdentificationCategoryDescriptionText>
		</ident:OrganizationCRIIdentification>
		<scr:ActivitySiteID>
			<xsl:value-of select="$varActivity/scr:ActivitySiteID"/>
		</scr:ActivitySiteID>
	</xsl:template>
</xsl:stylesheet>
