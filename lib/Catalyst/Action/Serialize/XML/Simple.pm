package Catalyst::Action::Serialize::XML::Simple;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

our $VERSION = '0.83';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c ) = @_;

    eval {
        require XML::Simple
    };
    if ($@) {
        $c->log->debug("Could not load XML::Serializer, refusing to serialize: $@")
            if $c->debug;
        return;
    }
    my $xs = XML::Simple->new(ForceArray => 0,);

    my $stash_key = (
            $controller->{'serialize'} ?
                $controller->{'serialize'}->{'stash_key'} :
                $controller->{'stash_key'} 
        ) || 'rest';
    my $output = $xs->XMLout({ data => $c->stash->{$stash_key} });
    $c->response->output( $output );
    return 1;
}

1;
