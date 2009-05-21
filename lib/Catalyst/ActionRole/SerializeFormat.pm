package Catalyst::ActionRole::SerializeFormat;
use Moose::Role;
use Catalyst::ControllerRole::SerializeConfig;
use Moose::Util qw(does_role);
use namespace::clean -except => 'meta';
requires 'serialize';

around execute => sub {
  my $next = shift;
  my ($self, $controller, $c, $arg) = @_;

  # XXX is ignoring the return value here correct? the original serialize
  # actions never even called their body.
  $self->$next($controller, $c, $arg)
    if blessed $self;

  Catalyst::ControllerRole::SerializeConfig->meta->apply($controller)
    unless does_role($controller, 'Catalyst::ControllerRole::SerializeConfig');
      
  my $stash_key = $controller->serialize_config->{stash_key} || 'rest';

  my $output;
  eval {
    $output = $self->serialize(
      $c->stash->{$stash_key},
      $c,
      $arg,
    );
  };
  return $@ if $@;
  # horrible, but the best I can do given the existing magic return value
  # conventions.
  return $output if $output eq '0';
  $c->response->body($output) unless $c->response->body;
  return 1;
};

1;
