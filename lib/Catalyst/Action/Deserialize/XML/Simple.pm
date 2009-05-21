package Catalyst::Action::Deserialize::XML::Simple;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::DeserializeFormat';
use XML::Simple;
use namespace::clean -except => 'meta';

sub deserialize {
  my ($self, $content) = @_;
  my $x = XML::Simple->new(ForceArray => 0);
  my $data = $x->XMLin($content);
  $data = $data->{data} if exists $data->{data};
  return $data;
}

1;
