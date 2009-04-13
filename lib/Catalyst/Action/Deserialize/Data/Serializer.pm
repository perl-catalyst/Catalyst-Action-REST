package Catalyst::Action::Deserialize::Data::Serializer;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::Deserialize';
use Data::Serializer;
use namespace::clean -except => 'meta';

sub deserialize {
  my ($self, $content, $c, $serializer) = @_;
  unless (eval "use $serializer; 1") {
    $c->log->debug("Could not load $serializer, refusing to serialize: $@")
      if $c->debug;
    return 0;
  }
  my $d = Data::Serializer->new(serializer => $serializer);
  return $d->raw_deserialize($content);
}

1;
