package Catalyst::Action::Deserialize::JSON::XS;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action::Deserialize::JSON';
use JSON::XS ();

our $VERSION = '1.00';
$VERSION = eval $VERSION;

__PACKAGE__->meta->make_immutable;

1;
