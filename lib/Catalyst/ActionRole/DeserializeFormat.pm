package Catalyst::ActionRole::DeserializeFormat;
use Moose::Role;
use Moose::Util qw(does_role);
use Catalyst::RequestRole::Deserialize;
use namespace::clean -except => 'meta';

requires 'deserialize';

around execute => sub {
  my $next = shift;
  my ($self, $controller, $c, $arg) = @_;

  Catalyst::RequestRole::Deserialize->meta->apply($c->request)
    unless does_role($c->request, 'Catalyst::RequestRole::Deserialize');

  my $content = "";
  my $body = $c->request->body;
  if ($body) {
    local $_;
    while (<$body>) { $content .= $_ }
  }

  if ($content) {
    my $data = eval {
      $self->deserialize(
        $content,
        $c,
        $arg,
      )
    };
    return $@ if $@;
    $c->request->_set_data($data);
  } else {
    $c->debug && $c->log->debug(
      'I would have deserialized, but there was nothing in the body!'
    );
  }
  return 1;
};

1;
