package Tyee::Forms::BuilderSurvey;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class' => ( default => 'Subscriber' );

has_field 'newspref_accountgov' => ( type => 'Checkbox', widget => 'checkbox', label => 'Accountable government' );
has_field 'submit_btn' => ( type => 'Submit', value => 'Submit', widget => 'ButtonTag' );

1;
