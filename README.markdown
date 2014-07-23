# NBN Gateway Web Server

This is the NBN Gateway WebServer puppet module. It sets up an nbn gateway web hosting environment.

## Module Description

This puppet module will obtain and manage all of the software which needs to be configured and installed
on a server inorder for it to host the NBN Gateway web content. This involves setting up things MapServer
and database connection properties files.

The module can be configured for various operating environments. E.g dev, staging and production

This module is designed specifically for contributors to the NBN Gateway code base

## Setup

### What Selendroid affects

* Installs apache
* Installs mapserver
* Sets up various tomcats for hosting the different segments of the nbn gateway


## Usage

Create a NBN Gateway web server

    class { 'nbngateway' :
      # Manage passwords for db connections
      api_db_password      => 'apiUserPa55word',
      importer_db_password => 'importerUserPa55word',
      gis_db_password      => 'gisUserPa55word',

      # Configure ssl certs
      ssl_cert             => '/etc/ssl/nbn.crt',
      ssl_key              => '/etc/ssl/nbn.key',
      ssl_chain            => '/etc/ssl/chain.pem',

      # Define location to static maps
      vector_shapefiles    => '/mnt/geo/vector',
      os_modern            => '/mnt/geo/os-modern',
      os_tiled             => '/mnt/geo/os-tiled',

      # Set the operation environment
      environment          => 'production'
    }

## Limitations

This module has been tested on ubuntu 14.04 lts

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk