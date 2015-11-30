FROM debian:7

RUN apt-get update -y && \
    apt-get install build-essential \
                    bison \
                    flex \
                    cmake \
                    rpm \
                    alien \
                    nsis \
                    pkg-config \
                    libglib2.0-dev \
                    libgnutls-dev \
                    libpcap0.8-dev \
                    libgpgme11 \
                    libgpgme11-dev \
                    libhiredis-dev \
                    libssh-dev \
                    openssh-client \
                    doxygen \
                    libuuid1 \
                    uuid-dev \
                    sqlfairy \
                    xmltoman \
                    sqlite3 \
                    libsqlite3-dev \
                    libsqlite3-tcl \
                    libxml2-dev \
                    libxslt1.1 \
                    libxslt1-dev \
                    libcurl4-gnutls-dev \
		    libkrb5-dev \
		    libpopt-dev \
		    libssl-dev \
  	 	    heimdal-multidev \
 		    mingw32 \
                    xsltproc \
                    libmicrohttpd-dev \
                    wget \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    unzip \
                    wapiti \
                    nmap \
		    redis-server \
		    gnupg \
		    libpq-dev \
		    postgresql-server-dev-all \
		    postgresql-client \
		    postgresql-contrib \
		    postgresql \
                    -y --no-install-recommends --force-yes && \
    mkdir /openvas-src && \
    cd /openvas-src && \
        wget http://wald.intevation.org/frs/download.php/2125/openvas-libraries-8.0.5.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2129/openvas-scanner-5.0.4.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2169/openvas-manager-6.0.6.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2173/greenbone-security-assistant-6.0.6.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2141/openvas-cli-1.4.3.tar.gz && \
	wget http://wald.intevation.org/frs/download.php/1975/openvas-smb-1.0.1.tar.gz && \
    cd /openvas-src/ && \
        tar zxvf openvas-libraries-8.*.tar.gz && \
        tar zxvf openvas-scanner-5.*.tar.gz && \
        tar zxvf openvas-manager-6.*.tar.gz && \
        tar zxvf greenbone-security-assistant-6.*.tar.gz && \
        tar zxvf openvas-cli-1.*.tar.gz && \
	tar zxvf openvas-smb-1.*.tar.gz && \
    LDFLAGS="$LDFLAGS -Wl,--no-as-needed" && \
    cd /openvas-src/openvas-smb-1.* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-libraries-8.* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-scanner-5.* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-manager-6.* && \
        mkdir source && \
        cd source && \
        cmake -DBACKEND=POSTGRESQL .. && \
        make && \
        make install && \
    cd /openvas-src/greenbone-security-assistant-6.* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-cli-1.* && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    rm -rf /openvas-src && \
    mkdir /dirb && \
    cd /dirb && \
    wget http://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
        tar -zxvf dirb222.tar.gz && \
        cd dirb222 && \
        chmod 700 -R * && \
        ./configure && \
        make && \
        make install && \
    cd / && \
    cd /tmp && \
    wget https://github.com/Arachni/arachni/releases/download/v1.2.1/arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
        tar -zxvf arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
        mv arachni-1.2.1-0.5.7.1 /opt/arachni && \
        ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    cd ~ && \
    wget https://github.com/sullo/nikto/archive/master.zip && \
    unzip master.zip -d /tmp && \
    mv /tmp/nikto-master/program /opt/nikto && \
    rm -rf /tmp/nikto-master && \
    echo "EXECDIR=/opt/nikto\nPLUGINDIR=/opt/nikto/plugins\nDBDIR=/opt/nikto/databases\nTEMPLATEDIR=/opt/nikto/templates\nDOCDIR=/opt/nikto/docs" >> /opt/nikto/nikto.conf && \
    ln -s /opt/nikto/nikto.pl /usr/local/bin/nikto.pl && \
    ln -s /opt/nikto/nikto.conf /etc/nikto.conf && \
    mkdir -p /openvas && \
    wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O /openvas/openvas-check-setup && \
    chmod a+x /openvas/openvas-check-setup && \
    apt-get clean -yq && \
    apt-get autoremove -yq && \
    apt-get purge -y --auto-remove build-essential cmake

ADD bin/setup.sh /openvas/
RUN chmod 700 /openvas/*.sh && \
	bash /openvas/setup.sh

#Setup redis config
RUN sed -i 's|^# unixsocketperm 755|unixsocketperm 755|;s|^# unixsocket /var/run/redis/redis.sock|unixsocket /tmp/redis.sock|;s|^port 6379|#port 6379|' /etc/redis/redis.conf

ADD bin/start.sh /openvas/
RUN chmod 700 /openvas/*.sh

# Expose UI
EXPOSE 443 9390 9391 9392

CMD ["/bin/bash", "/openvas/start.sh"]
