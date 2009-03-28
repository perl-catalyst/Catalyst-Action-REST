package Test::Catalyst::Action::REST::Controller::REST;

use strict;
use warnings;

use base 'Catalyst::Controller::REST';

sub test : Local {
  my ($self, $c) = @_;
  $self->status_ok($c, entity => { test => 'worked', data => $c->req->data });
}

1;
