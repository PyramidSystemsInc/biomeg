package com.psiit.biomegoss.service;

import com.psiit.biomegoss.entity.BiomegTransform;
import com.psiit.biomegoss.entity.TransformRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.Map;
import java.util.Map.Entry;

/**
 * Implementation for the XML service.
 */
@Service
public class XmlServiceImpl implements XmlService {
    private Logger log = LoggerFactory.getLogger(XmlServiceImpl.class);
    private static String XSL_PATH_PREFIX = "templates/";


    /**
     * Main method, converts an XML string into the requested format and returns
     * that XML as a string.
     *
     * @param inputXml
     * @param transformRequest
     * @return converted XML
     * @throws Exception
     */
	@Override
	public String convertXml(String inputXml, TransformRequest transformRequest) throws Exception {

        // Determine XSL file.
		String xslPath = null;
		for (BiomegTransform tf : BiomegTransform.values()) {
			if (tf.getInType().equals(transformRequest.getInputType()) && tf.getOutType().equals(transformRequest.getOutputType())) {
				xslPath = tf.getXslFile();
				break;
			}
		}

        // Exception if no XSL is found.
		if (xslPath == null)
			throw new UnsupportedOperationException(String.format("Unsupported conversion from %s to %s", transformRequest.getInputType(), transformRequest.getOutputType()));

        return xmlTransform(inputXml,  xslPath, transformRequest.getXpath2values());
	}

    /**
     * Returns mock IDENT response.
     *
     * @param inputXml
     * @return converted XML
     * @throws Exception
     */
    @Override
    public String mockIdent(String inputXml, TransformRequest transformRequest) throws Exception {
        return xmlTransform(inputXml,  "ixm-ident.xsl", transformRequest.getXpath2values());
    }

    /**
     * Performs the XML transformation and mapped substitutions.
     *
     * @param sourceXml
     * @param xslFile
     * @param xpath2values
     * @return converted XML
     * @throws TransformerException
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws XPathExpressionException
     */
    private String xmlTransform(String sourceXml, String xslFile, Map<String, String> xpath2values)
            throws TransformerException, IOException, ParserConfigurationException, XPathExpressionException {

        // Create a transform factory instance.
        TransformerFactory tfactory = TransformerFactory.newInstance();
        Resource xslResource = new ClassPathResource(XSL_PATH_PREFIX + xslFile);
        StreamSource xslSource = new StreamSource(xslResource.getInputStream());

        // Create a transformer for the stylesheet.
        Transformer transformer = tfactory.newTransformer(xslSource);
        InputStream xmlIS = new ByteArrayInputStream(sourceXml.getBytes());
        StreamSource xmlSource = new StreamSource(xmlIS);

        // Created the document factory.
        DocumentBuilderFactory dfactory = DocumentBuilderFactory.newInstance();
        dfactory.setNamespaceAware(true);

        // Created the output document.
        DocumentBuilder docBuilder = dfactory.newDocumentBuilder();
        Document out = docBuilder.newDocument();

        // Perform the transformation.
        transformer.transform(xmlSource, new DOMResult(out));

        // If substitution values were provided, run through and replace the XPath values.
        if (xpath2values!=null && !xpath2values.isEmpty()) {

            // Get a node using XPath
            XPathFactory xpathFactory = new net.sf.saxon.xpath.XPathFactoryImpl();
            XPath xPath = xpathFactory.newXPath();

            for (Entry<String, String> kv : xpath2values.entrySet()) {
                String expression = kv.getKey().replaceAll("/[^:/]+:", "/");
                expression = expression.replaceAll("/", "/*:");
                Node node = (Node) xPath.evaluate(expression, out, XPathConstants.NODE);

                // Set the node content
                if (node != null)
                    node.setTextContent(kv.getValue());
            }
        }

        // Serialize the output so we can see the transformation actually worked
        Transformer serializer = tfactory.newTransformer();
        serializer.setOutputProperty(OutputKeys.INDENT, "yes");
        StringWriter writer = new StringWriter();
        serializer.transform(new DOMSource(out), new StreamResult(writer));
        return writer.toString();
    }
}