package com.psiit.biomegoss.service;

import com.psiit.biomegoss.entity.TransformRequest;

/**
 * Interface for the XML service.
 */
public interface XmlService {
	public String convertXml(String inputXml, TransformRequest transformRequest) throws Exception;
    public String identApiCall(String inputXml) throws Exception;
}
