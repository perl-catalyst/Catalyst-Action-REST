use strict;
use warnings;
use Test::More;
use FindBin;

use lib ("$FindBin::Bin/lib", "$FindBin::Bin/../lib");
use Test::Rest;
use utf8;

eval 'use JSON 2.12';
plan skip_all => 'Install JSON 2.12 or later to run this test' if ($@);

plan tests => 7;

use_ok 'Catalyst::Test', 'Test::Serialize', 'Catalyst::Action::Serialize::JSON';

my $json = JSON->new->utf8;

for ('text/javascript','application/x-javascript','application/javascript') {
    my $t = Test::Rest->new('content_type' => $_);
    my $monkey_template = { monkey => 'likes chicken!' };

    my $mres = request($t->get(url => '/monkey_get?callback=omnivore'));
    ok( $mres->is_success, 'GET the monkey succeeded' );

    my ($json_param) = $mres->content =~ /^omnivore\((.*)?\);$/;
    is_deeply($json->decode($json_param), $monkey_template, "GET returned the right data");
}

1;
