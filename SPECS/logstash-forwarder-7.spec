%global service_name %{name}

Name:           %{name}
Version:        %{ver}
Release:        %{rel}%{?dist}
Summary:        Logstash Forwarder for RHEL/CENTOS %{os_rel}
BuildArch:      %{arch}
Group:          Application/Internet
License:        commercial
URL:            https://github.com/elastic/logstash-forwarder
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Source1:        logstash-forwarder.bin
Source2:        logstash-forwarder.conf
Source3:        logstash-forwarder.service

%define appdir /opt/%{name}
%define systemd_dest /usr/lib/systemd/system/
%description
Logstash Forwarder for RHEL/CENTOS %{os_rel}

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{appdir}
mkdir -p $RPM_BUILD_ROOT/%{systemd_dest}
%{__install} -p -m 0755 %{SOURCE1} $RPM_BUILD_ROOT/%{appdir}/logstash-forwarder
%{__install} -p -m 0750 %{SOURCE2} $RPM_BUILD_ROOT/%{appdir}/logstash-forwarder.conf
%{__install} -p -m 0755 %{SOURCE3} $RPM_BUILD_ROOT/%{systemd_dest}/logstash-forwarder.service

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%attr(0755,root,root) %{appdir}
%attr(0755,root,root) %{appdir}/*
%attr(0755,root,root) %{systemd_dest}/logstash-forwarder.service
%config(noreplace) %{appdir}/logstash-forwarder.conf

%changelog
* Thu Nov 13 2014 Daniel Menet <daniel.menet@swisstxt.ch> - 1-1
Initial creation
