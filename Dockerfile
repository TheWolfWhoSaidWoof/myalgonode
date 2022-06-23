FROM algorand/stable:latest

ENV ALGORAND_DATA="/root/node/data"

ENV PATH="/root/node/:${PATH}"

COPY startup.sh /root/node/startup.sh

EXPOSE 8080

WORKDIR /root/node

CMD ["/root/node/startup.sh"]
