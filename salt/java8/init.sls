{% set java_prefix = '/usr/share/jdk8' %}
{% set java_home = '/usr/share/java' %}
{% set java_dirname = 'jdk1.8.0_40' %}

{{ java_prefix }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

unpack-jdk-tarball:
  cmd.run:
    - name: curl -b oraclelicense=accept-securebackup-cookie -L http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz | tar -xz --no-same-owner
    - unless: ls {{ java_prefix }}/{{ java_dirname }}
    - cwd: {{ java_prefix }}
    - require:
      - file: {{ java_prefix }}
  file.symlink:
    - name: {{ java_home }}
    - target: {{ java_prefix }}/{{ java_dirname }}

env-config:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://java8/files/java.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      java_home: {{ java_home }}