package Catalyst::Action::Deserialize;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action::SerializeBase';
use Module::Pluggable::Object;
use MRO::Compat;

our $VERSION = '0.90';
$VERSION = eval $VERSION;

has plugins => ( is => 'rw' );

sub execute {
    my $self = shift;
    my ( $controller, $c ) = @_;

    my @demethods = qw(POST PUT OPTIONS DELETE);
    my $method    = $c->request->method;
    if ( grep /^$method$/, @demethods ) {
        my ( $sclass, $sarg, $content_type ) =
          $self->_load_content_plugins( 'Catalyst::Action::Deserialize',
            $controller, $c );
        return 1 unless defined($sclass);
        my $rc;
        if ( defined($sarg) ) {
            $rc = $sclass->execute( $controller, $c, $sarg );
        } else {
            $rc = $sclass->execute( $controller, $c );
        }
        if ( $rc eq "0" ) {
            return $self->_unsupported_media_type( $c, $content_type );
        } elsif ( $rc ne "1" ) {
            return $self->_serialize_bad_request( $c, $content_type, $rc );
        }
    }

    $self->maybe::next::method(@_);

    return 1;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Catalyst::Action::Deserialize - Deserialize Data in a Request

=head1 SYNOPSIS

    package Foo::Controller::Bar;

    __PACKAGE__->config(
        'default'   => 'text/x-yaml',
        'stash_key' => 'rest',
        'map'       => {
            'text/x-yaml'        => 'YAML',
            'text/x-data-dumper' => [ 'Data::Serializer', 'Data::Dumper' ],
        },
    );

    sub begin :ActionClass('Deserialize') {}

=head1 DESCRIPTION

This action will deserialize HTTP POST, PUT, and OPTIONS requests.
It assumes that the body of the HTTP Request is a serialized object.
The serializer is selected by introspecting the requests content-type
header.

The specifics of deserializing each content-type is implemented as
a plugin to L<Catalyst::Action::Deserialize>.  You can see a list
of currently implemented plugins in L<Catalyst::Controller::REST>.

The results of your Deserializing will wind up in $c->req->data.
This is done through the magic of L<Catalyst::Request::REST>.

While it is common for this Action to be called globally as a
C<begin> method, there is nothing stopping you from using it on a
single routine:

   sub foo :Local :Action('Deserialize') {}

Will work just fine.

When you use this module, the request class will be changed to
L<Catalyst::Request::REST>.

=head1 SEE ALSO

You likely want to look at L<Catalyst::Controller::REST>, which implements
a sensible set of defaults for a controller doing REST.

L<Catalyst::Action::Serialize>, L<Catalyst::Action::REST>

=head1 AUTHORS

See L<Catalyst::Action::REST> for authors.

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut
