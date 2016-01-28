redis-server:
    pkg.installed: []
    file.managed:
        - name: /etc/redis/redis.conf
        - template: jinja
{#
        - source: salt://redis/files/redis.conf
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: redis-server
#}
    service.running:
{#
        - enable: True
        - restart: True
        - watch ???
#}
