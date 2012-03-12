package Tyee::Forms::Model::WhatCounts;
use Moose;
use namespace::autoclean;
use HTTP::Tiny;

extends 'Catalyst::Model';

sub create_or_update {
    my ( $self, $sub ) = @_;
    my $http   = HTTP::Tiny->new();
    my $API    = 'http://premiere.whatcounts.com/bin/api_web?';
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
    return $response;
}



# http://premiere.whatcounts.com/bin/api_web?r=media_thetyee&p=XXXXX&cmd=sub&list_id=36871&data=email,first,last^jane@domain.com,Jane,Doe
# http://premiere.whatcounts.com/bin/list_edit2?cmd=edit&id=36871&CSRFChallengeToken=%2590%25E0%25D6%25CCOo%251BX%252Bx%25E5%25DBi%258E%25AD%25D7%250A%25DD%253A%259F%25DE%259F%25F9J%258A%25CDLR%25EF%25080Z%2508%2580%253A%25AEBn%25F1%25F4%2504%2580F%25C1%255D%25E5%25A8%25E7%255E%25EA%2590%25D3%2596%25C0%25B0%25C1%25E9%250Aj%2511%25AE%2503%2597m
#my $response = HTTP::Tiny->new->get( 'http://example.com/' );

#die "Failed!\n" unless $response->{success};

#print "$response->{status} $response->{reason}\n";

#while ( my ( $k, $v ) = each %{ $response->{headers} } ) {
#for ( ref $v eq 'ARRAY' ? @$v : $v ) {
#print "$k: $_\n";
#}
#}

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
