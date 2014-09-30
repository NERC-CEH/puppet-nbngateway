# == Class: nbngateway::webserver::recordcleaner
#
# This is the recordcleaner class. It will checkout the record cleaner from the
# public github repository and ensure that it is at the latest version of the
# specified branch
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::webserver::recordcleaner (
  $ensure   = 'latest',
  $revision = 'master',
  $repo     = 'https://github.com/JNCC-dev-team/nbn-recordcleaner.git'
) {
   vcsrepo { '/opt/nbn-www/recordcleaner' :
    ensure      => $ensure,
    provider    => git,
    source      => $repo,
    revision    => $revision,
    require     => File['/opt/nbn-www'],
  }
}