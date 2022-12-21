package com.psiit.biomegoss.spring;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Swagger configuration.
 */
@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI openApiInfo() {
    	Contact contact = new Contact();
    	contact.setName("Pyramid Systems, Inc.");
    	contact.setUrl("https://pyramidsystems.com");
        return new OpenAPI()
                .info(new Info().title("BioMEG OSS")
                .description("BioMEG Open Source Software")
                .version("0.0.1")
                .license(new License().name("Apache 2.0").url("http://springdoc.org")));
     }
}
