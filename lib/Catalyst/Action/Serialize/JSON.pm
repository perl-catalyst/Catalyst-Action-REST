package Catalyst::Action::Serialize::JSON;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::SerializeFormat';
use JSON qw(encode_json);
use namespace::clean -except => 'meta';

sub serialize { encode_json $_[1] }

1;
