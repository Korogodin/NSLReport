# build with: sudo docker build -t navsyslab/nslreport:v1 .
# run with:   sudo docker run -it -v ~/NSLReport:/tmp/tex navsyslab/nslreport:v1
# 

FROM ubuntu:20.04
RUN sed -i'' 's/archive\.ubuntu\.com/us\.archive\.ubuntu\.com/' /etc/apt/sources.list
MAINTAINER Ilya Korogodin <korogodiniv@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y \
            make \
            inkscape \
            imagemagick \ 
            latexmk \
            texlive-latex-base \
            texlive-latex-extra \
            texlive-extra-utils \
            texlive-lang-cyrillic \
            texlive-luatex \ 
            texlive-bibtex-extra \
            biber \
            cm-super \
            && \
rm -rf /var/lib/apt/lists/* && \
apt clean

RUN sed -i 's/^.*policy.*coder.*none.*PDF.*//' /etc/ImageMagick-6/policy.xml

# COPY ../fonts/* /usr/local/share/fonts/
# %RUN fc-cache -f -v && luaotfload-tool -u -f
    
#make a Testman user
RUN adduser --disabled-password --gecos '' testman
USER testman
WORKDIR /home/testman

