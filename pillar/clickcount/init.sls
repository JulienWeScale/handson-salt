{#
    Here we include redis and tomcat pillars because they are needed by clickcount
 #}
include:
    - redis
    - tomcat

clickcount:
{#
    Add redis_host as the concatenation of grains 'team' and '-redis'
    see grains.get https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.grains.html#salt.modules.grains.get
 #}
  war_url: 'https://github.com/mparisot-wescale/click-count/releases/download/v1.1/clickCount.war'
  war_hash: 'md5=8d65508f2974751a7c221106a110e45d'