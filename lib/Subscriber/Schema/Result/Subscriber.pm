use utf8;
package Subscriber::Schema::Result::Subscriber;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Subscriber::Schema::Result::Subscriber

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<subscriber>

=cut

__PACKAGE__->table("subscriber");

=head1 ACCESSORS

=head2 trnid

  data_type: 'integer'
  is_nullable: 0

=head2 trndate

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 trnordernumber

  data_type: 'integer'
  is_nullable: 1

=head2 trnamount

  data_type: 'float'
  is_nullable: 0

=head2 trnemailaddress

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 trnphonenumber

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 authcode

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 messagetext

  data_type: 'varchar'
  is_nullable: 0
  size: 2056

=head2 name_first

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 name_last

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 datetime

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 postal

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 comment

  data_type: 'bit'
  is_nullable: 1
  size: 1

=head2 whatcounts

  data_type: 'bit'
  is_nullable: 1
  size: 1

=head2 whatcounts_msg

  data_type: 'varchar'
  is_nullable: 1
  size: 2056

=cut

__PACKAGE__->add_columns(
  "trnid",
  { data_type => "integer", is_nullable => 0 },
  "trndate",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "trnordernumber",
  { data_type => "integer", is_nullable => 1 },
  "trnamount",
  { data_type => "float", is_nullable => 0 },
  "trnemailaddress",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "trnphonenumber",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "authcode",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "messagetext",
  { data_type => "varchar", is_nullable => 0, size => 2056 },
  "name_first",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "name_last",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "datetime",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "postal",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "comment",
  { data_type => "bit", is_nullable => 1, size => 1 },
  "whatcounts",
  { data_type => "bit", is_nullable => 1, size => 1 },
  "whatcounts_msg",
  { data_type => "varchar", is_nullable => 1, size => 2056 },
);

=head1 PRIMARY KEY

=over 4

=item * L</trnid>

=back

=cut

__PACKAGE__->set_primary_key("trnid");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-03-12 16:25:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mo9VfPoy8iZ9Cl7rc/U22w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
