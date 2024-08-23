FROM eclipse-temurin:11-jdk-focal

# Update package lists and install necessary packages
RUN apt-get update \
    && apt-get install -y unzip curl \
    && adduser --uid 1001 --home /home/sunbird --disabled-password --gecos '' sunbird \
    && mkdir -p /home/sunbird/lms

# Change ownership of the /home/sunbird directory
RUN chown -R sunbird:sunbird /home/sunbird

# Switch to the sunbird user
USER sunbird

# Copy the service file and unzip it
COPY ./service/target/lms-service-1.0-SNAPSHOT-dist.zip /home/sunbird/lms/
RUN unzip /home/sunbird/lms/lms-service-1.0-SNAPSHOT-dist.zip -d /home/sunbird/lms/

# Set the working directory and define the command to run
WORKDIR /home/sunbird/lms/
CMD java -XX:+PrintFlagsFinal $JAVA_OPTIONS -Dplay.server.http.idleTimeout=180s -cp '/home/sunbird/lms/lms-service-1.0-SNAPSHOT/lib/*' -Dlogger.file=/home/sunbird/lms/lms-service-1.0-SNAPSHOT/config/logback.xml play.core.server.ProdServerStart /home/sunbird/lms/lms-service-1.0-SNAPSHOT
