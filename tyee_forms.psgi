use strict;
use warnings;

use Tyee::Forms;

my $app = Tyee::Forms->apply_default_middlewares(Tyee::Forms->psgi_app);
$app;

