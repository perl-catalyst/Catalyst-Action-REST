package Catalyst::Action::Serialize::View;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Action';

our $VERSION = '0.84';
$VERSION = eval $VERSION;

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

    if ($c->view($view)->process($c, $stash_key)) {
      return 1;
    } else {
      # This is stupid. Please improve it.
      my $error = join("\n", @{ $c->error }) || "Error in $view";
      $error .= "\n";
      $c->clear_errors;
      die $error;
    }
}

1;
