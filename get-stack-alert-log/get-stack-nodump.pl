#!/usr/bin/env perl

use warnings;
use strict;

my $startOfStack=0;
my $startOfSQL=0;
my @rawStack;
my @SQL;
my $sqlID='';

# check for ORA-00600 and	ORA-07445
my $ora600	= 'ORA-00600';
my $ora7445 = 'ORA-07445';

my $chkRE = qq[$ora600|$ora7445];

my %errorArgs = ();

my $debug=0;

while(<>) {

	if ( m/$chkRE/ ) {

		# error code is first field delimited by :
		my $errorCode = (split(/:/))[0];
		print "Error Code: $errorCode\n" if $debug;

		# get the first argument in []
		my $errorArg =	 (split(/[\[\]]/))[1];
		print "Error Arg: $errorArg\n" if $debug;

		$errorArgs{$errorCode}->{$errorArg}++;

		next;

	}

	if ( $startOfSQL ) {
		if ( m/^----- Call Stack Trace|^----- PL\/SQL/) {
			$startOfSQL = 0;
		} else {
			push @SQL, $_;
		}
	}


	if ( $startOfStack ) {
		last if m/^--------------------- Binary Stack Dump ---------------------/;

		next if m/^-------------------- -------- |^calling|^location/;

		next if m/^\s+/;
	}


	if (! $startOfSQL ) {
		$startOfSQL = m/----- Current SQL Statement/;
		if ($startOfSQL) {
			# ----- Current SQL Statement for this session (sql_id=3w84s3zf9dt8q) -----
			$sqlID = (split(/[=\)]/))[1];
			print "SQL_ID: $sqlID\n" if $debug;
			next;
		}
	};


	if (! $startOfStack ) {
		$startOfStack = m/Call Stack Trace/;
		next if $startOfStack;
	};


	# stack trace processing
	#print if $startOfStack;

	if ($startOfStack) {
		push @rawStack, (split(/\s+/))[0] ; #unless /^[[:digit:]]/;
	}


}

my @stack = ();
my $remainder=0;
my $call;

print 'Rawstack: ' , join("\n",@rawStack) if $debug;

#exit;

foreach my $el ( 0 .. $#rawStack ) {

	if ($remainder) {
		$remainder=0;
		$call='';
		next;
	}

	$call = $rawStack[$el];

	next if $call =~ /^__/; # typically system calls with no offset, such as __sighandler()

	# if the call does not end in ()+1234 then it is likely continued on the next line
	print "Call: $call#\n" if $debug;

	if (	! ( $call =~ /\(\)\+[[:digit:]]+$/ ) ) {

		print	 "Caught one! #$call#\n" if $debug;

		# skip if the next call starts with a digit
		# this happens when the line is split in the middle of a number
		if ( $call =~ /^[[:digit:]]/ ) {
			$call = '';
			next;
		} else {
			my $nextCall =	 $rawStack[$el + 1];
			print "	NextCall: $nextCall\n" if $debug;
			$call = $call . $nextCall;
			$remainder = 1;
			next;
		}
	}

} continue {
	#print "$call\n";
	push @stack, $call if $call;
}

# remove the '+1234' after each call
# the line may be split right after the +, so the digits are optional to remove
@stack  = map { my $x = $_; $x =~ s/\+[[:digit:]]*//; $_=$x } @stack;

# process split  lines - those not ending in ()
# the rest of the line probably is the line following

print join("\n",@stack) if $debug;

print "\nSQL_ID $sqlID\n\n@SQL\n";


print "\n";
foreach my $val ( @stack ) {
	print "$val ";
}
print "\n";

print join("\n",keys %errorArgs) if $debug;

print "\n\nArguments: \n";

foreach my $errCode ( sort keys %errorArgs ) {
	print "\nError: $errCode\n";
	foreach my $argument ( keys %{$errorArgs{$errCode}} ) {
		printf " %30s %5d\n" ,$argument, $errorArgs{$errCode}->{$argument};
	}
}


print join("\n",@SQL) if $debug;

print "\n";
