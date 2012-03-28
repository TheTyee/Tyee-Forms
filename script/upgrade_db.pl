#!/usr/bin/env perl
use strict;
use warnings;
use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use FindBin;
use lib "$FindBin::Bin/../lib";
use Config::JFDI;
use Data::Dumper;
use Subscriber::Schema;

my $config = Config::JFDI->new(name => "Tyee::Forms", path => "$FindBin::Bin/../");
my $config_hash = $config->get;
my $args = $config_hash->{'Model::SubscriberDB'}->{'connect_info'};

my $schema = Subscriber::Schema->connect( $args->[0], $args->[1], $args->[2] );
 
my $dh = DH->new({
   schema              => $schema,
   script_directory    => "$FindBin::Bin/../dbicdh",
   databases           => 'MySQL',
   sql_translator_args => { add_drop_table => 0 },
   force_overwrite     => 1,

});
 
$dh->prepare_deploy;
$dh->prepare_upgrade({ from_version => 1, to_version => 2});
$dh->upgrade;
