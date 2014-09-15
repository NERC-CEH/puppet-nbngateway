# == Class: nbngateway::solr_index
#
# This is the solr_index class. It will perform a solr data import when the solr
# server service has been restarted.
#
# === Parameters
#
# [*solr_port*] The http port which the solr server will be running on
# [*solr_war*]  The location of the solr deploy locally
# [*command*]   The solr data import command to run
# [*clean*]     If the solr index should be cleaned
# [*commit*]    If the solr index should be committed
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::solr_index(
  $solr_port = 7000,
  $solr_war  = undef,
  $command   = 'full-import',
  $clean     = 'true',
  $commit    = 'true'

) {
  $solr_dataimport = "http://localhost:${solr_port}/solr/dataimport"

  tomcat::instance { 'solr' :
    http_port => $solr_port,
  }

  tomcat::deployment { 'deploy the solr server' :
    tomcat      => 'solr',
    group       => 'uk.org.nbn',
    artifact    => 'nbnv-api-solr',
    application => 'solr',
    war         => $solr_war,
  }

  exec { 'Index solr' :
    command     => "curl '${solr_dataimport}?command=${command}&clean=${clean}&commit=${commit}'",
    path        => '/usr/bin',
    refreshonly => true,
    subscribe   => Service['tomcat7-solr'],
  }
}