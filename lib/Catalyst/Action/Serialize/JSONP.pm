package Catalyst::Action::Serialize::JSONP;
use base 'Catalyst::Action::Serialize::JSON';

sub execute {
  my $self = shift;
  my ($controller, $c) = @_;

  my $callback_key = (
    $controller->{'serialize'} ?
      $controller->{'serialize'}->{'callback_key'} :
      $controller->{'callback_key'} 
    ) || 'callback';

  if ($c->req->param($callback_key)) {
    $self->{_jsonp_callback} = $c->req->param($callback_key);
    $c->res->content_type('text/javascript');
  }
  $self->next::method($controller, $c);
}

sub serialize {
  my $self = shift;
  my $json = $self->next::method(@_);
  if ($self->{_jsonp_callback}) {
    $json = $self->{_jsonp_callback}.'('.$json.');';
  }
  return $json;
}

1;
