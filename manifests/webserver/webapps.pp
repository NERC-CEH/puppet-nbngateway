# == Class: nbngateway::webserver::webapps
#
# This is the webapps class, if defines all of the web applications which 
# should be deployed into tomcat servlet containers on the nbn web server.
#
# By default, webapps are obtained from your configured nexus server. If you 
# wish to deploy a war file which has not been pushed to a nexus server, you 
# can specify locations to files on disk.
#
# === Parameters
#
# [*portal_war*]            The location of the portal war file to deploy
# [*imt_war*]               The location of the imt war file to deploy
# [*recordcleaner_war*]     The location of the recordcleaner deploy locally
# [*documentation_war*]     The location of the documentation deploy locally
# [*api_war*]               The location of the api deploy locally
# [*solr_war*]              The location of the solr deploy locally
# [*gis_war*]               The location of the gis deploy locally
# [*importer_war*]          The location of the importer deploy locally
# [*spatial_importer_war*]  The location of the spatial importer deploy locally
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::webserver::webapps (
  $portal_war           = undef,
  $imt_war              = undef,
  $recordcleaner_war    = undef,
  $documentation_war    = undef,
  $api_war              = undef,
  $solr_war             = undef,
  $gis_war              = undef,
  $importer_war         = undef,
  $spatial_importer_war = undef
) {
  Tomcat::Deployment {
    group => 'uk.org.nbn',
  }

  tomcat::deployment { 'deploy the portal webapp' :
    tomcat   => 'data',
    artifact => 'nbnv-portal',
    war      => $portal_war,
  }

  tomcat::deployment { 'deploy the imt webapp' :
    tomcat      => 'data',
    artifact    => 'nbnv-imt',
    application => 'imt',
    war         => $imt_war,
  }

  tomcat::deployment { 'deploy the record cleaner webapp' :
    tomcat      => 'data',
    group       => 'uk.gov.nbn.data',
    artifact    => 'nbnv-recordcleaner',
    application => 'recordcleaner',
    war         => $recordcleaner_war,
  }

  tomcat::deployment { 'deploy the documentation webapp' :
    tomcat      => 'data',
    artifact    => 'nbnv-documentation',
    application => 'Documentation',
    war         => $documentation_war,
  }

  tomcat::deployment { 'deploy the api' :
    tomcat      => 'api',
    artifact    => 'nbnv-api',
    application => 'api',
    war         => $api_war,
  }

  tomcat::deployment { 'deploy the solr server' :
    tomcat      => 'solr',
    artifact    => 'nbnv-api-solr',
    application => 'solr',
    war         => $solr_war,
  }

  tomcat::deployment { 'deploy the gis webapp' :
    tomcat   => 'gis',
    artifact => 'nbnv-gis',
    war      => $gis_war,
  }

  tomcat::deployment {
    tomcat      => 'importer',
    artifact    => 'nbnv-importer-ui',
    application => 'importer',
    war         => $importer_war,
  }

  tomcat::deployment {
    tomcat      => 'importer',
    artifact    => 'nbnv-importer-spatial-ui',
    application => 'spatial-importer',
    war         => $spatial_importer_war,
  }
}