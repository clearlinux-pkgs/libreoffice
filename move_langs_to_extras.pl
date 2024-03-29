#!/usr/bin/perl
use strict;
use warnings;

################################################################################
# Create language support packages for a component.
#
# This program finds and scans a spec file, detects the packages files defined
# in it, and then classifies language-support files, explicitly listing them in
# lang-*_extras files to make autospec put them in their own packages, and via
# lang-*_extras_requires, make *those* packages depend on the base package.
#
# Just run it in the package directory, then run autospec again *if* there are
# changes in lang-*_extras or lang-*_extras_requires files.
################################################################################

# Read in the files from the spec file

my $package;
my $specfile = (glob('*.spec'))[0]
	or die "Unable to find a spec file";

open(my $spec, "<", $specfile)
	or die "Failed to open $specfile: $!\n";

my %files;
my $base_package_name;

# Read in all the installed filenames from the spec file
LINE:
while (my $line = <$spec>) {
	chomp $line;

	# Capture which (if any) package these files are part of
	if ($line =~ m/^\%files(?:\s+(\S+))?/) {
		$package = $1 || '';
		next LINE;
	}

	# Identify the base package for this component
	if (! $base_package_name && $line =~ m/^\s*Name\s*:\s*(\S+)/) {
		$base_package_name = $1;
		next LINE;
	}

	# Skip ahead to the %files declarations
	next LINE unless defined $package;

	# Capture the filenames for this package
	if ($line =~ m#^/#) {
		$files{$package}{$line}++;
	}
}

close($spec)
	or die "$specfile: $!";

# Got the list of files, now let's process it to identify lang files
my %langs;
foreach my $package (keys %files) {
	foreach my $file (keys %{$files{$package}}) {
		# We'll take the existence of LC_MESSAGES as evidence of the support for
		# a particular language variant. We're lumping all variants together.
		# /usr/lib64/libreoffice/program/resource/zh_TW/LC_MESSAGES/vcl.mo
		if ($file =~ m#^.*/([a-z]+)(?:[_\-\@][a-zA-Z]+)?/LC_MESSAGES#) {
			my $lang = $1;

			# Add this file's language to our list of detected languages
			$langs{$lang}++;
		}
	}
}

# Create a regex that will detect all language-related files, informed by the
# list of languages we've identified
my $lang_join = join('|', sort keys %langs);
my $lang_re = qr#^.*?[/_\-]($lang_join)(?:[_\-\@][a-zA-Z\-]+)?(?:[/\.].*)?$#;

# Now use the languages pattern to bin the files by language
my %extras;
foreach my $package (sort keys %files) {
	# Don't touch license files
	next if $package eq 'license';

	FILE:
	foreach my $file (sort keys %{$files{$package}}) {
		# Don't touch filter files
		next if $file =~ m#^/usr/lib64/libreoffice/share/filter/#;

		if ($file =~ $lang_re) {
			my $lang = lc($1);

			# Add this file to the list of files for the detected language
			$extras{$lang}{$file}++;
		}
	}
}

# We've binned the files, now generate the ${custom}_extras files
LANG:
foreach my $lang (sort keys %extras) {

	# Don't put the default English files into a separate package, though
	next LANG if $lang eq 'en';

	my $filename = "lang-${lang}_extras";

	open(my $fh, '>', $filename)
		or die "Failed to create $filename: $!";

	print $fh "## This file was auto-generated by $0\n";
	print $fh "## Manual changes will be lost\n";

	# Keep it sorted to simplify diffs
	foreach my $file (sort keys %{$extras{$lang}}) {
		print $fh "$file\n"
			or die "$filename: $!";
	}

	close($fh)
		or die "$filename: $!";

	# Also make this custom package depend on the base package via _extras_requires
	$filename .= '_requires';
	open($fh, '>', $filename)
		or die "Failed to create $filename: $!";
	print $fh "$base_package_name\n";
	close($fh)
		or die "$filename: $!";
}
