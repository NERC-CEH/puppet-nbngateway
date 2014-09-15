# == Define: nbngateway::webserver::api
#
# This is the api resource type. It will create a new balancermember for the 
# api balancer (see webserver.pp). The member will back onto a managed tomcat
# which is running the api war
#
# === Parameters
#
# [*port*]         The ajp port which the api tomcat will be running on
# [*jolokia_port*] The jolokia port to use for monitoring the api tomcat
# [*war*]          The location of the api deploy locally
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define nbngateway::webserver::api (
  $port         = 7101,
  $jolokia_port = 9011,
  $war          = $nbngateway::api_war
) {
  apache::balancermember { $title :
    balancer_cluster => 'api',
    url              => "ajp://localhost:${port}",
  }

  tomcat::instance { $title :
    ajp_port     => $port,
    jolokia_port => $jolokia_port,
  }

  tomcat::deployment { "deploy the api ${title}" :
    tomcat      => $title,
    group       => 'uk.org.nbn',
    artifact    => 'nbnv-api',
    application => 'api',
    war         => $api_war,
  }
}