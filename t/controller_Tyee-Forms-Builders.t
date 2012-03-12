use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Tyee::Forms';
use Tyee::Forms::Controller::Tyee::Forms::Builders;

ok( request('/tyee/forms/builders')->is_success, 'Request should succeed' );
done_testing();
