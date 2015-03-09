# == Class: nbngateway::logarchive
#
# This is the logarchive class. It deploys the log archive script to the node
# and configures a cron job to run it.
#
# === Parameters
# [*directory*] The directory where the log archives should be stored
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::logarchive (
  $directory = '/var/log/nbn'
) {
  file { '/etc/cron.weekly/nbn-logarchive' :
    mode    => 0755,
    ensure  => file,
    content => template('nbngateway/logarchive.sh.erb'),
  }

  logrotate::rule { 'tomcat':
    path          => '/home/tomcat7/*/logs/catalina.out',
    copytruncate  => true,
    missingok     => true,
    rotate_every  => 'day',
  }
}
