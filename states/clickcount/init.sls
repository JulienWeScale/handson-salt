{% from "clickcount/map.jinja" import clickcount_settings with context %}
{% from "tomcat/map.jinja" import tomcat_settings with context %}

include:
  - tomcat

create-tomcat-setenv.sh:
  file.managed:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/bin/setenv.sh
update-tomcat-setenv.sh:
  file.replace:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/bin/setenv.sh
    - pattern: |
        CATALINA_OPTS="${CATALINA_OPTS} -Dredis_host={{ clickcount_settings.redis_host }} -Dredis_port={{ clickcount_settings.redis_port }}"
    - repl: |
        CATALINA_OPTS="${CATALINA_OPTS} -Dredis_host={{ clickcount_settings.redis_host }} -Dredis_port={{ clickcount_settings.redis_port }}"
    - append_if_not_found: True
    - watch_in: tomcat

install_webapp:
  file.managed:
    - name: {{ tomcat_settings.home }}/apache-tomcat-{{tomcat_settings.version}}/webapps/ROOT.war
    - source: {{ clickcount_settings.war_url }}
    - source_hash: {{ clickcount_settings.war_hash }}
    - watch_in: tomcat
