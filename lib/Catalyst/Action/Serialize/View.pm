package Catalyst::Action::Serialize::View;
use Moose;
extends 'Catalyst::Action';
with 'Catalyst::ActionRole::SerializeFormat';
use namespace::clean -except => 'meta';

sub serialize {
  my ($self, $data, $c, $view) = @_;

  unless ($c->view($view)) {
      $c->log->error("Could not load $view, refusing to serialize");
      return 0;
  }

  return $c->view($view)->process($c);
}

1;
