HOME=$(shell pwd)
VERSION="1"
RELEASE="1"
NAME=logstash-forwarder
SPEC=$(shell bash ./getspec $NAME)

all: build

clean:
	rm -rf ./rpmbuild
	rm -rf ./SOURCES/logstash-forwarder
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/
	mkdir -p ./SPECS ./SOURCES

get-thirdparty:
	git clone https://github.com/elasticsearch/logstash-forwarder ./SOURCES/logstash-forwarder

tidy-thirdparty:
	rm -rf ./SOURCES/logstash-forwarder
	mv ./SOURCES/logstash-forwarder.bin ./SOURCES/logstash-forwarder

build-thirdparty: get-thirdparty
	cd ./SOURCES/logstash-forwarder; go build 
	cp ./SOURCES/logstash-forwarder/logstash-forwarder ./SOURCES/logstash-forwarder.bin

build: clean build-thirdparty tidy-thirdparty
	cp -r ./SPECS/* ./rpmbuild/SPECS/ || true
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/ || true
	echo ${SPEC}