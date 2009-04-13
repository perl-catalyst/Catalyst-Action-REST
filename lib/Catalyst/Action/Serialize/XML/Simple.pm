package Catalyst::Action::Serialize::XML::Simple;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::Serialize';
use XML::Simple;
use namespace::clean -except => 'meta';

sub serialize {
  my ($self, $data, $c) = @_;
  my $x = XML::Simple->new(ForceArray => 0);
  return $x->XMLout({ data => $data });
}

1;
