#!/usr/bin/env perl
# Script to convert AES Known Answer Test (KAT) Vectors into a set of C
# initializers

use warnings;
use strict;

my $key;
my $plaintext;
my $ciphertext;

sub printblock
{
  my $block = shift;
  my $needComma = 0;
  for (my $i = 0; $i < length($block); $i += 2) {
    if ($needComma) {
      print ", ";
    }
    print "0x";
    print substr($block, $i, 2);
    print "";
    $needComma = 1;
  }
}

my $needComma = 0;
while (<>) {
  if (/DECRYPT/) {
    # Ignore everything after [DECRYPT] - these are just the same testcases
    # repeated.
    last;
  }
  if (/([A-Z]+) = ([0-9a-f]+)/) {
    if ($1 eq "KEY") {
      $key = $2;
    } elsif ($1 eq "PLAINTEXT") {
      $plaintext = $2;
    } elsif ($1 eq "CIPHERTEXT") {
      $ciphertext = $2;
      if ($needComma) {
        print ",\n";
      }
      print "{\n";
      print "  { ";
      printblock($key);
      print " }, // key\n";
      print "  { ";
      printblock($plaintext);
      print " }, // plaintext\n";
      print "  { ";
      printblock($ciphertext);
      print " }  // ciphertext\n";
      print "}";
      $needComma = 1;
    }
  }
}
print "\n";
