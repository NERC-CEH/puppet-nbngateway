# == Class: nbn_web
#
# This is the nbn_web profile
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway (
  $api_db_password,
  $importer_db_password,
  $gis_db_password,
  $ssl_cert,
  $ssl_key,
  $ssl_chain,
  $vector_shapefiles,
  $os_modern,
  $os_tiled,
  $ssl_root            = '/etc/ssl/certs/GlobalSign_Root_CA.pem',
  $master_db_sever     = 'nbn-master.nerc-lancaster.ac.uk',
  $api_db_user         = 'NBNTestAPI',
  $importer_db_user    = 'NBNImporter',
  $gis_db_username     = 'NBNGIS',
  $environment         = 'development',
  $use_nexus           = false
) {
  $warehouse_db_server = $environment ? {
    'production' => 'nbnwarehouse.nerc-lancaster.ac.uk',
    default      => 'nbn-b.nerc-lancaster.ac.uk',
  }

  $warehouse_db = $environment ? {
    'production' => 'NBNWarehouseLive',
    default      => 'TestNBNWarehouse',
  }

  $core_db = $environment ? {
    'production' => 'NBNCoreLive',
    default      => 'TestNBNCore',
  }

  $gis_servername = $environment ? {
    'development' => 'developer-gis.nbn.org.uk',
    'staging'     => 'staging-gis.nbn.org.uk',
    'production'  => 'gis.nbn.org.uk',
  }
  
  $data_servername = $environment ? {
    'development' => 'developer-data.nbn.org.uk',
    'staging'     => 'staging-data.nbn.org.uk',
    'production'  => 'data.nbn.org.uk',
  }

  include nbngateway::webserver
  include nbngateway::webapps
  include nbngateway::redirects
  include nbngateway::static
  include nbngateway::maps
  include nbngateway::settings

  # The servernames should resolve to this box internally
  host { [$data_servername, $gis_servername] :
    ip => '127.0.0.1',
  }
}