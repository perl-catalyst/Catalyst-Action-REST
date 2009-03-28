use strict;
use warnings;
use Test::More tests => 2;
use YAML::Syck;
use FindBin;

use lib ("$FindBin::Bin/lib", "$FindBin::Bin/../lib", "$FindBin::Bin/broken");
use Test::Rest;

my $t = Test::Rest->new(content_type => 'text/x-yaml');

use_ok 'Catalyst::Test', 'Test::Catalyst::Action::REST';

my $data = { your => 'face' };
is_deeply(
  Load(
    request($t->put(url => '/rest/test', data => Dump($data)))->content
  ),
  { test => 'worked', data => $data },
  'round trip (deserialize/serialize)',
);
