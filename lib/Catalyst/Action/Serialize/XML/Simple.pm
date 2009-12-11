package Catalyst::Action::Serialize::XML::Simple;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

sub execute {
    my $self = shift;
    my ( $controller, $c ) = @_;

    eval {
        require XML::Simple
    };
    if ($@) {
        $c->log->debug("Could not load XML::Serializer, refusing to serialize: $@")
            if $c->debug;
        return 0;
    }
    my $xs = XML::Simple->new(ForceArray => 0,);

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'} 
        ) || 'rest';
    my $output;
    eval {
        $output = $xs->XMLout({ data => $c->stash->{$stash_key} });
    };
    if ($@) {
        return $@;
    }
    $c->response->output( $output );
    return 1;
}

1;
