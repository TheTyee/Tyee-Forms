package Tyee::Forms::Controller::Builders;
use Moose;
use namespace::autoclean;
use Date::Parse;
use DateTime;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Tyee::Forms::Controller::Builders - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body(
        'Matched Tyee::Forms::Controller::Builders in Builders TEST.' );
}

sub approved : Local : Args(0) {
    my ( $self, $c ) = @_;
    my $id     = $c->req->params->{'trnId'};
    my $amt    = $c->req->params->{'trnAmount'} // 'na';
    my $date   = $c->req->params->{'trnDate'} // 'na';
    my $num    = $c->req->params->{'trnOrderNumber'} // 'na';
    my $name   = $c->req->params->{'trnCustomerName'} // 'na';
    my $email  = $c->req->params->{'trnEmailAddress'} // 'na';
    my $phone  = $c->req->params->{'trnPhoneNumber'} // 'na';
    my $auth   = $c->req->params->{'authCode'} // 'na';
    my $msg    = $c->req->params->{'messageText'} // 'na';
    my $postal = $c->req->params->{'ref1'} // 'na';
    my $epoch  = str2time( $date );
    my $dt     = DateTime->from_epoch( epoch => $epoch );
    my ( $fname, $lname ) = split( ' ', $name );
    my $subscriber = $c->model( 'SubscriberDB::Subscriber' )->find_or_create(
        {   trnemailaddress => $email,
            trnphonenumber  => $phone,
            trnordernumber  => $num,
            trnamount       => $amt,
            authcode        => $auth,
            messagetext     => $msg,
            trndate         => $dt,
            name_first      => $fname,
            name_last       => $lname,
            name            => $name,     # In case the split screws up
            postal          => $postal,
            trnid           => $id,
        }
    );
    my $whatcounts = $c->model( 'WhatCounts' )->create_or_update(
        {   builder_amt  => $amt,
            builder_id   => $id,
            builder_date => $dt->mdy( '/' ),
            email        => $email,
            list_id      => $c->config->{'whatcounts_list_id'},
            realm_name   => $c->config->{'whatcounts_realm_name'},
            pw           => $c->config->{'whatcounts_pw'},
        }
    );
    if ( $whatcounts->{'content'} =~ /success/i ) {
        $subscriber->whatcounts('1');
        $subscriber->whatcounts_msg( $whatcounts->{'content'} );
        $subscriber->update;
    }
    $c->stash(
        trn_id     => $id,
        cust_name  => $name,
        trn_amt    => $amt,
        trn_num    => $num,
        cust_email => $email,
        cust_phone => $phone,
        date       => $date,
        title      => 'Your transaction was successful',
        whatcounts => $whatcounts,
    );
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
