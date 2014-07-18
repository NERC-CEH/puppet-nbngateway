class nbngateway::settings (
  $warehouse_db_server  = $nbngateway::warehouse_db_server,
  $master_db_sever      = $nbngateway::master_db_sever,
  $warehouse_db         = $nbngateway::warehouse_db,
  $core_db              = $nbngateway::core_db,
  $api_db_user          = $nbngateway::api_db_user,
  $importer_db_user     = $nbngateway::importer_db_user,
  $gis_db_username      = $nbngateway::gis_db_username,
  $api_db_password      = $nbngateway::api_db_password,
  $importer_db_password = $nbngateway::importer_db_password,
  $gis_db_password      = $nbngateway::gis_db_password
) {
  $portal_location = "https://${nbngateway::data_servername}"
  $gis_location = "https://${nbngateway::gis_servername}"
  $api_location = "${portal_location}/api"

  $db_warehouse_url = "jdbc:sqlserver://${warehouse_db_server};databaseName=${warehouse_db}"
  $db_core_url = "jdbc:sqlserver://${master_db_sever};databaseName=${core_db}"
  
  File {
    owner  => $::tomcat::user,
    group  => $::tomcat::group,
  }

  file { '/nbnv-settings' :
    mode   => 0700,
    ensure => directory,
    before => Service['tomcat7-gis', 'tomcat7-data', 'tomcat7-api'],
  }

  file { '/nbnv-settings/api.properties':
    mode    => 0600,
    content => template('nbngateway/api.properties.erb'),
    notify  => Service['tomcat7-api'],
  }

  file { '/nbnv-settings/gis.properties':
    mode    => 0600,
    content => template('nbngateway/gis.properties.erb'),
    notify  => Service['tomcat7-gis'],
  }

  file { '/nbnv-settings/portal.properties':
    mode    => 0600,
    content => template('nbngateway/portal.properties.erb'),
    notify  => Service['tomcat7-data'],
  }

  file { '/nbnv-settings/settings.properties':
    mode    => 0600,
    content => template('nbngateway/settings.properties.erb'),
  }
}