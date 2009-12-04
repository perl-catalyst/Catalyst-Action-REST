package Catalyst::Action::Serialize::View;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

sub execute {
    my $self = shift;
    my ( $controller, $c, $view ) = @_;

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'} 
        ) || 'rest';

    if ( !$c->view($view) ) {
        $c->log->error("Could not load $view, refusing to serialize");
        return;
    }

    return $c->view($view)->process($c, $stash_key);
}

1;
