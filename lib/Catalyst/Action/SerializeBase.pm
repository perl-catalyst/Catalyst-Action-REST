#
# Catlyst::Action::SerializeBase.pm
# Created by: Adam Jacob, Marchex, <adam@hjksolutions.com>
#
# $Id$

package Catalyst::Action::SerializeBase;

use strict;
use warnings;

use base 'Catalyst::Action';
use Moose::Util qw(does_role);
use Catalyst::ControllerRole::SerializeConfig;
use Module::Pluggable::Object;
use Catalyst::RequestRole::REST;
use Catalyst::ResponseRole::REST;
use Catalyst::Utils ();

__PACKAGE__->mk_accessors(qw(_serialize_plugins _loaded_plugins));

sub _load_content_plugins {
    my $self = shift;
    my ( $search_path, $controller, $c ) = @_;

    Catalyst::RequestRole::REST->meta->apply($c->request)
      unless does_role($c->request, 'Catalyst::RequestRole::REST');

    Catalyst::ResponseRole::REST->meta->apply($c->response)
      unless does_role($c->response, 'Catalyst::ResponseRole::REST');

    unless ( defined( $self->_loaded_plugins ) ) {
        $self->_loaded_plugins( {} );
    }

    # Load the Serialize Classes
    unless ( defined( $self->_serialize_plugins ) ) {
        my @plugins;
        my $mpo =
          Module::Pluggable::Object->new( 'search_path' => [$search_path], );
        @plugins = $mpo->plugins;
        $self->_serialize_plugins( \@plugins );
    }

    # Finally, we load the class.  If you have a default serializer,
    # and we still don't have a content-type that exists in the map,
    # we'll use it.
    my $sclass = $search_path . "::";
    my $sarg;
    my $map;

    Catalyst::ControllerRole::SerializeConfig->meta->apply($controller)
      unless does_role($controller, 'Catalyst::ControllerRole::SerializeConfig');

    my $config = $controller->serialize_config;
    
    $map = $config->{map};

    # pick preferred content type
    my @accepted_types; # priority order, best first
    # give top priority to content type specified by stash, if any
    my $content_type_stash_key = $config->{content_type_stash_key};
    if ($content_type_stash_key
        and my $stashed = $c->stash->{$content_type_stash_key}
    ) {
        # convert to array if not already a ref
        $stashed = [ $stashed ] if not ref $stashed;
        push @accepted_types, @$stashed;
    }
    # then content types requested by caller
    push @accepted_types, @{ $c->request->accepted_content_types };
    # then the default
    push @accepted_types, $config->{'default'} if $config->{'default'};
    # pick the best match that we have a serializer mapping for
    my ($content_type) = grep { $map->{$_} } @accepted_types;

    unless ($content_type) {
        $c->response->unsupported_media_type;
        return;
    }

    # carp about old text/x-json
    if ($content_type eq 'text/x-json') {
        $c->log->info('Using deprecated text/x-json content-type.');
        $c->log->info('Use application/json instead!');
    }

    if ( exists( $map->{$content_type} ) ) {
        my $mc;
        if ( ref( $map->{$content_type} ) eq "ARRAY" ) {
            $mc   = $map->{$content_type}->[0];
            $sarg = $map->{$content_type}->[1];
        } else {
            $mc = $map->{$content_type};
        }
        # TODO: Handle custom serializers more elegantly.. this is a start,
        # but how do we determine which is Serialize and Deserialize?
        #if ($mc =~ /^+/) {
        #    $sclass = $mc;
        #    $sclass =~ s/^+//g;
        #} else {
        $sclass .= $mc;
        #}
        if ( !grep( /^$sclass$/, @{ $self->_serialize_plugins } ) ) {
            $c->response->unsupported_media_type($content_type);
            return;
        }
    } else {
        $c->response->unsupported_media_type($content_type);
        return;
    }
    unless ( exists( $self->_loaded_plugins->{$sclass} ) ) {
        my $load_class = $sclass;
        $load_class =~ s/::/\//g;
        $load_class =~ s/$/.pm/g;
        eval { require $load_class; };
        if ($@) {
            $c->log->error(
                "Error loading $sclass for " . $content_type . ": $!" );
            $c->response->unsupported_media_type($content_type);
            return;
        } else {
            $self->_loaded_plugins->{$sclass} = 1;
        }
    }

    if ($search_path eq "Catalyst::Action::Serialize") {
        if ($content_type) {
            $c->response->header( 'Vary' => 'Content-Type' );
        } elsif ($c->request->accept_only) {
            $c->response->header( 'Vary' => 'Accept' );
        }
        $c->response->content_type($content_type);
    }

    return $sclass, $sarg, $content_type;
}

1;

=head1 NAME

B<Catalyst::Action::SerializeBase>

Base class for Catalyst::Action::Serialize and Catlayst::Action::Deserialize.

=head1 DESCRIPTION

This module implements the plugin loading and content-type negotiating
code for L<Catalyst::Action::Serialize> and L<Catalyst::Action::Deserialize>.

=head1 SEE ALSO

L<Catalyst::Action::Serialize>, L<Catalyst::Action::Deserialize>,
L<Catalyst::Controller::REST>,

=head1 AUTHOR

Adam Jacob <adam@stalecoffee.org>, with lots of help from mst and jrockway.

Marchex, Inc. paid me while I developed this module.  (http://www.marchex.com)

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut

