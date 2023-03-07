package com.psiit.biomegoss.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.psiit.biomegoss.BiomegOssApplication;
import com.psiit.biomegoss.entity.TransformRequest;
import com.psiit.biomegoss.service.XmlService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(classes = BiomegOssApplication.class)
@AutoConfigureMockMvc
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class XmlControllerTest {

    @MockBean
    private XmlService xmlService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testConvertXmlWithMap_success() throws Exception {

        MockMultipartFile file
                = new MockMultipartFile(
                "file",
                "sample/(TPIS)TenprintFingerprintImageSearchSample.xml",
                "multipart/form-data",
                "file".getBytes()
        );

        Map<String, String> pathValue = new HashMap<>();
        pathValue.put("/IdentifyRequest/IdentifyOptions/EncounterRetentionOptions/EncounterRetentionCode","Always");
        pathValue.put("/IdentifyRequest/IdentifyOptions/EncounterRetentionOptions/MatcherEnrollCode","Always");
        pathValue.put("/IdentifyRequest/Encounter/Activity/ActivityIdentification[1]/IdentificationCategoryDescriptionText","Always");
        pathValue.put("/IdentifyRequest/Encounter/Activity/ActivityCategoryText","Always");
        pathValue.put("/IdentifyRequest/Encounter/Activity/OriginatingOrganization/OrganizationName","Always");
        TransformRequest transformRequest = new TransformRequest();
        transformRequest.setInputType("DOJ");
        transformRequest.setOutputType("IXM");
        transformRequest.setXpath2values(pathValue);

        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(transformRequest);

        MockMultipartFile file2 =  new MockMultipartFile(
                "transformRequest",
                "",
                "application/json",
                json.getBytes()
        );

        Mockito.when(xmlService.convertXml(new String(file.getInputStream().readAllBytes(), StandardCharsets.UTF_8), transformRequest)).thenReturn("<nc:OrganizationName>DHS</nc:OrganizationName>");

        mockMvc.perform(
                        MockMvcRequestBuilders.multipart("/xml/convert")
                                .file(file2)
                                .file(file))
                				.andExpect(status().is2xxSuccessful());
    }

    @Test
    void testMockIdentApi() throws Exception {
        MockMultipartFile file
                = new MockMultipartFile(
                "file",
                "sample/converted-ixm-identifyrequest.xml",
                "multipart/form-data",
                "file".getBytes()
        );

        Map<String, String> pathValue = new HashMap<>();

        TransformRequest transformRequest = new TransformRequest();
        transformRequest.setInputType("IXM");
        transformRequest.setOutputType("IXM");
        transformRequest.setXpath2values(pathValue);

        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(transformRequest);

        MockMultipartFile file2 =  new MockMultipartFile(
                "transformRequest",
                "",
                "application/json",
                json.getBytes()
        );

        Mockito.when(xmlService.mockIdent(new String(file.getInputStream().readAllBytes(), StandardCharsets.UTF_8), transformRequest)).thenReturn("<nc:OrganizationName>DHS</nc:OrganizationName>");

        mockMvc.perform(
                        MockMvcRequestBuilders.multipart("/xml/mock/ident")
                                .file(file2)
                                .file(file))
                .andExpect(status().is2xxSuccessful());
    }
}
