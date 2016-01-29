{% set java_prefix = '/usr/share/jdk8' %}
{% set java_home = '/usr/share/java' %}
{% set java_dirname = 'jdk1.8.0_40' %}

{{ java_prefix }}:
  file.directory:
{#
    create the java directory with user root
    it must be accessible for all and create missing directories
    see https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html#salt.states.file.directory
 #}

unpack-jdk-tarball:
  cmd.run:
    - name: curl -b oraclelicense=accept-securebackup-cookie -L http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz | tar -xz --no-same-owner
{#
    Add missing directive so we do not download jdk if it has already been done
    see https://docs.saltstack.com/en/latest/ref/states/all/salt.states.cmd.html#salt.states.cmd.run
 #}
    - cwd: {{ java_prefix }}
    - require:
      - file: {{ java_prefix }}
  file.symlink:
    - name: {{ java_home }}
    - target: {{ java_prefix }}/{{ java_dirname }}

env-config:
  file.managed:
    - name: /etc/profile.d/java.sh
{#
    Add templating for this file in jinja
    it should be protected mode 644 and owned by user root
    WARNING: template file need a variable
    see https://docs.saltstack.com/en/latest/ref/states/all/salt.states.file.html#salt.states.file.managed
#}

