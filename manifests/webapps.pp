class nbngateway::webapps (
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
    group       => 'uk.gov.nbn.data'
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