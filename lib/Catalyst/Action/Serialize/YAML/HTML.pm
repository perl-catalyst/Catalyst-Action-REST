package Catalyst::Action::Serialize::YAML::HTML;
use Moose;
extends 'Catalyst::Action::Serialize::YAML';
use URI::Find;
use namespace::clean -except => 'meta';

around serialize => sub {
  my $next = shift;
  my ($self, $data, $c) = @_;
  my $yaml = $self->$next($data, $c);
  my $app = $c->config->{name} || '';
  my $finder = URI::Find->new(sub {
    my($uri, $orig_uri) = @_;
    my $newuri;
    if ($uri =~ /\?/) {
        $newuri = $uri . "&content-type=text/html";
    } else {
        $newuri = $uri . "?content-type=text/html";
    }
    return qq|<a href="$newuri">$orig_uri</a>|;
  });
  my $output = "<html>";
  $output .= "<title>" . $app . "</title>";
  $output .= "<body><pre>";
  $finder->find(\$yaml);
  $output .= $yaml;
  $output .= "</pre>";
  $output .= "</body>";
  $output .= "</html>";
  return $output;
};

1;
