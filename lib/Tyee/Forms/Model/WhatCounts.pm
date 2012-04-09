package Tyee::Forms::Model::WhatCounts;
use Moose;
use namespace::autoclean;
use HTTP::Tiny;

extends 'Catalyst::Model';

my $http = HTTP::Tiny->new();
my $API  = 'http://premiere.whatcounts.com/bin/api_web?';

sub create_or_update {
    my ( $self, $sub ) = @_;
    my $subscriber = $sub->{'subscriber'};
    my $email      = $subscriber->trnemailaddress;
    my $level      = $subscriber->trnamount;
    my $number     = $subscriber->trnid;
    my $date       = $subscriber->trndate;
    my %args       = (
        r => $sub->{'realm_name'},
        p => $sub->{'pw'},
    );
    my $search = {
        %args,
        cmd   => 'find',
        email => $subscriber->trnemailaddress,
    };
    my $search_params = $http->www_form_urlencode( $search );

    # Get the subscriber record
    my $subscribed = $http->get( $API . $search_params );
    my $get        = {
        %args,

        # If we found a subscriber, it's an update, if not a subscribe
        cmd => $subscribed->{'content'} ? 'update' : 'sub',
        list_id => $sub->{'list_id'},

        data =>
            "email,custom_builder_level,custom_builder_number,custom_builder_sub_date^$email,$level,$number,$date"
    };
    my $params = $http->www_form_urlencode( $get );
    my $response
        = $http->get( "http://premiere.whatcounts.com/bin/api_web?$params" );

# For some reason, WhatCounts doesn't return the subscriber ID on creation, so we search again.
    unless ( $subscribed->{'content'} ) {
        $subscribed = $http->get( $API . $search_params );
    }
    return ( $subscribed, $response );
}

sub update {
    my ( $self, $sub ) = @_;
    my $subscriber = $sub->{'subscriber'};
    # TODO Make this a hash with the field name as the key
    my $email      = $subscriber->trnemailaddress;
    my $accountgov = $subscriber->newspref_accountgov;
    my $arts_comm  = $subscriber->newspref_arts_comm;
    my $crime_just = $subscriber->newspref_crime_just;
    my $economy    = $subscriber->newspref_economy;
    my $education  = $subscriber->newspref_education;
    my $energy     = $subscriber->newspref_energy;
    my $enviro     = $subscriber->newspref_enviro;
    my $health     = $subscriber->newspref_health;
    my $housing    = $subscriber->newspref_housing;
    my $poverty    = $subscriber->newspref_poverty;
    my $rights     = $subscriber->newspref_rights_just;
    my $fiction    = $subscriber->pref_fiction;
    my $daily      = $subscriber->pref_enews_daily;
    my $weekly     = $subscriber->pref_enews_weekly;
    my $sponsor    = $subscriber->pref_sponsor_enews;
    my $anon       = $subscriber->builder_is_anonymous;
    my $future     = $subscriber->pref_future_enews;
    my %args       = (
        r => $sub->{'realm_name'},
        p => $sub->{'pw'},
    );
    # TODO Improve the data part of the post to only pass fields that we have values for
    my $get = {
        %args,
        cmd     => 'update',
        list_id => $sub->{'list_id'},
        data =>
            "email,custom_newspref_accountgov,custom_newspref_arts_comm,custom_newspref_crime_just,custom_newspref_economy,custom_newspref_education,custom_newspref_energy,custom_newspref_enviro,custom_newspref_health,custom_newspref_housing,custom_newspref_poverty,custom_newspref_rights_just,custom_pref_fiction,custom_pref_enews_daily,custom_pref_enews_weekly,custom_pref_sponsor_enews,custom_builder_is_anonymous,custom_pref_future_enews^$email,$accountgov,$arts_comm,$crime_just,$economy,$education,$energy,$enviro,$health,$housing,$poverty,$rights,$fiction,$daily,$weekly,$sponsor,$anon,$future"
    };
    my $params = $http->www_form_urlencode( $get );
    my $response
        = $http->get( "http://premiere.whatcounts.com/bin/api_web?$params" );
    return ( $response );
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
