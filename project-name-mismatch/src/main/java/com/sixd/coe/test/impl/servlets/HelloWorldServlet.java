package com.sixd.coe.testt.impl.servlets;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sixd.coe.test.HelloService;

/**
 * Simple servlet filter component that logs incoming requests.
 */
@SlingServlet(generateComponent = false, generateService = true, paths = { "/bin/test/felix-test" }, methods = { "GET" })
@Component(immediate = true, metatype = false)
public class HelloWorldServlet extends SlingSafeMethodsServlet {

	private Logger log = LoggerFactory.getLogger(HelloWorldServlet.class);

	@Reference
	private HelloService helloService;

	protected void doGet(SlingHttpServletRequest request,
			SlingHttpServletResponse response) throws ServletException,
			IOException {
		log.trace("doGet");
		response.getWriter().write(helloService.getRepositoryName() +"-ANNOTATION_VERSION-PLUGIN_VERSION");
	}
}
