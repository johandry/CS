#!/usr/bin/perl

#Title       : _NAME_.pl
#Date Created: _DATE_
#Last Edit   : _DATE_
#Author      : "Johandry Amador" < _EMAIL_ >
#Version     : 1.00
#Description : _DESCRIPTION_
#Usage       : _NAME_.pl [--help or -h] [--verbose] _USAGE_

# Requirements:
# _REQUIREMENT_ 

# General TODO's:
# _TODO_

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

# Global variables



# Options or script parameters handling section

our $VERSION=2.00;
my $verbose='';
my $help='';


#Getopt::Long::Configure ("bundling", "ignorecase_always");
GetOptions(
  'verbose'=>\$verbose,
  'help|?'=>\$help,
  
  ) or pod2usage(2);
pod2usage(1) if $help;

print STDERR "Parameters: \n\tVerbose: $verbose\n\tHelp: $help\n\t  \n" if $verbose;

# Subrutine code section


# Main code section


# Documentation pod section

__END__

=head1 NAME

_NAME_.pl - _DESCRIPTION_ 

=head1 SYNOPSIS

_NAME_.pl [--help or -h] [--verbose] _USAGE_

 Options:
   --help    or -h                         Brief help message
   --verbose                               Provide more information. Useful for debugging.


=head1 OPTIONS

=over 8

=item B<--help> or B<-h>

Print a brief help message and exits.

For more information enter: B<perldoc _NAME_.pl>

=item B<--verbose>

Print more information, useful for debugging purposes. 

The verbose output is sent to the Standar Error so you may send the verbose to a file using this at the end of the command: 2>delete.me



=back

=head1 DESCRIPTION

B<This program> _DESCRIPTION_.

B<Author>: "Johandry Amador" < _EMAIL_ >

=cut

