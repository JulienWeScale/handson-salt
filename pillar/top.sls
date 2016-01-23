{%- set roles = grains['roles'] -%}

base:
  '*':
     - mine
     - commons
{%- for role in roles %}
  'roles:{{ role }}':
    - match: grain
    - {{ role }}
{%- endfor -%}
