package Catalyst::Action::Deserialize::Data::Serializer;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';
use Data::Serializer;
use Safe;
my $compartment = Safe->new;
$compartment->permit_only( qw(padany null lineseq const pushmark list anonhash anonlist refgen leaveeval undef) );

our $VERSION = '0.89';
$VERSION = eval $VERSION;

sub execute {
    my $self = shift;
    my ( $controller, $c, $serializer ) = @_;

    my $sp = $serializer;
    $sp =~ s/::/\//g;
    $sp .= ".pm";
    eval {
        require $sp
    };
    if ($@) {
        $c->log->debug("Could not load $serializer, refusing to serialize: $@")
            if $c->debug;
        return 0;
    }
    my $body = $c->request->body;
    if ($body) {
        my $rbody;
        if ( -f $c->request->body ) {
            open( BODY, "<", $c->request->body );
            while ( my $line = <BODY> ) {
                $rbody .= $line;
            }
            close(BODY);
        }
        my $rdata;
        if ( $serializer eq "Data::Dumper" ) {
            # Taken from Data::Serialize::Data::Dumper::deserialize, but run within a Safe compartment
            my $code = $rbody =~ /^\{/ ? "+".$rbody : $rbody;
            $rdata = $compartment->reval( $code );
        }
        else {
            my $dso = Data::Serializer->new( serializer => $serializer );
            eval {
                $rdata = $dso->raw_deserialize($rbody);
            };
        }
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
