# == Class: nbngateway::solr_index
#
# This is the solr_index class. It will perform a solr data import when the solr
# server service has been restarted.
#
# === Parameters
#
# [*solr_port*] The http port which the solr server will be running on
# [*command*]   The solr data import command to run
# [*clean*]     If the solr index should be cleaned
# [*commit*]    If the solr index should be committed
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::solr_index(
  $solr_port = $nbngateway::webserver::solr_port,
  $command   = 'full-import',
  $clean     = 'true',
  $commit    = 'true'
) {
  $solr_dataimport = "http://localhost:${solr_port}/solr/dataimport"

  exec { 'Index solr' :
    command     => "curl '${solr_dataimport}?command=${command}&clean=${clean}&commit=${commit}'",
    path        => '/usr/bin',
    refreshonly => true,
    subscribe   => Service['tomcat7-solr'],
  }
}