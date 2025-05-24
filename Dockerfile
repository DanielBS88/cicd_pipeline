# Use a modern version of Node.js
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /opt

# Add application source code to the container
ADD . /opt

# Install dependencies
RUN npm install

# Dynamically replace logo.svg using the branch-specific file
ARG LOGO=src/logo.svg
RUN cp $LOGO src/logo.svg

# Clear cached React builds to ensure updated logo is picked up
RUN rm -rf build/

# Build the React application for production
RUN npm run build

# Dynamically replace logo.svg (passed as build argument via Jenkinsfile)
#ARG LOGO=src/logo.svg
#RUN cp $LOGO src/logo.svg
# Clear cached React builds to force logo replacement
#RUN rm -rf build/
# Build the React application for production
#RUN npm run build

# Install the lightweight Serve HTTP server globally
RUN npm install -g serve

# Set the default command to serve the production build
CMD ["serve", "-s", "build", "-l", "3000"]
