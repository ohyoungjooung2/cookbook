default[:tomcat][:dir] = "/usr/local/tomcat"
default[:tomcat][:user] = "tomcat"
default[:tomcat][:group] = "tomcat"
default[:tomcat][:port] = "9000"
default[:tomcat][:java_home] = "/usr/local/java"
default[:tomcat][:java_opts] = "\"-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC\""
default[:tomcat][:desc] = "Tomcat Servlet Engine 8"
default[:tomcat][:default] = "/etc/default/tomcat8"
default[:tomcat][:jvm_tmp] = "/tmp/tomcat8-tmp"
default[:tomcat][:pid] = "/var/run/tomcat8.pid"
default[:tomcat][:catalinaopts] = "-DJENKINS_HOME=/usr/local/tomcat/webapps/jenkins/ -Xmx512m"
default[:tomcat][:jenkins_xml] = "/usr/local/tomcat/conf/Catalina/localhost/jenkins.xml"
default[:tomcat][:jenkins_war_path] = "/usr/local/tomcat/jenkins-stable.war"
default[:tomcat][:jenkins_home] = "/data/jenkins"
default[:tomcat][:jenkins_base] = "/data"