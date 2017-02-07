IMAGENAME=s6build:alpine
RUNNAME=s6build
S6_VERSION=2.4.0.0
SKALIBS_VERSION=2.4.0.2
EXECLINE_VERSION=2.2.0.0

all: s6-binaries-$(S6_VERSION).tar.gz

.PHONY: docker
docker:
	docker info

.PHONY: wget
wget:
	wget --version

.PHONY: dockerimage
dockerimage: docker
	docker history $(IMAGENAME) || docker build -t $(IMAGENAME) .


.PHONY: dockerrun
dockerrun: dockerimage 
	-docker rm $(RUNNAME)
	docker run --name $(RUNNAME) -v $$PWD:/data -t $(IMAGENAME) make -f /data/Makefile build

execline-$(EXECLINE_VERSION).tar.gz: | wget
	wget http://skarnet.org/software/execline/execline-$(EXECLINE_VERSION).tar.gz

s6-$(S6_VERSION).tar.gz: | wget
	wget http://skarnet.org/software/s6/s6-$(S6_VERSION).tar.gz

skalibs-$(SKALIBS_VERSION).tar.gz: | wget
	wget http://skarnet.org/software/skalibs/skalibs-$(SKALIBS_VERSION).tar.gz

.PHONY: build
build:
	tar xvfz /data/skalibs-$(SKALIBS_VERSION).tar.gz
	cd skalibs-$(SKALIBS_VERSION) && ./configure && make && make install
	tar xvfz /data/execline-$(EXECLINE_VERSION).tar.gz
	cd execline-$(EXECLINE_VERSION) && ./configure && make && make install
	tar xvfz /data/s6-$(S6_VERSION).tar.gz 
	cd s6-$(S6_VERSION) && ./configure --enable-static-libc && make && \
	  mkdir temp && \
	  cp s6-* temp && \
	  mv temp s6-binaries-$(S6_VERSION) && \
	  tar cvfz /data/s6-binaries-$(S6_VERSION).tar.gz s6-binaries-$(S6_VERSION)

.PHONY: sources
sources: execline-$(EXECLINE_VERSION).tar.gz s6-$(S6_VERSION).tar.gz skalibs-$(SKALIBS_VERSION).tar.gz

s6-binaries-$(S6_VERSION).tar.gz: sources dockerrun

clean: docker
	-docker stop $(RUNNAME)
	-docker rm $(RUNNAME)
	-docker rmi $(IMAGENAME)
	-rm execline-$(EXECLINE_VERSION).tar.gz s6-$(S6_VERSION).tar.gz skalibs-$(SKALIBS_VERSION).tar.gz
	-rm s6-binaries-$(S6_VERSION).tar.gz

