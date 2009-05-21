package Catalyst::Action::Deserialize::YAML;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::DeserializeFormat';
use YAML::Syck;
use namespace::clean -except => 'meta';

sub deserialize { Load $_[1] }

1;
