FROM electronuserland/builder:wine

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update -y && apt-get install -y --no-install-recommends xvfb google-chrome-stable libgconf-2-4 sudo && \
  # clean
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd testuser \
	--shell /bin/bash \
	--create-home \
	&& usermod -a -G sudo testuser \
	&& echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
	&& echo 'testuser:secret' | chpasswd
ENV HOME=/home/testuser

ENV ELECTRON_ENABLE_STACK_DUMPING=true
ENV ELECTRON_ENABLE_LOGGINE=true
ENV DISPLAY=:99

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY wrap_chrome_binary /opt/bin/wrap_chrome_binary
RUN chmod +x /opt/bin/wrap_chrome_binary
RUN /opt/bin/wrap_chrome_binary

RUN google-chrome --version

USER testuser

ENTRYPOINT ["/entrypoint.sh"]

