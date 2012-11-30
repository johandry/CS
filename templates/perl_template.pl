#!/usr/bin/perl

#Title       : _NAME_.pl
#Date Created: _DATE_
#Last Edit   : _DATE_
#Author      : "Johandry Amador" < jamador@_EMAIL_.com >
#Version     : 1.00
#Description : _DESCRIPTION_
#Usage       : _NAME_.pl [--help|-h] [--verbose|-v] _USAGE_

# Requirements:
# _REQUIREMENT_
# _REQUIREMENT_

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
# use Log::Log4perl qw(:easy);

# Remove this section if Log module is installed
# BEGIN LOG SECTION
# Define a log file if needed. If not log will go to STDOUT and STDERR
my $LOG_FILE='';

# Subrutine to print a Debug message as Log4perl module is not available
# TODO: Print to STDERR and log file if defined.
sub DEBUG {
  print "@_\n";
}

# Subrutine to print an error message and exit as Log4perl module is not available
# TODO: Print to STDERR and log file if defined.
sub LOGDIE {
  print "@_\n";
  exit 1;
}

# Subrutine to print a message as Log4perl module is not available
# TODO: Print to log file if defined.
sub INFO {
  print "@_\n";
}
# END LOG SECTION

my $verbose='';
my $ip='';
my $help='';
# TODO: Define a VERSION variable to printed by default with the option --version
my $VERSION=2.00;

GetOptions('verbose'=>\$verbose, 'ip=s'=>\$ip, 'help|?'=>\$help) or pod2usage(2);
pod2usage(1) if $help;

# SUBRUTINE CODE SECTION

# MAIN CODE SECTION

# DOCUMENTATION POD SECTION

__END__

=head1 NAME

_NAME_.pl - _DESCRIPTION_

=head1 SYNOPSIS

_NAME_.pl [--help|-h] [--verbose|-v] _USAGE_

 Options:
   --help    | -h           Brief help message
   --verbose | -v           Provide mor information. Use it for debugging only.


=head1 OPTIONS

=over 8

=item B<--help> or B<-h>

Print a brief help message and exits.

For more information enter: B<perldoc _NAME_.pl>

=item B<--verbose> or B<-v>

Print more information ...

=back

=head1 DESCRIPTION

B<This program> will _DESCRIPTION_

=cut

