package com.psiit.biomegoss.entity;

/**
 * Enumeration mapping supported transformations to XSL stylesheets.
 */
public enum BiomegTransform {
	DOJ2IXM("DOJ", "IXM", "doj-ixm.xsl" ),
	IXM2DOJ("IXM", "DOJ", "ixm-doj.xsl" );

	public String getInType() {
		return inType;
	}

	public String getOutType() {
		return outType;
	}

	public String getXslFile() {
		return xslFile;
	}

	private String inType;
	private String outType;
	private String xslFile;
	
	BiomegTransform(String inType, String outType, String xslFile) {
		this.inType = inType;
		this.outType = outType;
		this.xslFile = xslFile;
	}
}
