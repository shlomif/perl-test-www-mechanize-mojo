use strict;
use warnings;

use Test::More;
use lib 't/lib';

eval {
    require Catalyst::Plugin::Session;
    require Catalyst::Plugin::Session::State::Cookie;
};

if ($@) {
    diag($@);
    plan skip_all => "Need Catalyst::Plugin::Session to run this test";
} else {
    plan tests => 4;
}

use Test::WWW::Mechanize::Mojo;

my $m1 = Test::WWW::Mechanize::Mojo->new(catalyst_app => 'Catty');
my $m2 = Test::WWW::Mechanize::Mojo->new(catalyst_app => 'CattySession');

$m1->get_ok("/name");
$m1->title_is('Catty');

$m2->get_ok("/name");
$m2->title_is('CattySession');
