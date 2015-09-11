#!/bin/bash

echo "Initializing tests..."
ANNOTATION_VERSIONS=(1.9.12 1.9.10 1.9.8 1.9.6 1.9.4 1.9.2 1.9.0 1.8.0 1.7.0 1.6.0 1.5.0 1.4.0 1.3.0 1.2.0 1.0.0 0.9.0)
PLUGIN_VERSIONS=(1.21.0 1.20.0 1.19.0 1.17.0 1.16.0 1.15.0 1.14.0 1.13.0 1.12.0 1.11.0 1.10.0 1.9.0 1.8.0 1.7.4 1.7.2 1.7.0 1.6.0 1.4.4 1.4.2 1.4.0)
rm -rf project-target
rm -rf target
mkdir -p target/logs
mkdir -p target/results

for ANNOTATION_VERSION in ${ANNOTATION_VERSIONS[@]}; do
	for PLUGIN_VERSION in ${PLUGIN_VERSIONS[@]}; do
        echo "Testing annotation: $ANNOTATION_VERSION with plugin: $PLUGIN_VERSION..."
        cp -r project project-target
        
        echo "Updating versions..."
        sed -i '' "s/ANNOTATION_VERSION/$ANNOTATION_VERSION/g" project-target/pom.xml
        sed -i '' "s/PLUGIN_VERSION/$PLUGIN_VERSION/g" project-target/pom.xml
        sed -i '' "s/ANNOTATION_VERSION/$ANNOTATION_VERSION/g" project-target/src/main/java/com/sixd/coe/test/impl/servlets/HelloWorldServlet.java
        sed -i '' "s/PLUGIN_VERSION/$PLUGIN_VERSION/g" project-target/src/main/java/com/sixd/coe/test/impl/servlets/HelloWorldServlet.java
        
        echo "Running maven build..."
        mvn -X clean install -P autoInstallBundle -f project-target/pom.xml >> target/logs/$ANNOTATION_VERSION-$PLUGIN_VERSION-build.log 2>&1
        
        rc=$?
		if [ $rc != 0 ] ; then
			echo "Failed to build annotations $ANNOTATION_VERSION with plugin $PLUGIN_VERSION..."
			echo "$ANNOTATION_VERSION,$PLUGIN_VERSION,false" >> target/report.csv
		else 
			echo "Successfully built annotations $ANNOTATION_VERSION with plugin $PLUGIN_VERSION..."
			wget -O target/results/$ANNOTATION_VERSION-$PLUGIN_VERSION.txt http://localhost:4502/bin/test/felix-test >> target/logs/$ANNOTATION_VERSION-$PLUGIN_VERSION-wget.log 2>&1
			if [ $rc != 0 ] ; then
				echo "Failed to validate servlet..."
				echo "$ANNOTATION_VERSION,$PLUGIN_VERSION,false" >> target/report.csv
			else 
				echo "Servlet validated successfully, content: "
				cat target/results/$ANNOTATION_VERSION-$PLUGIN_VERSION.txt
				echo "$ANNOTATION_VERSION,$PLUGIN_VERSION,true" >> target/report.csv
			fi
			echo "$ANNOTATION_VERSION,$PLUGIN_VERSION,true" >> target/report.csv
		fi
		rm -rf project-target
    done
done