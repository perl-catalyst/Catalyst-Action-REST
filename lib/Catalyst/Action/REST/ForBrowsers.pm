package Catalyst::Action::REST::ForBrowsers;

use Moose;
use namespace::autoclean;

our $VERSION = '0.88';
$VERSION = eval $VERSION;

extends 'Catalyst::Action::REST';
use Catalyst::Request::REST::ForBrowsers;

sub BUILDARGS {
    my $class  = shift;
    my $config = shift;
    Catalyst::Request::REST::ForBrowsers->_insert_self_into( $config->{class} );
    return $class->SUPER::BUILDARGS( $config, @_ );
}

override dispatch => sub {
    my $self = shift;
    my $c    = shift;

    my $req = $c->request();

    return super()
        unless $req->can('looks_like_browser')
            && $req->looks_like_browser()
            && uc $c->request()->method() eq 'GET';

    my $controller  = $c->component( $self->class );
    my $rest_method = $self->name() . '_GET_html';

    if (   $controller->action_for($rest_method)
        || $controller->can($rest_method) ) {

        return $self->_dispatch_rest_method( $c, $rest_method );
    }

    return super();
};

__PACKAGE__->meta->make_immutable;

1;
