#!/bin/sh

die () {
	echo "$*" >&2
	exit 1
}

test $# = 1 ||
die "Usage: $0 Git-<version>-<bitness>-bit.exe"

type innoextract.exe >/dev/null ||
die "Need innoextract.exe in the PATH"

innoextract.exe -l -m "$1" |
perl -e '
	use POSIX qw/ceil/;
	my $total = 4382720; # estimate of uninstaller + extra files/dirs
	while (<>) {
		if (/.*\((\d+(\.\d+)?) (B|KiB|MiB)\)\r?$/) {
			my $size = $1;
			if ($3 eq "KiB") {
				$size *= 1024;
			} elsif ($3 eq "MiB") {
				$size *= 1024 * 1024;
			}
			$total += 4096 * ceil($size / 4096);
		}
	}
	print $total;
	'
