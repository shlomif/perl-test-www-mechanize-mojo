use lib "./buildlib";

use Test::Run::Builder;

use strict;
use warnings;

my $build = Test::Run::Builder->new(
    module_name => "Test::WWW::Mechanize::Mojo",
    test_requires =>
    {
        'Test::Exception'=> '0',
        'Test::More' => '0',
    },
    requires => 
    {
        'Mojolicious::Lite' => 0,
        'LWP'                                      => '5.816',
        'Test::WWW::Mechanize'                     => '1.14',
        'WWW::Mechanize'                           => '1.50',
        'namespace::clean'                         => '0.09',
    },
    dist_version_from => "lib/Test/WWW/Mechanize/Mojo.pm",
    license => "perl",
    create_makefile_pl => 'traditional',
    meta_merge =>
    {
        resources =>
        {
            repository => "http://svn.berlios.de/svnroot/repos/web-cpan/Test-WWW-Mechanize-Mojo",
            homepage => "http://web-cpan.berlios.de/modules/Test-WWW-Mechanize-Mojo/",
        },
        keywords =>
        [
        ],
    },

);

$build->create_build_script;
