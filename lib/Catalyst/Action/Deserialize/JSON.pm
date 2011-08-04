package Catalyst::Action::Deserialize::JSON;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use JSON;

our $VERSION = '0.91';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c, $test ) = @_;

    my $body = $c->request->body;
    my $rbody;

    if ($body) {
        while (my $line = <$body>) {
            $rbody .= $line;
        }
    }

    if ( $rbody ) {
        my $json = JSON->new->utf8;
        if (my $options = $controller->{json_options}) {
            foreach my $opt (keys %$options) {
                $json->$opt( $options->{$opt} );
            }
        }
        my $rdata = eval { $json->decode( $rbody ) };
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

__PACKAGE__->meta->make_immutable;

1;
