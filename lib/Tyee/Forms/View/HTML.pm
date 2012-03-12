package Tyee::Forms::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    WRAPPER => 'wrapper.tt',
    render_die => 1,
);

=head1 NAME

Tyee::Forms::View::HTML - TT View for Tyee::Forms

=head1 DESCRIPTION

TT View for Tyee::Forms.

=head1 SEE ALSO

L<Tyee::Forms>

=head1 AUTHOR

api@thetyee.ca

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
