{% from "clickcount/map.jinja" import clickcount_settings with context %}
{% from "tomcat/map.jinja" import tomcat_settings with context %}

{%  set tomcat_root = tomcat_settings.home ~ '/apache-tomcat-' ~ tomcat_settings.version %}

{#
    include tomcat state to be sure to have tomcat installed here
    see https://docs.saltstack.com/en/latest/ref/states/include.html
 #}

create-tomcat-setenv.sh:
  file.managed:
    - name: {{ tomcat_root }}/bin/setenv.sh
{#
    declare source template in jinja and ensure tomcat will restart with watch_in on service: tomcat
#}

install_webapp:
  file.managed:
    - name: {{ tomcat_root }}/webapps/ROOT.war
{# declare source with settings war_url #}
    - source_hash: {{ clickcount_settings.war_hash }}
    - watch_in:
        - service: tomcat
