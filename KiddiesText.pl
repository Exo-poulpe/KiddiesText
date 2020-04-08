#!/bin/perl
# Description : This program convert text to Kiddies text from file or text
use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Time::Seconds;
use Term::ANSIColor;

Getopt::Long::Configure("bundling");

my $helpText = "
Description : This program convert text to Kiddies text from file or text

Usage : \n
--text    | -t\t: text to convert
--file    | -f\t: file to convert
--output  | -o\t: output file to save data (use --stdout for print output) *override file
--timer\t\t: print time used
--quiet\t\t: less output info
--count\t\t: count line processed
--stdout\t: print result text for file output (only with output flag)
--help    | -h\t: print this help
--verbose | -v\t: print more verbose

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
my $stdout     = 0;
my $text       = "";
my $output     = "";
my $file       = "";
my $result     = "";
GetOptions(
    "text|t=s"   => \$text,       # string
    "file|f=s"   => \$file,       # string
    "output|o=s" => \$output,     # string
    "verbose|v"  => \$verbose,    # flag
    "quiet"      => \$quiet,      # flag
    "timer"      => \$timer,      # flag
    "count"      => \$count,      # flag
    "stdout"     => \$stdout,     # flag
    "help|h|?"   => \$help,       # flag
) or die($helpText);

sub main() {
    if ( $help eq 1 ) {
        print( ${helpText} );
    }
    elsif ( $text ne "" ) {
        my $start = Time::HiRes::gettimeofday();
        $text   = lc($text);
        $result = ConvertText($text);
        PrintColor( $result, 'green' );
        my $stop = Time::HiRes::gettimeofday();

        if ( $timer eq 1 ) {
            printf( "%.3f sec\n", $stop - $start );
        }
    }
    elsif ( $file ne "" ) {
        if ( $output ne "" ) {
            if ( $stdout eq 1 ) {
                $quiet = 0;
            }
            else {
                $quiet = 1;
            }
            CleanFile($output);
        }
        my $start = Time::HiRes::gettimeofday();
        my $line  = "";
        open( DATA, "< ${file}" )
          or die PrintColor( "Couldn't open file : ${file}, $!", 'red' );

        while (<DATA>) {
            chomp($_);
            $line = $_;
            $lineNumber++;

            if ( $verbose eq 1 ) {
                my $tmp = '=' x 25;
                $tmp .= "\n";
                print($tmp);
                PrintChar( "*", 'blue' );
                print("${line}\n");
            }
            $result = ConvertText($line);

            if ( $output ne "" ) {

                open( my $fh, '>>', $output );
                print( $fh "${result}\n" );
                close $fh;
            }

            if ( $quiet eq 0 ) {
                PrintColor( $result, 'green' );
            }
        }

        my $stop = Time::HiRes::gettimeofday();

        if ( $timer eq 1 ) {
            my $elapsed = Time::Seconds->new( $stop - $start );
            $elapsed = $elapsed->pretty;
            PrintChar( "*", 'blue' );
            print("Time elpased : ${elapsed}\n");
        }

        if ( $count eq 1 ) {
            PrintChar( "*", 'blue' );
            print("Number of Line : ${lineNumber}\n");
        }
    }
    else {
        print( ${helpText} );
    }
}

sub CleanFile($) {
    my ($file) = @_;
    open( my $fh, '>', $file );
    close $fh;
}

sub PrintChar($$) {
    my ( $char, $color ) = @_;
    print("[");
    print( color($color) );
    print($char);
    print( color('reset') );
    print("] ");
}

sub PrintColor($$) {
    my ( $data, $color ) = @_;
    print( color($color) );
    print("$data\n");
    print( color('reset') );
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
