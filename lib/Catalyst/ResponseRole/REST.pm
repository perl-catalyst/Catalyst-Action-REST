package Catalyst::ResponseRole::REST;

use Moose::Role;

sub unsupported_media_type {
  my ($self, $content_type) = @_;

  $self->content_type('text/plain');
  $self->status(415);

  if (defined $content_type and length $content_type) {
    $self->body("Content-Type $content_type is not supported.\r\n");
  } else {
    $self->body("Cannot find a Content-Type supported by your client.\r\n");
  }
}

sub serialize_bad_request {
  my ($self, $content_type, $error) = @_;
  $self->content_type('text/plain');
  $self->status(400);
  $self->body(
    "Content-Type $content_type had a problem with your request\r\n" .
    "***ERROR***\r\n$error"
  );
  return undef;
}

1;
