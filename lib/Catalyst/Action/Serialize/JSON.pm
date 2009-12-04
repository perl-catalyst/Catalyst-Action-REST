package Catalyst::Action::Serialize::JSON;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use JSON qw(encode_json);

sub execute {
    my $self = shift;
    my ( $controller, $c ) = @_;

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'} 
        ) || 'rest';
    my $output = $self->serialize( $c->stash->{$stash_key} );
    $c->response->output( $output );
    return 1;
}

sub serialize {
    my $self = shift;
    encode_json( shift );
}

1;
