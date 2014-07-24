# == Class: nbngateway::static
#
# This is the static class, it will populate the nbn-www directory with small
# static content that the NBN Gateway requires for hosting but hasn't been stored
# in version control before
#
# === Authors
#
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class nbngateway::static {
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