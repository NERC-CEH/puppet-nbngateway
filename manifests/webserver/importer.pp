# == Class: nbngateway::webserver::importer
#
# This is the importer class, it defines a tomcat for the importer and deploys
# the various importer related war files to it.
#
# === Parameters
#
# [*port*]                  The ajp port which the importer will be running on
# [*jolokia_port*]          The jolokia port to use for monitoring the importer
# [*importer_war*]          The location of the importer deploy locally
# [*spatial_importer_war*]  The location of the spatial importer deploy locally
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::webserver::importer (
  $port                 = 8080,
  $jolokia_port         = 9012,
  $importer_war         = undef,
  $spatial_importer_war = undef
) {
  tomcat::instance { 'importer' :
    http_port    => $port,    
    jolokia_port => $jolokia_port,
  }

  tomcat::deployment { 'deploy the importer webapp' :
    tomcat      => 'importer',
    artifact    => 'nbnv-importer-ui',
    application => 'importer',
    war         => $importer_war,
  }

  tomcat::deployment { 'deploy the spatial importer webapp' :
    tomcat      => 'importer',
    artifact    => 'nbnv-importer-spatial-ui',
    application => 'spatial-importer',
    war         => $spatial_importer_war,
  }
}