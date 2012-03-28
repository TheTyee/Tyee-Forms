package Tyee::Forms::BuilderSurvey;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class' => ( default => 'Subscriber' );

has_field 'newspref_accountgov' => (
    type   => 'Checkbox',
    widget => 'checkbox',
    label  => 'Accountable government'
);
has_field 'newspref_arts_comm' => (
    type   => 'Checkbox',
    widget => 'checkbox',
    label  => 'Arts and community'
);
has_field 'newspref_crime_just' => (
    type   => 'Checkbox',
    widget => 'checkbox',
    label  => 'Crime and justice'
);
has_field 'newspref_economy' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Economy' );
has_field 'newspref_education' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Education' );
has_field 'newspref_energy' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Energy' );
has_field 'newspref_enviro' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Environment' );
has_field 'newspref_health' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Health' );
has_field 'newspref_housing' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Housing' );
has_field 'newspref_poverty' =>
    ( type => 'Checkbox', widget => 'checkbox', label => 'Poverty' );
has_field 'newspref_rights_just' => (
    type   => 'Checkbox',
    widget => 'checkbox',
    label  => 'Rights and justice'
);

has_field 'pref_fiction' => (
    type    => 'Select',
    widget  => 'RadioGroup',
    label   => 'Do you like fiction or non-fiction?',
    options => [
        { value => 0, label => 'Non-fiction' },
        { value => 1, label => 'Fiction' }
    ],
    wrapper_attr => { class => 'radios' }
);

has_field 'pref_enews_daily' => (
    type   => 'Select',
    widget => 'RadioGroup',
    label =>
        'Would you like our daily e-newsletter? It lists all the stories published in the last 24 hours, many of which you funded with your generous donation.',
    options => [
        { value => 1, label => 'Yes' },
        { value => 0, label => 'No' },
        { value => 2, label => 'Already subscribed' }
    ],
    wrapper_attr => { class => 'radios' }
);

has_field 'pref_enews_weekly' => (
    type   => 'Select',
    widget => 'RadioGroup',
    label =>
        'Would you like our weekly e-newlsetter? Same as the daily but with seven days of goodness and previews of upcoming events.',
    options => [
        { value => 1, label => 'Yes' },
        { value => 0, label => 'No' },
        { value => 2, label => 'Already subscribed' }
    ],
    wrapper_attr => { class => 'radios' }
);

has_field 'pref_sponsor_enews' => (
    type   => 'Select',
    widget => 'RadioGroup',
    label =>
        'Are you open to select email from Tyee sponsors in the future? (I know it’s a lot to ask, but it would really help us pay the bills if you say yes to this one! No pressure, though.)',
    options =>
        [ { value => 1, label => 'Yes' }, { value => 0, label => 'No' } ],
    wrapper_attr => { class => 'radios' }
);

has_field 'builder_is_anonymous' => (
    type   => 'Select',
    widget => 'RadioGroup',
    label =>
        'We like to sometimes acknowledge donors publicly. May we acknowledge your donation?',
    options =>
        [ { value => 0, label => 'Yes' }, { value => 1, label => 'No' } ],
    wrapper_attr => { class => 'radios' }
);

has_field 'pref_future_enews' => (
    type   => 'Select',
    widget => 'RadioGroup',
    label =>
        'If we ever create a regular newsletter the collects stories about the news interest you selected above, would you like us to send it to you?',
    options =>
        [ { value => 1, label => 'Yes' }, { value => 0, label => 'No' } ],
    wrapper_attr => { class => 'radios' }
);

has_field 'submit_btn' => (
    type   => 'Submit',
    value  => 'Save your preferences',
    widget => 'ButtonTag'
);

1;
