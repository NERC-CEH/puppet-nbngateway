# == Define: nbngateway::webserver::data
#
# This is the api resource type. It will create a new balancermember for the 
# api balancer (see webserver.pp). The member will back onto a managed tomcat
# which is running the api war
#
# === Parameters
#
# [*port*]              The ajp port which the api tomcat will be running on
# [*jolokia_port*]      The jolokia port to use for monitoring the api tomcat
# [*portal_war*]        The location of the portal war file to deploy
# [*imt_war*]           The location of the imt war file to deploy
# [*recordcleaner_war*] The location of the recordcleaner deploy locally
# [*documentation_war*] The location of the documentation deploy locally
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define nbngateway::webserver::data (
  $port              = 7100,
  $jolokia_port      = 9010,
  $portal_war        = $nbngateway::portal_war,
  $imt_war           = $nbngateway::imt_war,
  $recordcleaner_war = $nbngateway::recordcleaner_war,
  $documentation_war = $nbngateway::documentation_war,
) {
  apache::balancermember { $title :
    balancer_cluster => 'data',
    url              => "ajp://localhost:${port}",
  }

  tomcat::instance { $title :
    ajp_port     => $port,
    jolokia_port => $jolokia_port,
  }

  Tomcat::Deployment {
    group => 'uk.org.nbn',
  }

  tomcat::deployment { "deploy the portal webapp ${title}" :
    tomcat   => 'data',
    artifact => 'nbnv-portal',
    war      => $portal_war,
  }

  tomcat::deployment { "deploy the imt webapp ${title}" :
    tomcat      => 'data',
    artifact    => 'nbnv-imt',
    application => 'imt',
    war         => $imt_war,
  }

  tomcat::deployment { "deploy the record cleaner webapp ${title}" :
    tomcat      => 'data',
    group       => 'uk.gov.nbn.data',
    artifact    => 'nbnv-recordcleaner',
    application => 'recordcleaner',
    war         => $recordcleaner_war,
  }

  tomcat::deployment { "deploy the documentation webapp ${title}" :
    tomcat      => 'data',
    artifact    => 'nbnv-documentation',
    application => 'Documentation',
    war         => $documentation_war,
  }
}