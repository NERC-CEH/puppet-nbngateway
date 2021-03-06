# == Class: nbngateway::maps
#
# This is the maps class, it will:
#
# - set up an instance of mapserver
# - create directories for bread to bake in
# - link to OS tiled, Modern and vector files (defined in init.pp)
# - set up a freetds database connection to the warehouse_db_server
#
# The static missing.png image is also copied in place
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::maps {
  include tomcat
  include freetds
  include mapserver

  freetds::db { 'nbnwarehouse' :
    host => $nbngateway::warehouse_db_server,
  }

  ## Create a directory for the maps to live in
  file { '/var/nbn' :
    ensure => directory,
  }
  
  file { '/var/nbn/taxonCache' :
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
    ensure => directory,
    before => Service['tomcat7-gis'],
  }

  file { '/var/nbn/contextCache' :
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
    ensure => directory,
    before => Service['tomcat7-gis'],
  }

  file { '/var/nbn/maps' :
    ensure => directory,
  }

  file { '/var/nbn/maps/OS' :
    ensure => directory,
  }

  file { '/var/nbn/maps/Vector' :
    ensure  => link,
    target  => $nbngateway::vector_shapefiles,
  }

  file { '/var/nbn/maps/OS/Modern' :
    ensure  => link,
    target  => $nbngateway::os_modern,
  }

  # Start managing the Pre-tiled OS data
  file { '/var/nbn/maps/Tiled' :
    ensure => directory,
  }

  file { '/var/nbn/maps/Tiled/1.0.0' :
    ensure => directory,
  }

  file { '/var/nbn/maps/Tiled/1.0.0/OS' :
    ensure  => link,
    target  => $nbngateway::os_tiled,
  }

  file { '/var/nbn/maps/Tiled/missing.png' :
    source => 'puppet:///modules/nbngateway/missing.png',
  }
}