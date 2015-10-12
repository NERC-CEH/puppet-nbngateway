# == Class: nbngateway::webserver::static
#
# This is the static class, it will populate the nbn-www directory with small
# static content that the NBN Gateway requires for hosting but hasn't been stored
# in version control before
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::webserver::static {
   file { '/opt/nbn-www' :
      ensure  => directory,
   }

   file {'/opt/nbn-www/images' :
     ensure  => directory,
   }

   file {'/opt/nbn-www/images/NBNPower.gif' :
     ensure => file,
     source => 'puppet:///modules/nbngateway/NBNPower.gif',
   }
   
   file {'/var/www/default' :
     ensure => directory
   }  
   
   file {'/var/www/default/index.html' :
     ensure => file,
     source => 'puppet:///modules/nbngateway/default_index.html'
   }   
}