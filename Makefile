HOME=$(shell pwd)
VERSION="1"
NAME=logstash-forwarder
RELEASE=$(shell /opt/buildhelper/buildhelper getgitrev .)
SPEC=$(shell /opt/buildhelper/buildhelper getspec ${NAME})
ARCH=$(shell /opt/buildhelper/buildhelper getarch)
OS_RELEASE=$(shell /opt/buildhelper/buildhelper getosrelease)


all: build

clean:
	rm -rf ./rpmbuild
	rm -rf ./SOURCES/logstash-forwarder
	rm -rf ./SOURCES/logstash-forwarder.bin
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	mkdir -p ./SPECS ./SOURCES

get-thirdparty:
	git clone https://github.com/elastic/logstash-forwarder ./SOURCES/logstash-forwarder

tidy-thirdparty:
	rm -rf ./SOURCES/logstash-forwarder

build-thirdparty: get-thirdparty
	cd ./SOURCES/logstash-forwarder; go build
	cp ./SOURCES/logstash-forwarder/logstash-forwarder ./SOURCES/logstash-forwarder.bin

build: clean build-thirdparty tidy-thirdparty
	cp -r ./SPECS/* ./rpmbuild/SPECS/ || true
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/ || true
	rpmbuild -ba ${SPEC} \
	--define "ver ${VERSION}" \
	--define "rel ${RELEASE}" \
	--define "name ${NAME}" \
	--define "os_rel ${OS_RELEASE}" \
	--define "arch ${ARCH}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \

publish:
	/opt/buildhelper/buildhelper pushrpm yum-01.stxt.media.int:8080/swisstxt-centos
