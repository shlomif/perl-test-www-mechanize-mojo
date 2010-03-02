#!perl
use strict;
use warnings;
use lib 'lib';
use Test::More tests => 28;
use lib 't/lib';
use Test::WWW::Mechanize::Catalyst 'Catty';

my $root = "http://localhost";

my $m;
foreach my $where (qw{hi greetings bonjour}) {
    $m = Test::WWW::Mechanize::Catalyst->new;
    $m->get_ok( "$root/$where", "got something when we $where" );

    is( $m->base, "http://localhost/hello", "check got to hello 1/4" );
    is( $m->ct, "text/html", "check got to hello 2/4" );
    $m->title_is( "Hello",, "check got to hello 3/4" );
    $m->content_contains( "Hi there",, "check got to hello 4/4" );

    # check that the previous response is still there
    my $prev = $m->response->previous;
    ok( $prev, "have a previous" );
    is( $prev->code, 302, "was a redirect" );
    like( $prev->header('Location'), '/hello$/', "to the right place" );
}

# extra checks for bonjour (which is a double redirect)
my $prev = $m->response->previous->previous;
ok( $prev, "have a previous previous" );
is( $prev->code, 302, "was a redirect" );
like( $prev->header('Location'), '/hi$/', "to the right place" );

$m->get("$root/redirect_with_500");
is ($m->status, 500, "Redirect not followed on 500");
