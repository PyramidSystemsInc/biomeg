package com.psiit.biomegoss.controller;

import com.psiit.biomegoss.entity.TransformRequest;
import com.psiit.biomegoss.service.XmlService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Encoding;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.nio.charset.StandardCharsets;

/**
 * Main XML controller.
 */
@Tag(name="xml", description="BioMEG XML Conversion API")
@RestController
@RequestMapping("xml")
public class XmlController {

    @Autowired
    private XmlService xmlService;

    /**
     * Converts a posted XML file into the requested format.
     *
     * @param transformRequest
     * @param file
     * @return XML contents
     * @throws Exception
     */
    @Operation(summary="Convert XML",
            description="Accepts a file and a transformation request that specifies input and output format, as well " +
                    "as a map containing an XPath and a substitution value.",
            tags={"xml"})
    @PostMapping(value="/convertXml", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @RequestBody(content = @Content(encoding = @Encoding(name = "transformRequest", contentType = "application/json")))
    public String convertXmlWithMap(@RequestPart("transformRequest") TransformRequest transformRequest, @RequestPart("file") MultipartFile file) throws Exception {
        return xmlService.convertXml(new String(file.getInputStream().readAllBytes(), StandardCharsets.UTF_8), transformRequest);
    }

    /**
     * Returns a mock IDENT response.
     *
     * @param transformRequest
     * @return XML content
     * @throws Exception
     */
    @Operation(summary="Mock DHS IDENT endpoint",
            description="Accepts a DHS IXM formatted request file and returns a mock response.",
            tags={"xml"})
    @PostMapping(value="/identApiCall")
    @RequestBody(content = @Content(encoding = @Encoding(contentType = "application/json")))
    public String identApiCall(@RequestPart("transformRequest") TransformRequest transformRequest) throws Exception {
        return xmlService.identApiCall(String.valueOf(transformRequest));
    }
}