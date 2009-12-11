package Catalyst::Action::Serialize::JSON::XS;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action::Serialize::JSON';
use JSON::XS qw(encode_json);

sub serialize {
    my $self = shift;
    encode_json( shift );
}

1;
