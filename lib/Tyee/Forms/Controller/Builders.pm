package Tyee::Forms::Controller::Builders;
use Moose;
use namespace::autoclean;
use Date::Parse;
use DateTime;
use Data::Dumper;
use Tyee::Forms::BuilderSurvey;

BEGIN { extends 'Catalyst::Controller'; }

has 'form' => (
    isa     => 'Tyee::Forms::BuilderSurvey',
    is      => 'rw',
    lazy    => 1,
    default => sub { Tyee::Forms::BuilderSurvey->new }
);

=head1 NAME

Tyee::Forms::Controller::Builders - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Chained('/') PathPart('builders') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $dt = DateTime->from_epoch(
        epoch => str2time( $c->req->params->{'trnDate'} ) );
    my ( $fname, $lname )
        = split( ' ', $c->req->params->{'trnCustomerName'} );
    $c->stash(
        params => {
            trnid           => $c->req->params->{'trnId'},
            trnamount       => $c->req->params->{'trnAmount'},
            #trndate         => $c->req->params->{'trnDate'},
            name            => $c->req->params->{'trnCustomerName'},
            trnemailaddress => $c->req->params->{'trnEmailAddress'},
            trnphonenumber  => $c->req->params->{'trnPhoneNumber'},
            authcode        => $c->req->params->{'authCode'},
            name_first      => $fname,
            name_last       => $lname,
            messagetext     => $c->req->params->{'messageText'},
            trndate         => $dt,
        }
    );

}

sub add_to_db : Chained('index') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $subscriber = $c->model( 'SubscriberDB::Subscriber' )
        ->find_or_create( $c->stash->{'params'} );
    $c->stash( subscriber => $subscriber );
}

sub add_to_wc : Chained('add_to_db') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $subscriber = $c->stash->{'subscriber'};
    my ( $sub_info, $whatcounts )
        = $c->model( 'WhatCounts' )->create_or_update(
        {   subscriber => $subscriber,
            list_id    => $c->config->{'whatcounts_list_id'},
            realm_name => $c->config->{'whatcounts_realm_name'},
            pw         => $c->config->{'whatcounts_pw'},
        }
        );
    my ( $subscriber_id ) = ( $sub_info->{'content'} =~ m/^(\d+)/ );
    if ( $whatcounts->{'content'} =~ /success/i ) {
        # If the API call is successful, update the subscriber record in our database
        $subscriber->whatcounts( '1' );
        $subscriber->whatcounts_msg( $whatcounts->{'content'} );
        $subscriber->whatcounts_sub_id( $subscriber_id );
        $subscriber->update;
    }
}

sub approved : Chained('add_to_wc') : PathPart('approved') : Args(0) {
    my ( $self, $c ) = @_;
    my $form = $self->form;
    $c->stash(
        form  => $form,
        title => 'Your transaction was successful',
    );

    # Validate and insert/update database
    $form->process(
        item_id => $c->stash->{'params'}->{'trnid'},
        params  => $c->req->parameters,
        schema  => $c->model( 'SubscriberDB' )->schema
    );
    return unless $form->validated;

    if ( $form->validated && $c->req->method eq 'POST' ) {
        # Form validated, update WhatCounts
        my ( $whatcounts, $params ) = $c->model( 'WhatCounts' )->update(
            {   subscriber => $c->model( 'SubscriberDB::Subscriber' )->find( $c->stash->{'params'}->{'trnid'} ),
                list_id    => $c->config->{'whatcounts_list_id'},
                realm_name => $c->config->{'whatcounts_realm_name'},
                pw         => $c->config->{'whatcounts_pw'},
            }
        );
        #$c->stash->{'status_msg'} = 'Your preferences have been saved.';
        $c->forward('thankyou');
    }
}

sub thankyou : Local : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        template => 'builders/thankyou.tt',

    );
}


sub declined : Local : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        trn_id     => $c->req->params->{'trnId'},
        message    => $c->req->params->{'messageText'},
        cust_name  => $c->req->params->{'trnCustomerName'},
        trn_amt    => $c->req->params->{'trnAmount'},
        cust_email => $c->req->params->{'trnEmailAddress'},
        cust_phone => $c->req->params->{'trnPhoneNumber'},
        title      => 'Your transaction was not successful',
    );
}

=head1 AUTHOR

api@thetyee.ca

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
