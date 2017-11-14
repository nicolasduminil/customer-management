FROM jboss/wildfly:10.1.0.Final
USER jboss:jboss
ADD customization /opt/jboss/wildfly/customization/
RUN ls -l /opt/jboss/wildfly/customization
COPY customization/target/customer-management.war /opt/jboss/wildfly/target/customer-management.war
RUN /opt/jboss/wildfly/customization/customize.sh

