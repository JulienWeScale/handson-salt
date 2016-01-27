{% from "tomcat/map.jinja" import tomcat_settings with context %}

include:
  - java8

tomcat-user:
  user.present:
    - name: tomcat
    - fullname: Apache Tomcat
    - shell: /usr/sbin/nologin
    - home: {{ tomcat_settings.home }}
    
tomcat-server:
  archive.extracted:
    - name: {{ tomcat_settings.home }}
    - source: http://archive.apache.org/dist/tomcat/tomcat-8/v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz
    - source_hash: http://archive.apache.org/dist/tomcat/tomcat-8//v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz.md5
    - archive_format: tar
    - archive_user: tomcat
    - if_missing: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}
  file.directory:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}
    - user: {{tomcat_settings.user}}
    - group: {{tomcat_settings.group}}
    - recurse:
      - user
      - group

tomcat-exemples:
  file.absent:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/examples

tomcat-docs:
  file.absent:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/docs

tomcat-host-manager:
  file.absent:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/host-manager

tomcat-manager:
  file.absent:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/manager

tomcat-root:
  file.absent:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/ROOT

/etc/systemd/system/tomcat.service:
  file.managed:
    - template: jinja
    - source: salt://tomcat/files/tomcat.service
    - user: root
    - group: root

tomcat:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/conf/*
      - file: /etc/systemd/system/tomcat.service
      - file: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/*

{{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/conf/server.xml:
  file.managed:
  - template: jinja
  - source: salt://tomcat/files/server.xml
  - user: tomcat
  - group: tomcat
  - mode: 644
  - require: 
    - archive: tomcat-server


     

