package Catalyst::Request::REST;
use Moose;

use Catalyst::Utils;
use namespace::autoclean;

extends 'Catalyst::Request';
with 'Catalyst::TraitFor::Request::REST';

# Please don't take this as a recommended way to do things.
# The code below is grotty, badly factored and mostly here for back
# compat..
sub _insert_self_into {
  my ($class, $app_class ) = @_;
  # the fallback to $app_class is for the (rare and deprecated) case when
  # people are defining actions in MyApp.pm instead of in a controller.
  my $app = (blessed($app_class) && $app_class->can('_application'))
        ? $app_class->_application : Catalyst::Utils::class2appclass( $app_class ) || $app_class;

  my $req_class = $app->request_class;
  return if $req_class->isa($class);
  my $req_class_meta = Moose->init_meta( for_class => $req_class );
  return if $req_class_meta->does_role('Catalyst::TraitFor::Request::REST');
  if ($req_class eq 'Catalyst::Request') {
    $app->request_class($class);
  }
  else {
      my $meta = Moose::Meta::Class->create_anon_class(
          superclasses => [$req_class],
          roles => ['Catalyst::TraitFor::Request::REST'],
          cache => 1
      );
      $meta->add_method(meta => sub { $meta });
      $app->request_class($meta->name);
  }
}

__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

Catalyst::Request::REST - A REST-y subclass of Catalyst::Request

=head1 SYNOPSIS

     if ( $c->request->accepts('application/json') ) {
         ...
     }

     my $types = $c->request->accepted_content_types();

=head1 DESCRIPTION

This is a subclass of C<Catalyst::Request> that adds a few methods to
the request object to faciliate writing REST-y code. Currently, these
methods are all related to the content types accepted by the client.

Note that if you have a custom request class in your application, and it does
not inherit from C<Catalyst::Request::REST>, your application will fail with an
error indicating a conflict the first time it tries to use
C<Catalyst::Request::REST>'s functionality.  To fix this error, make sure your
custom request class inherits from C<Catalyst::Request::REST>.

=head1 METHODS

=over

=item data

If the request went through the Deserializer action, this method will
return the deserialized data structure.

=item accepted_content_types

Returns an array reference of content types accepted by the
client.

The list of types is created by looking at the following sources:

=over 8

=item * Content-type header

If this exists, this will always be the first type in the list.

=item * content-type parameter

If the request is a GET request and there is a "content-type"
parameter in the query string, this will come before any types in the
Accept header.

=item * Accept header

This will be parsed and the types found will be ordered by the
relative quality specified for each type.

=back

If a type appears in more than one of these places, it is ordered based on
where it is first found.

=item preferred_content_type

This returns the first content type found. It is shorthand for:

  $request->accepted_content_types->[0]

=item accepts($type)

Given a content type, this returns true if the type is accepted.

Note that this does not do any wildcard expansion of types.

=back

=head1 AUTHORS

See L<Catalyst::Action::REST> for authors.

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut
