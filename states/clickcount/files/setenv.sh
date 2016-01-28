{%- from "clickcount/map.jinja" import clickcount_settings with context -%}
CATALINA_OPTS="${CATALINA_OPTS} -Dredis_host={{ clickcount_settings.redis_host }} -Dredis_port={{ clickcount_settings.redis_port }}"

