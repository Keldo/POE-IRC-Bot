package Rictus::Bot;

use 5.016003;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Rictus::Bot ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Rictus::Bot - IRC Bot written in POE

=head1 SYNOPSIS

  use this bot to keep your channel open, serve as a helpful assistant if you are running your own server or as a base to learn how to write POE bots for IRC.

=head1 DESCRIPTION

Documentation for Rictus::Bot, this bot is still a work in process and will be updated frequenty after test are complete.
To use this bot
perl Makefile.PL
make
make install

Edit bot.cfg
Nick
Server
Password (If you have registered the bot's nick)

then launch the not
perl rictus.pl


=head2 EXPORT

None by default.

=head1 SEE ALSO

POE
POE::Component::IRC
Config::Simple
DateTime

www.twedev.com

=head1 AUTHOR

Scott Cilley<lt>scilley@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Scott Cilley

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
