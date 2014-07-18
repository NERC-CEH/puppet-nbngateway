class nbngateway::redirects {
  Apache::Vhost {
    docroot       => '/var/www',
    default_vhost => true,
    port          => 80,
  }

  apache::vhost { 'http_data.nbn.org.uk' :
    servername    => $nbngateway::data_servername,
    rewrites   => [{
      rewrite_cond  => '%{HTTPS} off',
      rewrite_rule  => '(.*) https://%{HTTP_HOST}%{REQUEST_URI}',
    }]
  }

  apache::vhost { 'http_gis.nbn.org.uk' :
    servername    => $nbngateway::gis_servername,
    rewrites   => [{
      rewrite_cond  => '%{HTTPS} off',
      rewrite_rule  => '(.*) https://%{HTTP_HOST}%{REQUEST_URI}',
    }]
  }

  apache::vhost { 'http_www.searchnbn.net' :
    servername => 'www.searchnbn.net',
    rewrites   => [{
      comment      => 'Redirect from root of this application to data.nbn.org.uk',
      rewrite_rule => ["^(.*) https://${nbngateway::data_servername}$1"],
    }]
  }
}