use strict;
use warnings;

use Test::More tests => 4;
use lib 't/lib';
use Test::WWW::Mechanize::Catalyst;

my $m = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Catty');

$m->host('foo.com');
$m->get_ok('/host');
$m->content_contains('Host: foo.com:80');

$m->clear_host;
$m->get_ok('/host');
$m->content_contains('Host: localhost:80') or diag $m->content;
