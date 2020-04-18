#!/bin/perl
# perl version : 5.30
# Description : This program convert text to Kiddies text from file or text
use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Time::Seconds;
use Term::ANSIColor;
use utf8;
use Perl::MinimumVersion;

Getopt::Long::Configure("bundling");

my $helpText = "
Description : This program rename files in folder

Usage : \n
--file    | -f\t: file ot scan
--help    | -h\t: print this help
--verbose | -v\t: print more verbose

\n\nExample :

perl PeeRname.pl --path D:\\Folder -v
";

my $help    = 0;
my $verbose = 0;
my $file    = "";

GetOptions(
    "file|f=s"  => \$file,       # string
    "verbose|v" => \$verbose,    # flag
    "help|h|?"  => \$help,       # flag
) or die($helpText);

sub main() {
    if ( $help eq 1 ) {
        print($helpText);
    }
    elsif ( $file ne "" ) {
        my $object = Perl::MinimumVersion->new($file);
        print( $object->minimum_version );
    }
    else {
        print($helpText);
    }

}

main();
