{#
   Include tomcat pillar her because haproxy needs tomcat:port
include:
#}

haproxy:
    backends:
{#
    Declare tomcats hostnames
        - teamX-tomcatY
        - teamX-tomcatZ
#}
