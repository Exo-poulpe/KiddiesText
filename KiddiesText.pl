#!/bin/perl
use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Term::ANSIColor;

Getopt::Long::Configure("bundling");

my $helpText = "Usage : 
--text | -t\t: text to convert
--file | -f\t: file to convert
--timer\t\t: print time used
--quiet\t\t: less output info
--count\t\t: count line processed
--help | -h\t: print this help

\n\nExample :

perl KiddieText.pl -t \"text\" --timer
perl KiddieText.pl -f wordlist.txt --timer --count
";

my $help       = 0;
my $verbose    = 0;
my $quiet      = 0;
my $count      = 0;
my $timer      = 0;
my $lineNumber = 0;
my $text       = "";
my $file       = "";
my $result     = "";
GetOptions(
    "text|t=s"  => \$text,       # string
    "file|f=s"  => \$file,       # string
    "verbose|v" => \$verbose,    # flag
    "quiet"     => \$quiet,      # flag
    "timer"     => \$timer,      # flag
    "count"     => \$count,      # flag
    "help|h|?"  => \$help,       # flag
) or die($helpText);

sub main() {
    if ( $help eq 1 ) {
        print( ${helpText} );
    }
    elsif ( $text ne "" ) {
        my $start = Time::HiRes::gettimeofday();
        $text   = lc($text);
        $result = ConvertText($text);
        print( color('green') );
        print("$result\n");
        print( color('reset') );
        my $stop = Time::HiRes::gettimeofday();
        if ( $timer eq 1 ) {
            printf( "%.3f sec\n", $stop - $start );
        }
    }
    elsif ( $file ne "" ) {
        my $start = Time::HiRes::gettimeofday();
        my $line  = "";
        open( DATA, "< ${file}" ) or die "Couldn't open file ${file}, $!";
        while (<DATA>) {
            chomp($_);
            $line = $_;
            $lineNumber++;
            if ( $verbose eq 1 ) {
                print( '=' x 25 );
                print( color('blue') );
                print("\n$line\n");
                print( color('reset') );
            }
            $result = ConvertText($line);
            if ( $quiet eq 0 ) {
                print( color('green') );
                print("$result\n");
                print( color('reset') );
            }
        }
        my $stop = Time::HiRes::gettimeofday();
        if ( $timer eq 1 ) {
            printf( "%.3f sec\n", $stop - $start );
        }
        if ( $count eq 1 ) {
            print("Number of Line : ${lineNumber}\n");
        }
    }
    else {
        print( ${helpText} );
    }
}

sub ConvertText($) {
    my ($ptext) = @_;
    my $presult = "";

    for ( my $i = 0 ; $i < length($ptext) ; $i += 1 ) {
        my $tmp = substr( $ptext, $i, 1 );
        if ( $verbose eq 1 ) {
            print("substr : $tmp\n");
        }
        $presult .= ConvertChar($tmp);
    }
    return $presult;
}

sub ConvertChar($) {
    my ($char) = @_;

    if    ( $char eq "a" ) { $char = "@"; }
    elsif ( $char eq "e" ) { $char = "3"; }
    elsif ( $char eq "s" ) { $char = "\$"; }
    elsif ( $char eq "o" ) { $char = "0"; }
    elsif ( $char eq "b" ) { $char = "8"; }
    else {
        $char = $char;
    }
    if ( $verbose eq 1 ) {

        print("char return : $char\n\n");
    }
    return $char;
}

main();
