{% from "clickcount/map.jinja" import clickcount_settings with context %}
{% from "tomcat/map.jinja" import tomcat_settings with context %}

{%  set tomcat_root = tomcat_settings.home ~ '/apache-tomcat-' ~ tomcat_settings.version %}

include:
  - tomcat

create-tomcat-setenv.sh:
  file.managed:
    - name: {{ tomcat_root }}/bin/setenv.sh
    - source: salt://clickcount/files/setenv.sh
    - template: jinja
    - watch_in:
        - service: tomcat

install_webapp:
  file.managed:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/ROOT.war
    - source: {{ clickcount_settings.war_url }}
    - source_hash: {{ clickcount_settings.war_hash }}
    - watch_in:
        - service: tomcat
