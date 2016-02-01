redis:
    pkg.installed: []
    file.managed:
        - name: /etc/redis.conf
        - makedirs: true
        - template: jinja
{#
        - source: salt://redis/files/redis.conf
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: redis
#}
    selinux.mode:
        - name: permissive

    service.running:
{#
        - enable: True
        - restart: True
        - watch ???
#}
