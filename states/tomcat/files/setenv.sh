{% from "tomcat/map.jinja" import tomcat_settings with context %}
CATALINA_OPTS="${CATALINA_OPTS} -Dredis_host={{ tomcat_settings.redis_host }} -Dredis_port={{ tomcat_settings.redit_port }}"

