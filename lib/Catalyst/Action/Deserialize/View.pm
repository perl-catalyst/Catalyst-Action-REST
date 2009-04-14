package Catalyst::Action::Deserialize::View;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::Deserialize';
use namespace::clean -except => 'meta';

sub deserialize { undef };

1;
