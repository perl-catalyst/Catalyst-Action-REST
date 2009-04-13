package Catalyst::RequestRole::Deserialize;
use Moose::Role;
use namespace::clean -except => 'meta';

has data => (
  is => 'ro',
  writer => '_set_data',
);

1;
