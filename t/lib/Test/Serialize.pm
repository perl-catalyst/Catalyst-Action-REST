package Test::Serialize;

use FindBin;

use lib ("$FindBin::Bin/../lib");

use strict;
use warnings;

use Catalyst::Runtime '5.70';

use Catalyst;

__PACKAGE__->config(
    name => 'Test::Serialize',
    serialize => {
        'stash_key' => 'rest',
        'map'       => {
            'text/html'          => 'YAML::HTML',
            'text/xml'           => 'XML::Simple',
            'text/x-yaml'        => 'YAML',
            'text/x-json'        => 'JSON',
            'text/x-data-dumper' => [ 'Data::Serializer', 'Data::Dumper' ],
            'text/x-data-denter' => [ 'Data::Serializer', 'Data::Denter' ],
            'text/x-data-taxi'   => [ 'Data::Serializer', 'Data::Taxi'   ],
            'application/x-storable'    => [ 'Data::Serializer', 'Storable'     ],
            'application/x-freezethaw'  => [ 'Data::Serializer', 'FreezeThaw'   ],
            'text/x-config-general' => [ 'Data::Serializer', 'Config::General' ],
            'text/x-php-serialization' => [ 'Data::Serializer', 'PHP::Serialization' ],
            'text/broken'        => 'Broken',
        },
    }
);

__PACKAGE__->setup;

sub monkey_put :Local :ActionClass('Deserialize') {
    my ( $self, $c ) = @_;
    $c->res->output($c->req->data->{'sushi'});
}

sub monkey_get :Local :ActionClass('Serialize') {
    my ( $self, $c ) = @_;
    $c->stash->{'rest'} = { monkey => 'likes chicken!', };
}

1;

