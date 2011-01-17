#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) = 
    (map { m{\$VERSION *= *'([^']+)'} ? ($1) : () } 
    io->file("lib/Test/WWW/Mechanize/Mojo.pm")->getlines()
    )
    ;

if (!defined ($version))
{
    die "Version is undefined!";
}

my $mini_repos_base = 'https://svn.berlios.de/svnroot/repos/web-cpan/Test-WWW-Mechanize-Mojo';

my @cmd = (
    "svn", "copy", "-m",
    "Tagging the Test-WWW-Mechanize-Mojo release as $version",
    "$mini_repos_base/trunk",
    "$mini_repos_base/tags/releases/$version",
);

print join(" ", map { /\s/ ? qq{"$_"} : $_ } @cmd), "\n";
exec(@cmd);
