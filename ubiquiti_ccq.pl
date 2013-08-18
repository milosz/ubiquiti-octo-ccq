#!/usr/bin/perl

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Cookies;
use JSON;

if (($#ARGV+1) ne 1) {
 exit();
}

my $host = $ARGV[0];
my $cookie_jar = HTTP::Cookies->new();
my $browser  = LWP::UserAgent->new();
my $response = '';
my $directory = '';
my $json = JSON->new();

$browser->cookie_jar( $cookie_jar);

$response = $browser->get(
  "https://${host}/login.cgi"
);

$response = $browser->post(
  "https://${host}/login.cgi",
  Content_Type => 'form-data',
  Content => [
    username => 'USER',
    password => 'PASS',
  ],
);

$response = $browser->get(
  "https://${host}/index.cgi"
);

# 
# Use "120816.1338" directory
# 
# Use "110723.1014" directory
if ($response->content =~ m//) {
  $directory = $&;
  $directory =~ s//$1/;
  $response = $browser->get(
    "https://${host}/${directory}/status.cgi"
  );

  print ($json->decode($response->content)->{wireless}->{ccq}/10 . "\n");
}
