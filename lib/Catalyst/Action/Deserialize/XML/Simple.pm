package Catalyst::Action::Deserialize::XML::Simple;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

our $VERSION = '0.87';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c, $test ) = @_;

    eval {
        require XML::Simple;
    };
    if ($@) {
        $c->log->debug("Could not load XML::Simple, refusing to deserialize: $@")
            if $c->debug;
        return 0;
    }

    my $body = $c->request->body;
    if ($body) {
        my $xs = XML::Simple->new('ForceArray' => 0,);
        my $rdata;
        eval {
            $rdata = $xs->XMLin( "$body" );
        };
        if ($@) {
            return $@;
        }
        if (exists($rdata->{'data'})) {
            $c->request->data($rdata->{'data'});
        } else {
            $c->request->data($rdata);
        }
    } else {
        $c->log->debug(
            'I would have deserialized, but there was nothing in the body!')
                if $c->debug;
    }
    return 1;
}

1;
