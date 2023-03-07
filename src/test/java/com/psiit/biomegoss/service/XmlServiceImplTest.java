package com.psiit.biomegoss.service;

import com.psiit.biomegoss.entity.TransformRequest;
import io.micrometer.core.instrument.util.IOUtils;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.mock.web.MockMultipartFile;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(MockitoExtension.class)
public class XmlServiceImplTest {

    @InjectMocks
    private XmlServiceImpl xmlService;

    @Test
    void convertXmlTest_error() throws Exception {

        Resource xmlResource = new ClassPathResource("sample/(TPIS)TenprintFingerprintImageSearchSample.xml");
        String xml = IOUtils.toString(xmlResource.getInputStream(), StandardCharsets.UTF_8);

        Map<String, String> pathValue = new HashMap<>();
        TransformRequest transformRequest = new TransformRequest();
        transformRequest.setInputType("");
        transformRequest.setOutputType("");
        transformRequest.setXpath2values(pathValue);
        Exception exception = assertThrows(UnsupportedOperationException.class, () -> {
            xmlService.convertXml(xml, transformRequest);
        });

        String expectedMessage = "Unsupported conversion from  to";
        String actualMessage = exception.getMessage();

        assertTrue(actualMessage.contains(expectedMessage));
    }

    @Test
    void convertXmlTest_success() throws Exception {

        Resource xmlResource = new ClassPathResource("sample/(TPIS)TenprintFingerprintImageSearchSample.xml");
        String xml = IOUtils.toString(xmlResource.getInputStream(), StandardCharsets.UTF_8);

        Map<String, String> pathValue = new HashMap<>();
        pathValue.put("/IdentifyRequest/IdentifyOptions/EncounterRetentionOptions/EncounterRetentionCode","Always");
        TransformRequest transformRequest = new TransformRequest();
        transformRequest.setInputType("DOJ");
        transformRequest.setOutputType("IXM");
        transformRequest.setXpath2values(pathValue);
        String result = xmlService.convertXml(xml, transformRequest);

        assertTrue(result.contains("ident:IdentifyRequest"));
    }

    @Test
    void testMockIdent() throws Exception {
        Resource xmlResource = new ClassPathResource("sample/converted-ixm-identifyrequest.xml");
        String xml = IOUtils.toString(xmlResource.getInputStream(), StandardCharsets.UTF_8);

        Map<String, String> pathValue = new HashMap<>();
        TransformRequest transformRequest = new TransformRequest();
        transformRequest.setInputType("IXM");
        transformRequest.setOutputType("IXM");
        transformRequest.setXpath2values(pathValue);
        String result = xmlService.mockIdent(xml, transformRequest);

        assertTrue(result.contains("ident:IdentifyResponse"));
    }
}
