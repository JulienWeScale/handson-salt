{%- set roles = grains['roles'] -%}

base:
  '*':
     - commons
{%- if 'redis' in roles  %}
     - redis
{%- endif %}
