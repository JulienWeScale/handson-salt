{#
Add this to your master config file

reactor:                            # Master config section "reactor"

  - 'minion/bootstrap/done':        # Match tag "minion/bootstrap/done"
    - salt://reactor/register_minion.sls        # Things to do when a minion starts
#}

{% if '-tomcat' in data['id'] and 'clickcount' in data['data']['grains']['roles'] %}
tomcat_highstate_run:
  local.state.highstate:
    - tgt: {{ data['id'] }}

haproxy_highstate:
  local.state.highstate:
    - tgt: 'roles:haproxy'
    - expr_form: grain
{% endif %}

