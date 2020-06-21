#!/bin/perl
# perl version : 5.30
# Author : Exo-poulpe
# Description : This program print data to edit in Virtual Box file
package PerlForing;

use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Time::Seconds;
use Term::ANSIColor;
use utf8;
use threads;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This program use protocol and test login

Usage : \n
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)
";

my $versionText = "
Author \t: \@Exo-poulpe
Version \t: 0.1.0.0

This tool is for educational purpose only, usage of PerlForing for attacking targets without prior mutual consent is illegal.
Developers assume no liability and are not responsible for any misuse or damage cause by this program.

";

my $help;
my $verbose;
my $text;
my @result;

GetOptions(
    'text|t=s'  => \$text,       # string
    'verbose|v' => \$verbose,    # flag
    'help|h|?'  => \$help,       # flag
) or die($helpText);

sub main()
{
    # $text = reverse($text);
    my @txt = split(//,$text);
    my @tmp;
    my $hex;
    for (my $i = 0,my $j = 0;$i < @txt;$i += 1)
    {
        push(@tmp,$txt[$i]);
        $j += 1;
        if(defined $verbose)
        {
            print("J = $j\n");
            print("Tmp = ",join('',@tmp),"\n");
        }
        if($j == 4)
        {
            my $value = join('',@tmp);
            @tmp = ();
            $j = 0;
            $hex = AsciiToHex($value);
            if(defined $verbose)
            {
                print("Hexa = 0x$hex\n");
            }
        }
        if($i + 1 == @txt)
        {
            my $value = AddSpaceToNumber(join('',@tmp),4);
            $hex = AsciiToHex($value);
            if(defined $verbose)
            {
                print("Hexa = 0x$hex\n");
            }
        }
    }

    print(join(',',@result));

}

sub AddSpaceToNumber($$)
{
    my ($text,$number) = @_;
    while(length($text) < $number)
    {
        $text .= ' ';
    }
    return $text;
}

sub AsciiToHex($)
{
    my ($data) = @_;
    $data = reverse($data);
    my $tmp;
    for my $c (split(//,$data))
    {
        $tmp .= sprintf("%x",ord($c));
    }
    push(@result,$tmp);
    return $tmp;

}

main();