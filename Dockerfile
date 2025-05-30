# Use a modern version of Node.js
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /opt

# Add application source code to the container
ADD . /opt

# Install dependencies
RUN npm install

# Build the React application for production
RUN npm run build

# Install the lightweight Serve HTTP server globally
RUN npm install -g serve

# Set the default command to serve the production build
CMD ["serve", "-s", "build", "-l", "3000"]
