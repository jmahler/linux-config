#!/usr/bin/perl
use strict;

die "usage: $0 modules.txt\n" unless (@ARGV);

my $file = shift @ARGV;

open FILE, "< $file"
	or die "Unable to open '$file': $!";

foreach my $mod (<FILE>) {
	chomp($mod);

	my $res = system("sudo modprobe $mod");
	print "$mod ($res)\n";
}
