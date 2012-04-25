#!/usr/bin/env perl 
use strict;
use warnings;
use HTTP::Tiny;
use JSON::Any;
use IO::All;

# Get the JSON feed
my $res = HTTP::Tiny->new->get('http://localhost:3000/builders/list/3/public/json');
die unless $res->{'success'};

# Convert it into a data structure
my $j = JSON::Any->new;
my $subs = $j->jsonToObj( $res->{'content'} );

# Build an HTML list from the data
my $content = '<ul class="builder">' . "\n";
for my $sub ( @{ $subs->{'subscribers'} } ) {
    $content .= "    <li>$sub->{'name_first'} $sub->{'name_last'} just became a Tyee Builder. " . '<a href="http://thetyee.ca/About/Builders">Find out how</a>.' . "</li>\n";
}
$content .= '</ul>';

# Output to a file for inclusion on the site
$content > io('public_builders.html');
