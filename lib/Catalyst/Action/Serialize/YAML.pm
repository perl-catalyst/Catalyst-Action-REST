package Catalyst::Action::Serialize::YAML;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::Serialize';
use YAML::Syck;
use namespace::clean -except => 'meta';

sub serialize { Dump $_[1] }

1;
