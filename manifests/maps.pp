class nbngateway::maps (
  $warehouse_db_server = $nbngateway::warehouse_db_server,
  $vector_shapefiles   = $nbngateway::vector_shapefiles,
  $os_modern           = $nbngateway::os_modern,
  $os_tiled            = $nbngateway::os_tiled
) {
  include freetds
  include mapserver

  freetds::db { 'nbnwarehouse' :
    host => $warehouse_db_server,
  }

  ## Create a directory for the maps to live in
  file { '/var/nbn' :
    ensure => directory,
  }
  
  file { '/var/nbn/taxonCache' :
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
    ensure => directory,
  }

  file { '/var/nbn/contextCache' :
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
    ensure => directory,
  }

  file { '/var/nbn/maps' :
    ensure => directory,
  }

  file { '/var/nbn/maps/OS' :
    ensure => directory,
  }

  file { '/var/nbn/maps/Vector' :
    ensure  => link,
    target  => $vector_shapefiles,
  }

  file { '/var/nbn/maps/OS/Modern' :
    ensure  => link,
    target  => $os_modern,
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
    target  => $os_tiled,
  }

  file { '/var/nbn/maps/Tiled/missing.png' :
    source => 'puppet:///modules/nbngateway/missing.png',
  }
}