#!/usr/bin/env perl
#===============================================================================
#
#         FILE: install_db.pl
#
#        USAGE: ./install_db.pl  
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
#      CREATED: 14/03/2012 14:52:10
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
 
my $force_overwrite = 1;
 
unless ( GetOptions( 'force_overwrite!' => \$force_overwrite ) ) {
    die "Invalid options";
}


my $config = Config::JFDI->new(name => "Tyee::Forms", path => "$FindBin::Bin/../");
my $config_hash = $config->get;
my $args = $config_hash->{'Model::SubscriberDB'}->{'connect_info'};

my $schema = Subscriber::Schema->connect( $args->[0], $args->[1], $args->[2] );
 
my $dh = DH->new(
    {
        schema              => $schema,
        script_directory    => "$FindBin::Bin/../dbicdh",
        databases           => 'MySQL',
        sql_translator_args => { add_drop_table => 0 },
        force_overwrite     => $force_overwrite,
    }
);
 
$dh->prepare_install;

