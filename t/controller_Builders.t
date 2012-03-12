use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Tyee::Forms';
use Tyee::Forms::Controller::Builders;

ok( request('/builders')->is_success, 'Request should succeed' );
done_testing();
