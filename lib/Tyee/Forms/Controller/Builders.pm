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
    my $id    = $c->req->params->{'trnId'};
    my $amt   = $c->req->params->{'trnAmount'} // 'na';
    my $date  = $c->req->params->{'trnDate'} // 'na';
    my $name  = $c->req->params->{'trnCustomerName'} // 'na';
    my $email = $c->req->params->{'trnEmailAddress'} // 'na';
    my $phone = $c->req->params->{'trnPhoneNumber'} // 'na';
    my $auth  = $c->req->params->{'authCode'} // 'na';
    my $msg   = $c->req->params->{'messageText'} // 'na';
    my $epoch = str2time( $date );
    my $dt    = DateTime->from_epoch( epoch => $epoch );
    my ( $fname, $lname ) = split( ' ', $name );
    $c->stash(
        trnid           => $id,
        trnamount       => $amt,
        date            => $date,
        name_full       => $name,
        trnemailaddress => $email,
        trnphonenumber  => $phone,
        authcode        => $auth,
        name_first      => $fname,
        name_last       => $lname,
        messagetext     => $msg,
        trndate         => $dt,
    );

}

sub add_to_db : Chained('index') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $subscriber = $c->model( 'SubscriberDB::Subscriber' )->find_or_create(
        {   trnemailaddress => $c->stash->{'trnemailaddress'},
            trnphonenumber  => $c->stash->{'trnphonenumber'},
            trnordernumber  => $c->stash->{'trnordernumber'},
            trnamount       => $c->stash->{'trnamount'},
            authcode        => $c->stash->{'authcode'},
            messagetext     => $c->stash->{'messagetext'},
            trndate         => $c->stash->{'trndate'},
            name_first      => $c->stash->{'name_first'},
            name_last       => $c->stash->{'name_last'},
            name            => $c->stash->{'name_full'},   # In case the split screws up
            trnid           => $c->stash->{'trnid'},
        }
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
    return
        unless $form->process(
        item_id => $c->stash->{'trnid'},
        params  => $c->req->parameters,
        schema  => $c->model( 'SubscriberDB' )->schema
        );

    # Form validated, return to the books list
    #$c->stash->{status_msg} = 'Your preferences have been saved. Thank you!';
    #$c->res->redirect($c->uri_for('index'));
}

sub declined : Local : Args(0) {
    my ( $self, $c ) = @_;
    my $id    = $c->req->params->{'trnId'};
    my $amt   = $c->req->params->{'trnAmount'} // 'na';
    my $name  = $c->req->params->{'trnCustomerName'} // 'na';
    my $email = $c->req->params->{'trnEmailAddress'} // 'na';
    my $phone = $c->req->params->{'trnPhoneNumber'} // 'na';
    my $msg   = $c->req->params->{'messageText'} // 'na';
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
