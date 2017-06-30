FROM node:8.1

WORKDIR /var/www

EXPOSE 8080

CMD [ "npm", "start" ]

ENTRYPOINT ["/usr/local/bin/npm", "run"]