# == Define: nbngateway::webserver::gis
#
# This is the gis resource type. It will create a new balancermember for the 
# gis balancer (see webserver.pp). The member will back onto a managed tomcat
# which is running the gis war
#
# === Parameters
#
# [*port*] The ajp port which the gis tomcat will be running on
# [*war*]  The location of the api deploy locally
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define nbngateway::webserver::gis (
  $port = 7102,
  $war  = $nbngateway::gis_war
) {
  apache::balancermember { $title :
    balancer_cluster => 'gis',
    url              => 'ajp://localhost:${port}'
  }

  tomcat::instance { $title :
    ajp_port     => $port,
    jolokia_port => $jolokia_port,
  }

  tomcat::deployment { 'deploy the gis ${title}' :
    tomcat   => 'gis',
    group    => 'uk.org.nbn',
    artifact => 'nbnv-gis',
    war      => $war,
  }
}