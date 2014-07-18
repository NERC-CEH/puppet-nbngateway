# Obtains the static content which is hosted from /var/www
class nbngateway::static () {
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
}