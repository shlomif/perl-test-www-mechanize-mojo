#!perl

use strict;
use warnings;

use Test::More;

use Test::More tests => 3;
use Test::Mojo;
use Test::WWW::Mechanize::Mojo;

require "t/lib/mojjy.pl";

my $t = Test::Mojo->new();

my $root = "http://localhost";

my $m = Test::WWW::Mechanize::Mojo->new(tester => $t);

$m->credentials( 'user', 'pass' );

# TEST
$m->get_ok("/");

# TEST
$m->title_is("Root");

# TEST
is( $m->status, 200 );
