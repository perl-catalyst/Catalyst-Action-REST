package Catalyst::Action::Serialize::YAML;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::SerializeFormat';
use YAML::Syck;
use namespace::clean -except => 'meta';

sub serialize { Dump $_[1] }

1;
