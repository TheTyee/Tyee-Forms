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
    my $dt    = DateTime->from_epoch( epoch => str2time( $c->req->params->{'trnDate'} ) );
    my ( $fname, $lname ) = split( ' ', $c->req->params->{'trnCustomerName'} );
    $c->stash(
        params => {
            trnid           => $c->req->params->{'trnId'},
            trnamount       => $c->req->params->{'trnAmount'},
            trndate            => $c->req->params->{'trnDate'},
            name       => $c->req->params->{'trnCustomerName'},
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
    my $subscriber = $c->model( 'SubscriberDB::Subscriber' )->find_or_create(
        $c->stash->{'params'}
    );
    $c->stash( subscriber => $subscriber );
}

sub add_to_wc : Chained('add_to_db') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $subscriber = $c->stash->{'subscriber'};
    my ( $sub_info, $whatcounts )
        = $c->model( 'WhatCounts' )->create_or_update(
        {   builder_amt  => $c->stash->{'trnamount'},
            builder_id   => $c->stash->{'trnid'},
            builder_date => $c->stash->{'trndate'},
            email        => $c->stash->{'trnemailaddress'},
            list_id      => $c->config->{'whatcounts_list_id'},
            realm_name   => $c->config->{'whatcounts_realm_name'},
            pw           => $c->config->{'whatcounts_pw'},
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
    $c->stash( form => $form );

    # Validate and insert/update database
    $form->process(
        item_id => $c->stash->{'params'}->{'trnid'},
        params  => $c->req->parameters,
        schema  => $c->model( 'SubscriberDB' )->schema
    );
    return unless $form->validated;
    if ( $c->req->method eq 'POST' ) {
        # Form validated, return to the books list
        $c->stash->{status_msg}
            = 'Your preferences have been saved.';
    }
}


sub declined : Local : Args(0) {
    my ( $self, $c ) = @_;
    my $id    = $c->req->params->{'trnId'};
    my $amt   = $c->req->params->{'trnAmount'};
    my $name  = $c->req->params->{'trnCustomerName'};
    my $email = $c->req->params->{'trnEmailAddress'};
    my $phone = $c->req->params->{'trnPhoneNumber'};
    my $msg   = $c->req->params->{'messageText'};
    $c->stash(
        trn_id     => $id,
        message    => $msg,
        cust_name  => $name,
        trn_amt    => $amt,
        cust_email => $email,
        cust_phone => $phone,
        title      => 'Your transaction was not successful',
    );
}

=head1 AUTHOR

api@thetyee.ca

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# trnApproved=1
# trnId=10000002
# messageId=1
# messageText=Approved
# authCode=TEST
# responseType=T
# trnAmount=10.00
# trnDate=2%2F27%2F2012+11%3A43%3A01+AM
# trnOrderNumber=10000002
# trnLanguage=eng
# trnCustomerName=Phillip+Smith
# trnEmailAddress=ps%40phillipadsmith.com
# trnPhoneNumber=647+361+8248
# avsProcessed=1
# avsId=N
# avsResult=0
# avsAddrMatch=0
# avsPostalMatch=0
# avsMessage=Street+address+and+Postal%2FZIP+do+not+match.
# cvdId=1&cardType=MC
# trnType=P
# paymentMethod=CC
# ref1=&ref2=&ref3=&ref4=&ref5=

__PACKAGE__->meta->make_immutable;

1;
