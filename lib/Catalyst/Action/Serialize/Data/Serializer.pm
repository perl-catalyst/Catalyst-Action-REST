package Catalyst::Action::Serialize::Data::Serializer;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::SerializeFormat';
use Data::Serializer;
use namespace::clean -except => 'meta';

sub serialize {
  my ($self, $data, $c, $serializer) = @_;
  unless (eval "use $serializer; 1") {
    $c->log->info("Could not load $serializer, refusing to serialize: $@");
    return 0;
  }
  my $d = Data::Serializer->new(serializer => $serializer);
  return $d->raw_serialize($data);
}

1;
