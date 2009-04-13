package Catalyst::Action::Deserialize::JSON;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::Deserialize';
use JSON qw(decode_json);
use namespace::clean -except => 'meta';

sub deserialize { decode_json $_[1] }

1;
