#!/usr/bin/perl 
#===============================================================================
#
#         FILE: set_up_versioned_db.pl
#
#        USAGE: ./set_up_versioned_db.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 14/03/2012 12:55:42
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Config::JFDI;
use Data::Dumper;
use Subscriber::Schema;

my $config = Config::JFDI->new(name => "Tyee::Forms", path => "$FindBin::Bin/../");
my $config_hash = $config->get;
my $args = $config_hash->{'Model::SubscriberDB'}->{'connect_info'};

my $schema = Subscriber::Schema->connect( $args->[0], $args->[1], $args->[2] );
my $dh = DBIx::Class::DeploymentHandler->new({ 
        schema => $schema,
        force_overwrite     => 1,
});
 
$dh->prepare_version_storage_install;
$dh->install_version_storage;

$dh->add_database_version({ version => $schema->schema_version });
