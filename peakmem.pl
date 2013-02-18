#!/usr/bin/perl -w

# from http://tstarling.com/blog/2010/06/measuring-memory-usage-with-strace

# changes:
# - show only max mem, and use \r to animate display
# - better x64 detection ... Tim's version uses 
# 	if ( `uname -m` eq 'x86_64' ) {
#   to spot x64, but this will always fail since the uname output will 
#   include a \n
# - watch sub-processes too

my $cmd;

$machine = `uname -m`;
chomp($machine);

if ( $machine eq 'x86_64' ) {
	$cmd = 'strace -f -e trace=mmap,munmap,brk ';
} else {
	$cmd = 'strace -f -e trace=mmap,mmap2,munmap,brk ';
}

for my $arg (@ARGV) {
	$arg =~ s/'/'\\''/g;
	$cmd .= " '$arg'";
}
$cmd .= ' 2>&1 >/dev/null';

open( PIPE, "$cmd|" ) or die "Cannot execute command \"$cmd\"\n";

my $currentSize = 0;
my $maxSize = 0;
my %maps;
my %topOfData;
my ($addr, $length, $prot, $flags, $fd, $pgoffset);
my $newTop;
my $v;
my $error = '';

# turn on output flushing after every write
$|++;

while ( <PIPE> ) {
	$pid = 0;
	if ( /^\[pid  (\d+)\] / ) {
		$pid = $1;
	}

	if ( /mmap2?\((.*)\) = (\w+)/ ) {
		$v = $pid . $2;
		@params = split( /, ?/, $1 );
		($addr, $length, $prot, $flags, $fd, $pgoffset) = @params;
		if ( $addr eq 'NULL' && $fd == -1 ) {
			$maps{$v} = $length;
			$currentSize += $length;
		}
	} elsif ( /munmap\((\w+),/ ) {
		$v = $pid . $1;
		if ( defined( $maps{$v} )  ) {
			$currentSize -= $maps{$v};
			undef $maps{$v};
		}
	} elsif ( /brk\((\w+)\)\s*= (\w+)/ ) {
		$newTop = hex( $2 );
		if ( hex( $1 ) == 0 or !defined( $topOfData{$pid} ) ) {
			$topOfData{$pid} = $newTop;
		} else {
			$currentSize += $newTop - $topOfData{$pid};
			$topOfData{$pid} = $newTop;
		}
	} else {
		$error .= $_;
	}

	if ( int( ( $currentSize - $maxSize ) / 1048576 ) > 0 ) {
		$maxSize = $currentSize;
		printf( "\r%d MB", $maxSize / 1048576 );
	}
}
printf( "\r%d MB  \n", $maxSize / 1048576 ); 
close( PIPE );
if ( $? ) {
	print $error;
}

