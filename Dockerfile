FROM node:10.12
COPY pgdq.list /etc/apt/sources.list.d/pgdg.list
# Debian Jessie mirrors were removed
RUN echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

# Debian Jessie mirrors were removed
RUN set -eux; \
  # Jessie's apt doesn't support [check-valid-until=no] so we have to use this instead
  apt-get -o Acquire::Check-Valid-Until=false update  
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -
RUN apt-get install -y --force-yes postgresql-9.6 postgresql-contrib-9.6 \
  && apt-get install sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# copy working ph_hba.conf with trust for localhost connection_string
COPY pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf
# Chrome browser for Headless Testing
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN set -eux; \
  # Jessie's apt doesn't support [check-valid-until=no] so we have to use this instead
  apt-get -o Acquire::Check-Valid-Until=false update  
RUN sudo apt -y install google-chrome-stable

RUN apt-get install -y \
  libgtk2.0-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  xvfb
