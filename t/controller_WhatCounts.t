use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Tyee::Forms';
use Tyee::Forms::Controller::WhatCounts;

ok( request('/whatcounts')->is_success, 'Request should succeed' );
done_testing();
