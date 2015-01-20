requires 'Catalyst::Runtime' => '5.80030' ;
requires 'Class::Inspector' => '1.13' ;
requires 'LWP::UserAgent' => '5.00' ;
requires 'MRO::Compat' => '0.10' ;
requires 'Module::Pluggable::Object' => undef ;
requires 'Moose' => '1.03';
requires 'Params::Validate' => '0.76' ;
requires 'URI::Find' => undef ;
requires 'namespace::autoclean';

on test => sub {
   requires 'Test::More' => '0.88';
   requires 'Test::Requires';
};

suggests 'Config::General';
suggests 'Data::Taxi';
suggests 'FreezeThaw';
suggests 'HTML::Parser';
suggests 'JSON::MaybeXS';
suggests 'Cpanel::JSON::XS';
suggests 'PHP::Serialization';
suggests 'XML::Simple';
suggests 'YAML::Syck';
