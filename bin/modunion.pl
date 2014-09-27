#!/usr/bin/perl
use strict;

die "usage: $0 modules.txt\n" unless (@ARGV);

my $MODULES_FILE = "modules.txt";

sub get_cur_modules {

	my $cur_lsmod = `lsmod`;

	my @lines = split /\n/, $cur_lsmod;

	# remove header
	shift @lines;

	my @cur_mods;
	foreach my $line (@lines) {
		my @parts = split /\s/, $line;

		push @cur_mods, $parts[0]
	}

	@cur_mods = sort @cur_mods;

	return @cur_mods;
}

sub get_prev_modules {
	my $file = shift;

	open FILE, "< $file"
		or die "Unable to open '$file': $!";

	my @prev_mods = <FILE>;
}

sub sorted_union {
	my $_a = shift;
	my $_b = shift;

	my @a = @$_a;
	my @b = @$_b;

	my @union;

	my $idx_a = 0;
	my $idx_b = 0;

	while (1) {
		my $a = $a[$idx_a];
		my $b = $b[$idx_b];

		if ($a < $b) {
			push @union, $a;
			$idx_a++;
		} elsif ($a > $b) {
			push @union, $b;
			$idx_b++;
		} elsif ($a == $b) {
			push @union, $a;
			$idx_a++;
			$idx_b++;
		}

		if ($idx_a == @a and $idx_b == @b) {
			last;
		} elsif ($idx_a == @a) {
			for (; $idx_b < @b; $idx_b++) {
				push @union, $b[$idx_b];	
			}
			last;
		} elsif ($idx_b == @b) {
			for (; $idx_a < @a; $idx_a++) {
				push @union, $a[$idx_a];	
			}
			last;
		}
	}

	return @union;
}

my @cur_mods = get_cur_modules();

my @prev_mods = get_prev_modules($MODULES_FILE);

my @all_mods = sorted_union(\@cur_mods, \@prev_mods);

map { print "$_\n" } @all_mods;

