%global service_name %{name}

Name:           %{name}
Version:        %{ver}
Release:        %{rel}%{?dist}
Summary:        Logstash Forwarder for RHEL/CENTOS %{os_rel}
BuildArch:      noarch
Group:          Application/Internet
License:        commercial
URL:            https://github.com/elasticsearch/logstash-forwarder
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Logstash Forwarder for RHEL/CENTOS %{os_rel}

%prep
%setup -q -n %{name}-%{version}

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/logstash-forwarder/log/
install -m 755 logstash-forwarder.bin $RPM_BUILD_ROOT/opt/logstash-forwarder/logstash-forwarder
install -m 755 logstash-forwarder.sh $RPM_BUILD_ROOT/opt/logstash-forwarder/logstash-forwarder.sh
install -m 755 logstash-forwarder.conf $RPM_BUILD_ROOT/opt/logstash-forwarder/logstash-forwarder.conf
install -m 755 logstash-forwarder.init $RPM_BUILD_ROOT/etc/init.d/system/logstash-forwarder

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%attr(0755,root,root) /opt/logstash-forwarder/*
%config /opt/logstash-forwarder/logstash-forwarder.conf

%changelog
* Thu Nov 13 2014 Daniel Menet <daniel.menet@swisstxt.ch> - 1-1
Initial creation
