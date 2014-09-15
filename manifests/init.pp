# == Class: nbngateway
#
# This is the nbngateway web server module. Define this class and supply it with 
# passwords, ssl certs, and maps. You will then get an operating environment for
# the nbn gateway web applications.
#
# === Parameters
#
# [*ssl_cert*]              file location of the ssl certificate
# [*ssl_key*]               file location of the ssl key certificate
# [*ssl_chain*]             file location of the chain ssl certificate
# [*ssl_root*]              file location of the root ssl certificate
#
# [*vector_shapefiles*]     file location of the vector shapefiles
# [*os_modern*]             file location of the os modern backdrops
# [*os_tiled*]              file location of the pregenerated os tiles
#
# [*api_db_password*]       of the api user for use with the api application
# [*importer_db_password*]  of the importer user for use with the importer application
# [*gis_db_password*]       of the gis user for use with the gis application
# [*api_db_user*]           username of the api user
# [*importer_db_user*]      importer of the api user
# [*gis_db_username*]       gis of the api user
# [*authenticator_key*]     Base64 encoded authenticate key. If not supplied, 
#   the api web app will generate this.
# [*credentials_reset_key*] Base64 encoded credentials reset key. Used when 
#   reseting passwords. If not supplied the api web app will generate this.
# [*master_db_sever*]       the servername of the database to use as the master
# [*environment*]           either developer, staging or production
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway (
  $ssl_cert,
  $ssl_key,
  $ssl_chain,
  $ssl_root,
  $vector_shapefiles,
  $os_modern,
  $os_tiled,
  $api_db_password,
  $importer_db_password,
  $gis_db_password,
  $api_db_user           = 'NBNTestAPI',
  $importer_db_user      = 'NBNImporter',
  $gis_db_username       = 'NBNGIS',
  $authenticator_key     = undef,
  $credentials_reset_key = undef,
  $master_db_sever       = 'nbn-master.nerc-lancaster.ac.uk',
  $environment           = 'development'
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
    'production' => 'NBNCore',
    default      => 'TestNBNCore',
  }

  $gis_servername = $environment ? {
    'development' => 'developer-gis.nbn.org.uk',
    'staging'     => 'staging-gis.nbn.org.uk',
    'production'  => 'gis.nbn.org.uk',
  }

  $gis_serveraliases = $environment ? {
    'production' => ['gis1.nbn.org.uk', 'gis2.nbn.org.uk', 'gis3.nbn.org.uk', 'gis4.nbn.org.uk'],
    default      => [],
  }

  $data_servername = $environment ? {
    'development' => 'developer-data.nbn.org.uk',
    'staging'     => 'staging-data.nbn.org.uk',
    'production'  => 'data.nbn.org.uk',
  }

  $email_mode = $environment ? {
    'production' => 'live',
    default      => 'dev',
  }

  # The servernames should resolve to this box internally
  host { [$data_servername, $gis_servername] :
    ip => '127.0.0.1',
  }

  include nbngateway::maps
  include nbngateway::settings
  include nbngateway::webserver
  include nbngateway::webserver::importer
  include nbngateway::webserver::webapps
  include nbngateway::webserver::redirects
  include nbngateway::webserver::static
  include nbngateway::solr
}