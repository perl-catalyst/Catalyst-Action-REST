package Test::Role;
use Moose::Role;
no Moose::Role;

package Test::Catalyst::Action::REST::Controller::Anon;
use Moose;

BEGIN { extends 'Catalyst::Controller::REST' };

__PACKAGE__->config(
    'default'   => 'text/x-yaml',
);

sub COMPONENT {
    my ($class, $app, $args) = @_;

    my $meta = $class->meta->create_anon_class(
            superclasses => [ $class->meta->name ],
            roles        => ['Test::Role'],
            cache        => 1,
    );

    $meta->add_method('meta' => sub { $meta });
    $class = $meta->name;
    $class->new($app, $args);
}

sub test : Local ActionClass('REST') {
  my ($self, $c) = @_;
    $c->stash->{rest} = { action => 'ok' };
}

sub test_GET {}

sub test_POST {}

no Moose;

1;
