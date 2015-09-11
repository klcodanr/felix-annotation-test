Felix Annotation Test
========

This project is for testing which versions of the `org.apache.felix.scr.annotations` and 
`maven-scr-plugin` are compatible with each other.

Running
--------

To run this test start up an AEM / Sling instance on the port `4502` with the credentials 
admin/admin and execute the script:

	./run-test.sh
	
The results of the tests will be written to the the file `target/report.csv`

