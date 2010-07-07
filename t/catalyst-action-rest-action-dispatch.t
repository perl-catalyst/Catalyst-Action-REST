use strict;
use warnings;
use Test::More 0.88;
use FindBin;

use lib ( "$FindBin::Bin/lib", "$FindBin::Bin/../lib" );
use Test::Rest;

# Should use the default serializer, YAML
my $t = Test::Rest->new( 'content_type' => 'text/plain' );

use_ok 'Catalyst::Test', 'Test::Catalyst::Action::REST';

foreach my $method (qw(GET DELETE POST PUT OPTIONS)) {
    my $run_method = lc($method);
    my $res;
    if ( grep /$method/, qw(GET DELETE OPTIONS) ) {
        $res = request( $t->$run_method( url => '/actions/test' ) );
    } else {
        $res = request(
            $t->$run_method(
                url  => '/actions/test',
                data => '',
            )
        );
    }
    ok( $res->is_success, "$method request succeeded" );
    is(
        $res->content,
        "$method",
        "$method request had proper response"
    );
    is(
        $res->header('X-Was-In-TopLevel'),
        '1',
        "went through top level action for dispatching to $method"
    );
    is(
        $res->header('Using-Action'),
        'STATION',
        "went through action for dispatching to $method"
    );
}

my $res = request(
    $t->put(
        url  => '/actions/test',
        data => '',
    )
);
is(
    $res->header('Using-Action'),
    'STATION',
    "went through action for dispatching to PUT"
);
is(
    $res->header('Using-Sub-Action'),
    'MOO',
    "went through sub action for dispatching to PUT"
);

done_testing;
