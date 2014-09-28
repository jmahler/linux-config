#!/usr/bin/perl
use strict;

die "usage: $0 modules.txt\n" unless (@ARGV);

my $MODULES_FILE = shift @ARGV;

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

	for (my $i = 0; $i < @prev_mods; $i++) {
		chomp($prev_mods[$i]);
	}

	return @prev_mods;
}

sub sorted_union {
	my $_a = shift;
	my $_b = shift;

	my @as = @$_a;
	my @bs = @$_b;

	my @union;

	my $idx_a = 0;
	my $idx_b = 0;

	while (1) {
		my $a = $as[$idx_a];
		my $b = $bs[$idx_b];

		if ($idx_a == @as and $idx_b == @bs) {
			# both empty
			last;
		} elsif ($idx_a == @as) {
			# a empty, use rest of b
			for (; $idx_b < @bs; $idx_b++) {
				push @union, $bs[$idx_b];
			}
			last;
		} elsif ($idx_b == @bs) {
			# b empty, use rest of a
			for (; $idx_a < @as; $idx_a++) {
				push @union, $as[$idx_a];
			}
			last;
		}

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
	}

	return @union;
}

my @cur_mods = get_cur_modules();

my @prev_mods = get_prev_modules($MODULES_FILE);

my @all_mods = sorted_union(\@cur_mods, \@prev_mods);

map { print "$_\n" } @all_mods;

