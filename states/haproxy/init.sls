

haproxy:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/files/haproxy.cfg
    - template: jinja
    - watch_in:
      - service: haproxy

/etc/default/haproxy:
  file.managed:
    - source: salt://haproxy/files/haproxy.default
    - watch_in:
      - service: haproxy 