{#
    Import tomcat_settings from map.jinja see redis.conf for correct syntax
    from ... import ... with context
#}

{%  set tomcat_root = tomcat_settings.home ~ '/apache-tomcat-' ~ tomcat_settings.version %}

{#
Include java8 state here before trying tomcat installation
include:
  - java8
#}

tomcat-user:
{#
    Create the tomcat user with shell as /usr/sbin/nologin and home as defined in tomcat_settings.home
    see https://docs.saltstack.com/en/latest/ref/states/all/salt.states.user.html
#}

    
tomcat-server:
  archive.extracted:
    - name: {{ tomcat_settings.home }}
    - source: http://archive.apache.org/dist/tomcat/tomcat-8/v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz
    - source_hash: http://archive.apache.org/dist/tomcat/tomcat-8/v{{tomcat_settings.version}}/bin/apache-tomcat-{{tomcat_settings.version}}.tar.gz.md5
    - archive_format: tar
    - archive_user: tomcat
    - if_missing: {{ tomcat_root }}
  file.directory:
    - name: {{ tomcat_root }}
{#
    Fix owner and group for all files and dirs under tomcat_root
    see recurse in https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html#salt.states.file.directory
#}

tomcat-exemples:
  file.absent:
    - name: {{ tomcat_root }}/webapps/examples

tomcat-docs:
{#
    remove docs webapps in tomcat_root/webapps/docs
#}

tomcat-host-manager:
  file.absent:
    - name: {{ tomcat_root }}/webapps/host-manager

tomcat-manager:
  file.absent:
    - name: {{ tomcat_root }}/webapps/manager

tomcat-root:
  file.absent:
    - name: {{ tomcat_root }}/webapps/ROOT

/etc/systemd/system/tomcat.service:
{#
    Use file.managed to generate tomcat.service file and install it as root:root
#}

tomcat:
  service.running:
    - enable: True
    - restart: True
    - watch:
        - file: {{ tomcat_root }}/conf/*
{#
    watch changes in service unit file and webapps to restart tomcat when needed
#}

{{ tomcat_root }}/conf/server.xml:
  file.managed:
    - template: jinja
    - source: salt://tomcat/files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - require:
        - archive: tomcat-server


     

