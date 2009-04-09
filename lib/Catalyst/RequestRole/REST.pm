package Catalyst::RequestRole::REST;
# ABSTRACT: A REST-y role for Catalyst::Request
use Moose::Role;

use Catalyst::Utils;
use HTTP::Headers::Util qw(split_header_words);
use namespace::clean -except => 'meta';

has accept_only => (
  is      => 'ro',
  isa     => 'Bool',
  writer  => '_set_accept_only',
  default => 0,
);

has accepted_content_types => (
  is         => 'ro',
  isa        => 'ArrayRef',
  init_arg   => undef,
  lazy_build => 1,
);

has _accepted_content_types_hash => (
  is         => 'ro',
  isa        => 'HashRef',
  init_arg   => undef,
  lazy_build => 1,
);

sub _build_accepted_content_types {
  my $self = shift;
  my %types;

  # First, we use the content type in the HTTP Request.  It wins all.
  $types{ $self->content_type } = 3 if $self->content_type;

  if ($self->method eq "GET" &&
    (my $ct = $self->params->{'content-type'})) {
    $types{ $ct } = 2;
  }

  # Third, we parse the Accept header, and see if the client
  # takes a format we understand.
  #
  # This is taken from chansen's Apache2::UploadProgress.
  if ( $self->header('Accept') ) {
    $self->_set_accept_only(1) unless keys %types;

    my $accept_header = $self->header('Accept');
    my $counter       = 0;

    foreach my $pair ( split_header_words($accept_header) ) {
      my ( $type, $qvalue ) = @{$pair}[ 0, 3 ];
      next if $types{$type};

      unless ( defined $qvalue ) {
        $qvalue = 1 - ( ++$counter / 1000 );
      }

      $types{$type} = sprintf( '%.3f', $qvalue );
    }
  }

  return [ sort { $types{$b} <=> $types{$a} } keys %types ];
}

sub preferred_content_type { $_[0]->accepted_content_types->[0] }

sub _build__accepted_content_types_hash {
  return { map {; $_ => 1 } @{ $_[0]->accepted_content_types } };
}

sub accepts { $_[0]->_accepted_content_types_hash->{$_[1]} }

1;

__END__

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

=method accepted_content_types

Returns an array reference of content types accepted by the
client.

The list of types is created by looking at the following sources:

=over 4

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

=method preferred_content_type

This returns the first content type found. It is shorthand for:

  $request->accepted_content_types->[0]

=method accepts

Given a content type, this returns true if the type is accepted.

Note that this does not do any wildcard expansion of types.

=cut
