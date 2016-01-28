{%- set roles = grains['roles'] -%}

base:
  '*':
     - commons
     - mine
{%- for role in roles %}
  'roles:{{ role }}':
    - match: grain
    - {{ role }}
{%- endfor -%}
