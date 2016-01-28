include:
    - redis
    - tomcat

clickcount:
  redis_host: {{ grains.get('team', '') ~ '-redis' }}
  war_url: 'https://github.com/mparisot-wescale/click-count/releases/download/v1.1/clickCount.war'
  war_hash: 'md5=8d65508f2974751a7c221106a110e45d'