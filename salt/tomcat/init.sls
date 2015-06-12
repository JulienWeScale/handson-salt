{% from "tomcat/map.jinja" import tomcat_settings with context %}

tomcat-user:
  user.present:
    - name: tomcat
    - fullname: Apache Tomcat
    - shell: /usr/sbin/nologin
    - home: /home/tomcat
    
tomcat-server:
  archive.extracted:
    - name: /home/tomcat
    - source: http://wwwftp.ciril.fr/pub/apache/tomcat/tomcat-8/v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz
    - source_hash: https://www.apache.org/dist/tomcat/tomcat-8/v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz.md5
    - archive_format: tar
    - user: tomcat
    - group: tomcat
    - if_missing: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}
  file.directory:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}
    - user: tomcat
    - group: tomcat
    - recurse: 
      - user
      - group

tomcat-exemples:
  file.absent:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/examples

tomcat-docs:
  file.absent:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/docs

tomcat-host-manager:
  file.absent:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/host-manager

tomcat-manager:
  file.absent:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/manager

tomcat-root:
  file.absent:
    - name: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/ROOT

/etc/init/tomcat.conf:
  file.managed:
    - template: jinja
    - source: salt://tomcat/files/tomcat.conf
    - user: root
    - group: root

tomcat:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/conf/*
      - file: /etc/init/tomcat.conf
      - file: /home/tomcat/apache-tomcat-{{tomcat_settings.version}}/webapps/*

/home/tomcat/apache-tomcat-{{tomcat_settings.version}}/conf/server.xml:
  file.managed:
  - template: jinja
  - source: salt://tomcat/files/server.xml
  - user: tomcat
  - group: tomcat
  - mode: 644
  - require: 
    - archive: tomcat-server


     

