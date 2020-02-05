FROM electronuserland/builder:latest

RUN apt-get update \
 && apt-get install -y xvfb libxss1 libasound2 socat chromium google-chrome-latest \
 && rm -rf /var/lib/apt/lists/*

ENV ELECTRON_ENABLE_STACK_DUMPING=true
ENV ELECTRON_ENABLE_LOGGINE=true
ENV DISPLAY=:99

COPY entrypoint.sh /entrypoint.sh
RUN CHMOD +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

