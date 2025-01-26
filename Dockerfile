FROM kalilinux/kali-rolling

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install wget

RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

EXPOSE 8000
RUN echo $CREDENTIAL > /tmp/debug

CMD ["/bin/bash", "-c", "/bin/ttyd -p 8000 -c root:root /bin/bash"]
