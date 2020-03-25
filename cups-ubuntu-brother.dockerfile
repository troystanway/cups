FROM i386/ubuntu:latest

MAINTAINER Dung Tri LE <geekwhynot@gmail.com>

RUN apt-get update && apt-get install -y \
	cups cups-pdf curl && \
        rm -rf /var/lib/apt/lists/* && \
	sed -i 's/Listen localhost:632/Listen 0.0.0.0:632/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

RUN curl https://download.brother.com/welcome/dlfp100139/td4100nlpr-1.0.3-0.i386.deb --output td4100nlpr-1.0.3-0.i386.deb && \
    dpkg -i --force-all td4100nlpr-1.0.3-0.i386.deb && \
    curl https://download.brother.com/welcome/dlfp100140/td4100ncupswrapper-1.0.3-0.i386.deb --output td4100ncupswrapper-1.0.3-0.i386.deb && \
    dpkg -i --force-all td4100ncupswrapper-1.0.3-0.i386.deb && \
    dpkg -l | grep Brother && \
    rm -f td4100nlpr-1.0.3-0.i386.deb td4100ncupswrapper-1.0.3-0.i386.deb && \
    apt-get purge -y curl libcurl4 libnghttp2-14 libpsl5 librtmp1 publicsuffix

VOLUME /etc/cups/ /var/log/cups /var/spool/cups /var/spool/cups-pdf /var/cache/cups

COPY start-cups.sh /root/start-cups.sh
RUN chmod +x /root/start-cups.sh

CMD ["/root/start-cups.sh"]

EXPOSE 632
