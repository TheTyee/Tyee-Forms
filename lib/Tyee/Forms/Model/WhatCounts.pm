package Tyee::Forms::Model::WhatCounts;
use Moose;
use namespace::autoclean;
use HTTP::Tiny;

extends 'Catalyst::Model';


my $http   = HTTP::Tiny->new();
my $API    = 'http://premiere.whatcounts.com/bin/api_web?';

sub create_or_update {
    my ( $self, $sub ) = @_;
    my %args = (
        r => $sub->{'realm_name'},
        p => $sub->{'pw'},
    );
    my $list_id  = $sub->{'list_id'};
    my $email = $sub->{'email'};
    my $level = $sub->{'builder_amt'};
    my $number = $sub->{'builder_id'};
    my $date   = $sub->{'builder_date'};
    my $search = {
        %args,
        cmd   => 'find',
        email => $email,
    };
    my $search_params = $http->www_form_urlencode( $search );
    my $subscribed = $http->get( $API . $search_params );
        my $get   = {
        %args,
        cmd                     => $subscribed->{'content'} ? 'update' : 'sub',
        list_id                 => $sub->{'list_id'},
        email                   => $sub->{'email'},
        custom_builder_level    => $sub->{'builder_amt'},
        custom_builder_number   => $sub->{'builder_id'},
        custom_builder_sub_date => $sub->{'builder_date'},
        data =>
            "email,custom_builder_level,custom_builder_number,custom_builder_sub_date^$email,$level,$number,$date"
    };
    my $params = $http->www_form_urlencode( $get );
    my $response
        = $http->get( "http://premiere.whatcounts.com/bin/api_web?$params" );
    return ( $subscribed, $response );
}

=head1 NAME

Tyee::Forms::Model::WhatCounts - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

api@thetyee.ca

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
