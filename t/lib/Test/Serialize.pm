package Test::Serialize;

use FindBin;

use lib ("$FindBin::Bin/../lib");

use Moose;
use namespace::autoclean;

use Catalyst::Runtime '5.70';

use Catalyst;

__PACKAGE__->config(
    name => 'Test::Serialize',
);

__PACKAGE__->setup;

1;

