FROM electronuserland/builder:wine-chrome

RUN apt-get update && apt-get install sudo -y

RUN useradd suituser \
	--shell /bin/bash \
	--create-home \
	&& usermod -a -G sudo suituser \
	&& echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
	&& echo 'suituser:secret' | chpasswd
ENV HOME=/home/suituser

ENV ELECTRON_ENABLE_STACK_DUMPING=true
ENV ELECTRON_ENABLE_LOGGINE=true
ENV DISPLAY=:99

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY wrap_chrome_binary /opt/bin/wrap_chrome_binary
RUN /opt/bin/wrap_chrome_binary


ARG CHROME_DRIVER_VERSION="80.0.3987.16"
RUN echo "Using chromedriver version: "$CHROME_DRIVER_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

USER suituser

ENTRYPOINT ["/entrypoint.sh"]

