package Catalyst::Action::Serialize::JSON::XS;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action::Serialize::JSON';
use JSON::XS ();

our $VERSION = '1.00';
$VERSION = eval $VERSION;

sub _build_encoder {
   my $self = shift;
   return JSON::XS->new->convert_blessed;
}

__PACKAGE__->meta->make_immutable;

1;
