package Catalyst::Action::Deserialize::YAML;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use YAML::Syck;

our $VERSION = '0.88';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c, $test ) = @_;

    my $body = $c->request->body;
    if ($body) {
        my $rdata;
        eval {
            my $body = $c->request->body;
            $rdata = LoadFile( "$body" );
        };
        if ($@) {
            return $@;
        }
        $c->request->data($rdata);
    } else {
        $c->log->debug(
            'I would have deserialized, but there was nothing in the body!')
            if $c->debug;
    }
    return 1;
}

1;
