

haproxy:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: haproxy

{#
    Add a managed file to generate haproxy.cfg template in '/etc/haproxy/haproxy.cfg'
    Care to ensure haproxy service will be reloaded if this file changes with a 'watch_in'

    See: https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html
#}


/etc/default/haproxy:
  file.managed:
    - source: salt://haproxy/files/haproxy.default
    - watch_in:
      - service: haproxy 