use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorRequires;

perl_version '5.8.1';

name 'Catalyst-Action-REST';
all_from 'lib/Catalyst/Action/REST.pm';

requires 'Moose';
requires 'namespace::autoclean';
requires('Catalyst::Runtime'         => '5.80');
requires('Params::Validate'          => '0.76');
requires('YAML::Syck'                => '0.67');
requires('Module::Pluggable::Object' => undef);
requires('LWP::UserAgent'            => '2.033');
requires('Data::Serializer'          => '0.36');
requires('Class::Inspector'          => '1.13');
requires('URI::Find'                 => undef);
requires('MRO::Compat'               => '0.10');

requires 'namespace::autoclean';
test_requires 'Test::More' => '0.88';

feature 'JSON (application/json) support',
    -default   => 0,
    'JSON'     => '2.12';
    'JSON::XS' => '2.2222';

author_requires 'JSON'     => '2.12';
author_requires 'JSON::XS' => '2.2222';

feature 'Data::Taxi (text/x-data-taxi) support',
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

auto_include;
auto_install;

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Catalyst/Action/REST.pm > README")
        and die $!;
}

repository 'git://git.shadowcat.co.uk/catagits/Catalyst-Action-REST.git';

WriteAll;

