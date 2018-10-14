# このDockerfileは、gitbookでPDFを作成するためのものです
# gitbookでPDFを出力するには、電子書籍の読み書きができる

FROM node:8

ENV LANG ja_JP.UTF-8
RUN echo "deb http://http.debian.net/debian jessie-backports main" >>/etc/apt/sources.list \
  && apt-get clean \
  && apt-get update \
  && apt-get install -y locales-all \
  # for node-canvas (plugin-autocover)
  && apt-get install -y libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++

# Caribre
RUN apt-get install -y libgl1-mesa-dev libxcomposite-dev
RUN wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py \
  | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)"
ENV PATH $PATH:/opt/calibre

# PDF用フォント
RUN apt-get install -y fonts-noto fonts-noto-cjk fonts-migmix
COPY fonts-local.conf /etc/fonts/local.conf

# plantuml用
RUN apt-get install -y graphviz default-jre

# gitbook
RUN npm install -g gitbook-cli \
  && gitbook fetch 3.2.3

# plantuml用svg
RUN npm install -g svgexport --unsafe-perm

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
