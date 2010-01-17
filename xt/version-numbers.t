use strict;
use warnings;

use File::Find::Rule;
use Module::Info;

use Test::More qw( no_plan );

my %versions;
for my $pm_file ( File::Find::Rule->file->name( qr/\.pm$/ )->in('lib' ) ) {
    my $mod = Module::Info->new_from_file($pm_file);

    ( my $stripped_file = $pm_file ) =~ s{^lib/}{};

    $versions{$stripped_file} = $mod->version;
}

my $moose_ver = $versions{'Catalyst/Action/REST.pm'};

for my $module ( grep { $_ ne 'Catalyst/Action/REST.pm' } sort keys %versions ) {
    is( $versions{$module}, $moose_ver,
        "version for $module is the same as in Catalyst/Action/REST.pm" );
}
