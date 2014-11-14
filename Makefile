HOME=$(shell pwd)
VERSION="1"
RELEASE=$(shell ./make_helper/get-git-rev .)
NAME=logstash-forwarder
SPEC=$(shell ./make_helper/get-spec ${NAME})
ARCH=$(shell ./make_helper/get-arch)
OS_RELEASE=$(shell lsb_release -rs | cut -f1 -d.)

all: build

clean:
	rm -rf ./rpmbuild
	rm -rf ./SOURCES/logstash-forwarder
	rm -rf ./SOURCES/logstash-forwarder.bin
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	mkdir -p ./SPECS ./SOURCES

get-thirdparty:
	git clone https://github.com/elasticsearch/logstash-forwarder ./SOURCES/logstash-forwarder

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
