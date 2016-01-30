{%- set roles = grains['roles'] -%}

base:
  '*':
     - commons
{#
    Instead of if syntax loop over roles matching by grains to include each role in a pillar
    Syntax should be:
    'roles:haproxy'
      - match: grain
      - haproxy

    Tip: Use jinja for syntax {% for var in list %} .... {% endfor %}
#}
