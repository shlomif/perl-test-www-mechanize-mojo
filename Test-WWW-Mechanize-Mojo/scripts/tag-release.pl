#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) =
    ( map { m{\Aversion *= *(\S+)\n?\z} ? ($1) : () }
        io->file("./dist.ini")->getlines() );

if ( !defined($version) )
{
    die "Version is undefined!";
}

my @cmd = (
    "git", "tag", "-m",
    "Tagging the Test-WWW-Mechanize-Mojo release as $version",
    "releases/$version",
);

print join( " ", map { /\s/ ? qq{"$_"} : $_ } @cmd ), "\n";
exec(@cmd);

