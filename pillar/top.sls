{%- set roles = grains['roles'] -%}

base:
  '*':
     - commons
{#
    Include the mine pillar to activate the mine
     - mine
#}
{%- for role in roles %}
  'roles:{{ role }}':
    - match: grain
    - {{ role }}
{%- endfor -%}
