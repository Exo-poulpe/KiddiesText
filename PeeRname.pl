#!/bin/perl
# perl version : 5.30
# Description : This program rename files
use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Time::Seconds;
use Term::ANSIColor;
use utf8;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This program rename files in folder

Usage : \n
--path    |   \t: path of files to rename
--num     |   \t: num count number of occurence for add char (with --add)
--add     |   \t: char add this char after num options (with --num)
--char    | -c\t: path of files to rename
--replace | -r\t: path of files to rename
--output  | -o\t: print convert name
--force   |   \t: force to override
--list   |   \t: only print file in folder
--help    | -h\t: print this help
--verbose | -v\t: print more verbose

\n\nExample :

perl PeeRname.pl --path D:\\Folder -v
";

my $help        = 0;
my $verbose     = 0;
my $force       = 0;
my $output      = 0;
my $num         = 0;
my $list        = 0;
my $path        = "";
my $add         = "";
my $car         = "";
my $replace     = "";
my @oldLstFiles = ();
my @newLstFiles = ();
GetOptions(
    "path=s"      => \$path,       # string
    "char|c=s"    => \$car,        # string
    "replace|r=s" => \$replace,    # string
    "output|o"    => \$output,     # flag
    "force"       => \$force,      # flag
    "num=i"       => \$num,        # flag
    "list"        => \$list,       # flag
    "add=s"       => \$add,        # flag
    "verbose|v"   => \$verbose,    # flag
    "help|h|?"    => \$help,       # flag
) or die($helpText);

sub main() {
    if ( $help eq 1 ) {
        print($helpText);
    }
    elsif ( $path ne "" ) {
        my @files = glob( $path . '/*' );
        for my $f (@files) {
            push( @oldLstFiles, $f );
            ConvertPathFileToNew( $f, $car );
        }
        print("Old name : \n");
        print( join( "\n", @oldLstFiles ) );
        print("\n");
        print("\n");
        print("New name : \n");
        print( join( "\n", @newLstFiles ) );
        print("\n");

        if ( $list eq 1 ) {
            exit;
        }

        if ( $force eq 0 ) {
            print(
                "If you continue you will rename files are you sure ? [y/N] : "
            );
            while (<STDIN>) {
                my $res = $_;
                if ( $res eq "y\n" ) {

                    for ( my $i = 0 ; $i < @oldLstFiles ; $i += 1 ) {
                        RenameFile( $oldLstFiles[$i], $newLstFiles[$i] );
                    }
                    exit;
                }
                last;
            }
        }
        else {
            for ( my $i = 0 ; $i < @oldLstFiles ; $i += 1 ) {
                RenameFile( $oldLstFiles[$i], $newLstFiles[$i] );
            }
            exit;
        }
        print("\nOverride abort");
        exit;
    }
    else {
        print($helpText);
    }
}

sub RenameFile($$) {
    my ( $old, $new ) = @_;
    if ( $verbose eq 1 ) {
        print("${old} => ${new}\n");
    }
    rename( $old, $new );
}

sub ConvertPathFileToNew($$) {
    my ( $pathFile, $char ) = @_;
    my $lpath = GetPathName($pathFile);
    my $lfile = GetFileName($pathFile);
    my @tmp   = ();
    my $txt   = "";
    my $conv  = "";
    if ( $verbose eq 1 ) {
        print("Path : ${lpath}\n");
        print("File : ${lfile}\n");
    }
    $txt = $lfile;
    if ( $verbose eq 1 ) {
        print("Text before : $txt\n");
    }
    $txt = Replace( $txt, $char, $replace );
    if ( $verbose eq 1 ) {
        print("Text after : $txt\n\n");
    }

    push( @newLstFiles, $lpath . $txt );

}

sub Replace($$$) {
    my ( $lstr, $lchar, $lreplace ) = @_;
    my @lLst     = split( //, $lstr );
    my $res      = "";
    my $numCount = 0;
    for ( my $i = 0 ; $i < @lLst ; $i += 1 ) {
        my $c = $lLst[$i];
        if ( $c eq $lchar ) {
            $res .= $lreplace;
            $numCount += 1;
        }
        else {
            $res .= $c;
        }
        if ( $num eq $numCount && $add ne "" ) {
            $res .= $add;
            $numCount = -999999;
        }

    }
    return $res;
}

sub PrintBracketColor($$) {
    my ( $char, $col ) = @_;
    my $res = "";
    $res .= color($col);
    $res .= $char;
    $res .= color('reset');
}

sub GetPathName($) {
    my ($lpath) = @_;
    return substr( $lpath, 0, rindex( $lpath, "/" ) + 1 );

}

sub GetFileName($) {
    my ($lpath) = @_;
    return substr( $lpath, rindex( $lpath, "/" ) + 1 );
}

main();
