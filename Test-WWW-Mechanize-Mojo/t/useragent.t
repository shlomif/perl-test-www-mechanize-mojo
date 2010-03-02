#!perl -T
use strict;
use warnings;
use lib 'lib';
use Encode qw();
use Test::More tests => 2;
use lib 't/lib';
use Test::WWW::Mechanize::Mojo 'Catty';

my $root = "http://localhost";
my $agent = 'TestAgent/1.0';
my $m = Test::WWW::Mechanize::Mojo->new(agent => $agent);

$m->get_ok("$root/user_agent");
$m->title_is($agent, "title is correct: $agent");
