package Catalyst::ControllerRole::SerializeConfig;
use Moose::Role;
use namespace::clean -except => 'meta';

my @KEYS = qw(map content_type_stash_key default);

has serialize_config => (
  is         => 'ro',
  isa        => 'HashRef',
  init_arg   => undef,
  lazy_build => 1,
);

sub _build_serialize_config {
  my $self = shift;
  my $c = $self->_application;
  my $config;
  if ( exists $self->{serialize} ) {
    $c->log->info("Using deprecated configuration for Catalyst::Action::REST!");
    $c->log->info("Please see perldoc Catalyst::Action::REST for the update guide");
    $config = $self->{serialize};
    # if they're using the deprecated config, they may be expecting a
    # default mapping too.
    $config->{map} ||= $self->{map};
  } else {
    # do not store a reference to itself in the controller
    $config = {
      map {; $_ => $self->{$_} } @KEYS
    };
  }
  return $config;
};

1;
