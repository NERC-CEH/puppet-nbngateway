class nbngateway::maps (
  $warehouse_db_server = $nbngateway::warehouse_db_server,
  $vector_shapefiles   = $nbngateway::vector_shapefiles
) {
  include freetds
  include mapserver

  ## Create a directory for the maps to live in
  File {
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
  }

  file { '/maps' :
    ensure => directory,
  }

  file { '/maps/taxonCache' :
    ensure => directory,
  }

  file { '/maps/contextCache' :
    ensure => directory,
  }

  file { '/maps/Vector' :
    recurse => true,
    ensure  => directory,
    source  => $vector_shapefiles,
  }

  # Start managing the Pre-tiled OS data
  file { '/maps/Tiled' :
    ensure => directory,
  }

  file { '/maps/Tiled/missing.png' :
    source => 'puppet:///modules/nbngateway/missing.png',
  }

  freetds::db { 'nbnwarehouse' :
    host => $warehouse_db_server,
  }
}