FROM node:18-alpine

WORKDIR /opt

ADD . /opt

RUN npm install

# Replace dynamic logo
ARG LOGO=src/logo.svg
RUN cp $LOGO src/logo.svg

# Clear any cached builds to ensure proper React rebuild
RUN rm -rf build/

# Build the React app (ensure updated logo is reflected)
RUN npm run build

RUN npm install -g serve

CMD ["serve", "-s", "build", "-l", "3000"]
