class nbngateway::webserver(
  $solr_port     = 7000,
  $data_port     = 7100,
  $api_port      = 7101,
  $gis_port      = 7102,
  $importer_port = 7103,
) {
  include tomcat  
  include apache
  include apache::mod::ssl
  include apache::mod::proxy_ajp

  tomcat::instance { 'solr' :
    http_port => $solr_port,
  }

  tomcat::instance { 'data' :
    ajp_port => $data_port,
  }

  tomcat::instance { 'api' :
    ajp_port => $api_port,
  }

  tomcat::instance { 'gis' :
    ajp_port => $gis_port,
  }

  tomcat::instance { 'importer' :
    ajp_port => $importer_port,
  }

  Apache::Vhost {
    port      => '443',
    ssl       => true,
    ssl_cert  => '/etc/ssl/nbn.crt',
    ssl_key   => '/etc/ssl/private/nbn.key',
    ssl_chain => $nbngateway::ssl_chain,
    ssl_ca    => $nbngateway::ssl_ca,
    docroot   => '/opt/nbn-www',
  }

  apache::vhost { 'https_gis.nbn.org.uk' :
    docroot    => '/maps',
    servername => $nbngateway::gis_servername,
    rewrites   => [
        {
          comment      => 'Redirect missing tiles',
          rewrite_cond => ['%{DOCUMENT_ROOT}%{REQUEST_URI} !-f'],
          rewrite_rule => ['\.(png) /maps/Tiled/missing.png [NC,L]'],
        },
        {
          comment      => 'Redirect arcgis to old-gis.nbn.org.uk',
          rewrite_rule => ['/arcgis/(.*) http://old-gis.nbn.org.uk/arcgis/$1'],
        },
    ],
    proxy_pass => [
      {path => '/Tiled', url => '!'},
      {path => '/',      url => "ajp://localhost:${$gis_port}/"}
    ],
  }

  apache::vhost { 'https_data.nbn.org.uk' :
    servername => $nbngateway::data_servername,
    proxy_pass => [
      {path => '/images/',           url => '!'},
      {path => '/api/',              url => "ajp://localhost:${api_port}/api/"},
      {path => '/importer/',         url => "ajp://localhost:${importer_port}/importer/"},
      {path => '/spatial-importer/', url => "ajp://localhost:${importer_port}/spatial-importer/"},
      {path => '/',                  url => "ajp://localhost:${data_port}/"}
    ],
  }

  ### Copy the SSL certificates into place ###
  file {'/etc/ssl/private/nbn.key' :
    source => $nbngateway::ssl_key,
    notify => Service['apache2'],
  }

  file {'/etc/ssl/nbn.crt' :
    source =>  $nbngateway::ssl_cert,
    notify => Service['apache2'],
  }

  # Notify the apache service if any of the certs have changed
  File <| path == $ssl_chain |>  ~> Service['apache2']
  File <| path == $ssl_ca |>     ~> Service['apache2']
}