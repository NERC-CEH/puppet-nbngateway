class nbngateway::webapps (
  $environment = $nbngateway::environment,
  $use_nexus   = $nbngateway::use_nexus
) {
  if $use_nexus {
    Tomcat::Deployment {
      group => 'uk.org.nbn',
    }

    tomcat::deployment { 'deploy the portal webapp' :
      tomcat   => 'data',
      artifact => 'nbnv-portal',
    }

    tomcat::deployment { 'deploy the imt webapp' :
      tomcat      => 'data',
      artifact    => 'nbnv-imt',
      application => 'imt',
    }

    tomcat::deployment { 'deploy the documentation webapp' :
      tomcat      => 'data',
      artifact    => 'nbnv-documentation',
      application => 'Documentation',
    }

    tomcat::deployment { 'deploy the api' :
      tomcat      => 'api',
      artifact    => 'nbnv-api',
      application => 'api',
    }

    tomcat::deployment { 'deploy the solr server' :
      tomcat      => 'solr',
      artifact    => 'nbnv-api-solr',
      application => 'solr',
    }

    tomcat::deployment { 'deploy the gis webapp' :
      tomcat   => 'gis',
      artifact => 'nbnv-gis',
    }

#    tomcat::deployment {
#      tomcat      => 'importer',
#      artifact    => 'nbnv-importer-ui',
#      application => 'importer',
#    }
#
#    tomcat::deployment {
#      tomcat      => 'importer',
#      artifact    => 'nbnv-importer-spatial-ui',
#      application => 'spatial-importer',
#    }
  }
  else {
    tomcat::deployment { 'deploy the portal webapp' :
      tomcat => 'data',
      war    => '/vagrant/wars/portal.war',
    }

    tomcat::deployment { 'deploy the documentation webapp' :
      tomcat      => 'data',
      war         => '/vagrant/wars/docs.war',
      application => 'Documentation',
    }

    tomcat::deployment { 'deploy the api' :
      tomcat      => 'api',
      war         => '/vagrant/wars/api.war',
      application => 'api',
    }

    tomcat::deployment { 'deploy the solr server' :
      tomcat      => 'solr',
      war         => '/vagrant/wars/solr.war',
      application => 'solr',
    }

    tomcat::deployment { 'deploy the gis webapp' :
      tomcat => 'gis',
      war    => '/vagrant/wars/gis.war',
    }

#      tomcat::deployment {
#        tomcat      => 'importer',
#        war         => '/vagrant/wars/importer.war',
#        application => 'importer',
#      }
#
#      tomcat::deployment {
#        tomcat      => 'importer',
#        war         => '/vagrant/wars/spatial-importer.war',
#        application => 'spatial-importer',
#      }


  }
}