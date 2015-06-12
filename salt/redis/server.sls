
{% from "redis/map.jinja" import redis_settings with context %}

redis-server:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - pkg: redis-server
      - file: /etc/redis/redis.conf

/etc/redis/redis.conf:
  file.managed:
  - template: jinja
  - source: salt://redis/files/redis.conf
  - user: root
  - group: root
  - mode: 644
  - require: 
    - pkg: redis-server
     
