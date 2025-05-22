FROM node:7.8.0
WORKDIR /opt
ADD . /opt
RUN npm install
RUN npm run build
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]
#ENTRYPOINT npm run start
