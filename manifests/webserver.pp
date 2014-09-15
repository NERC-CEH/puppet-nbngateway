# == Class: nbngateway::webserver
#
# This is the webserver class, it will set up apache web server vhosts, one for each
# of the domain names which resolve to this web server and proxy various tomcat
# instances.
#
# === Parameters
#
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::webserver {
  include tomcat  
  include apache
  include apache::mod::ssl
  include apache::mod::proxy_ajp

  apache::balancer { 'data': }
  apache::balancer { 'api': }
  apache::balancer { 'gis': }

  # Create single instances of the various load balanced sections of the 
  # webserver
  nbngateway::webserver::api { 'api' :}
  nbngateway::webserver::data { 'data' :}
  nbngateway::webserver::gis { 'gis' :}

  Apache::Vhost {
    port      => '443',
    ssl       => true,
    ssl_cert  => '/etc/ssl/nbn.crt',
    ssl_key   => '/etc/ssl/private/nbn.key',
    ssl_chain => $nbngateway::ssl_chain,
    ssl_ca    => $nbngateway::ssl_ca,
    docroot   => '/opt/nbn-www',
  }

  # Replace the . in the servername of the data with \. So that we can use it as a 
  # regular expression
  $data_servername_regex = regsubst($nbngateway::data_servername, '\.', '\.', 'G')

  apache::vhost { 'https_gis.nbn.org.uk' :
    docroot       => '/var/nbn/maps',
    servername    => $nbngateway::gis_servername,
    serveraliases => $nbngateway::gis_serveraliases,
    rewrites      => [
        {
          rewrite_cond => ["%{HTTP_REFERER} !^https://${data_servername_regex}/imt.*$ [NC]"],
          rewrite_rule => ['/Tiled/. - [F]'],
        },
        {
          comment      => 'Redirect missing tiles',
          rewrite_cond => ['%{DOCUMENT_ROOT}%{REQUEST_URI} !-f'],
          rewrite_rule => ['\.(png) /var/nbn/maps/Tiled/missing.png [NC,L]'],
        },
        {
          comment      => 'Redirect arcgis to old-gis.nbn.org.uk',
          rewrite_rule => ['/arcgis/(.*) http://old-gis\.nbn\.org\.uk/arcgis/$1'],
        }
    ],
    proxy_pass    => [
      {path => '/Tiled', url => '!'},
      {path => '/',      url => "balancer://gis/"}
    ],
  }

  apache::vhost { 'https_data.nbn.org.uk' :
    servername => $nbngateway::data_servername,
    proxy_pass => [
      {path => '/images/',           url => '!'},
      {path => '/api/',              url => "balancer://api/api/"},
      {path => '/',                  url => "balancer://data/"}
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