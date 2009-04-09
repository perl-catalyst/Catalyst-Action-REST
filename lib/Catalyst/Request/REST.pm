#
# REST.pm
# Created by: Adam Jacob, Marchex, <adam@hjksolutions.com>
# Created on: 10/13/2006 03:54:33 PM PDT
#
# $Id: $

package Catalyst::Request::REST;

use strict;
use warnings;

use Moose;
extends qw/Catalyst::Request Class::Accessor::Fast/;
with 'Catalyst::RequestRole::REST';

use Catalyst::Utils;

sub _insert_self_into {
  my ($class, $app_class ) = @_;
  # the fallback to $app_class is for the (rare and deprecated) case when
  # people are defining actions in MyApp.pm instead of in a controller.
  my $app = Catalyst::Utils::class2appclass( $app_class ) || $app_class;

  my $req_class = $app->request_class;
  return if $req_class->isa($class);
  if ($req_class eq 'Catalyst::Request') {
    $app->request_class($class);
  } else {
    die "$app has a custom request class $req_class, "
      . "which is not a $class; see Catalyst::Request::REST";
  }
}

=head1 NAME

Catalyst::Request::REST - A REST-y subclass of Catalyst::Request

=head1 METHODS

If the request went through the Deserializer action, this method will
returned the deserialized data structure.

=cut

__PACKAGE__->mk_accessors(qw(data));

=head1 AUTHOR

Adam Jacob <adam@stalecoffee.org>, with lots of help from mst and jrockway

=head1 MAINTAINER

J. Shirley <jshirley@cpan.org>

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut

1;
