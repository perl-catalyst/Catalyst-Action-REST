package Catalyst::Action::Deserialize::View;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

our $VERSION = '0.83';
$VERSION = eval $VERSION;

sub execute {
    return 1;
}

1;
