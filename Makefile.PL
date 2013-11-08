use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

perl_version '5.8.1';

name 'Catalyst-Action-REST';
all_from 'lib/Catalyst/Action/REST.pm';

requires 'Moose' => '1.03';
requires 'namespace::autoclean';
requires('Catalyst::Runtime'         => '5.80030');
requires('Params::Validate'          => '0.76');
requires('Module::Pluggable::Object' => undef);
requires('LWP::UserAgent'            => '2.033');
requires('Class::Inspector'          => '1.13');
requires('URI::Find'                 => undef);
requires('MRO::Compat'               => '0.10');

requires 'namespace::autoclean';
test_requires 'Test::More' => '0.88';
test_requires 'Test::Requires';

author_requires 'Test::Pod' => 1.14;
author_requires 'Module::Info';
author_requires 'File::Find::Rule';

author_tests 'xt/';

feature 'JSON (application/json) support',
    -default   => 0,
    'JSON'     => '2.12',
    'JSON::XS' => '2.2222';

author_requires 'JSON'     => '2.12';
author_requires 'JSON::XS' => '2.2222';

feature 'YAML:Syck (for YAML)',
    -default => 0,
    'YAML::Syck' => '0.67';
author_requires 'YAML::Syck';

feature 'HTML::Parser (for HTML input)',
    -default => 0,
    'HTML::Parser' => undef;
author_requires 'HTML::Parser';

feature 'Data::Taxi (text/x-data-taxi) support (deprecated)',
    -default => 0,
    'Data::Taxi' => undef;

author_requires 'Data::Taxi';

feature 'Config::General (text/x-config-general) support',
    -default => 0,
    'Config::General' => undef;
author_requires 'Config::General';

feature 'PHP::Serialization (text/x-php-serialization) support',
    -default => 0,
    'PHP::Serialization' => undef;
author_requires 'PHP::Serialization';

feature 'FreezeThaw (application/x-freezethaw) support',
    -default => 0,
    'FreezeThaw' => undef;
author_requires 'FreezeThaw';

feature 'XML::Simple (text/xml) support',
    -default => 0,
    'XML::Simple' => undef;
author_requires 'XML::Simple';

auto_install;

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Catalyst/Action/REST.pm > README")
        and die $!;
}

repository 'git://git.shadowcat.co.uk/catagits/Catalyst-Action-REST.git';

add_metadata( x_authority => 'cpan:BOBTFISH' );

WriteAll;

