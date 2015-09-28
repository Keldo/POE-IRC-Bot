package POE::Component::IRC::Plugin::Rictus;

BEGIN {
  $POE::Component::IRC::Plugin::Rictus::AUTHORITY = 'cpan:SCILLEY';
}
{
  $POE::Component::IRC::Plugin::VERSION = '0.01';
}

use strict;
use warnings FATAL => 'all';  

# TODO
# Add database functionality ie: DBI
# SVN Announcements in channel
# Pasetbot functionality
# Server Control Functionality (IE: Control services)
# Keep history
# Track users  birthdays, etc & commit to database (DBI)
# Authorization and Control
# Twitter Capability ( Read Tweats for users and channel owner, announce them in channel)

# Our Current Version
our $VERSION = '0.01';

# Our current Revision
our $REVISION = '14';

use base 'Exporter';
use DateTime;
use Data::Dumper;
use Config::Simple;
use HTTP::Request;
use LWP::UserAgent;
use LWP::Simple;
use POE qw( Component::IRC::Plugin::IRCDHelp);


my @methods = qw(
				_start irc_join irc_part irc_public
				load_lib
);
#handle_feed init_session
our @EXPORT = @methods;

my $cfg = new Config::Simple();
$cfg->read('bot.cfg');

# Set the owner and trusted users
my $owner = $cfg->param('owner.boss');
my $trusted = $cfg->param('trusted.users');
  
# Load the proper modules
use POE qw(
	Component::IRC
	Component::IRC::State
	Component::IRC::Plugin::AutoJoin
	Component::IRC::Plugin::Logger
	Component::IRC::Plugin::FollowTail
);

sub run {
	  
# Create the session and list what subs will be used
POE::Session->create( package_states => [ main => \@methods ], );
$poe_kernel->run();
}

 # so that it is accessable outside of the PoCo::IRC
 my $irc;

 
 #############################################################################
 # Event handler for _start
 # Start the bot and connect to the IRC Server
 # NOTE: debug is set to 1 for development purposes, change to 0 to turn it off
 ##############################################################################
 sub _start {
         $irc = POE::Component::IRC::State->spawn(
         debug => 1,
         nick   => $cfg->param('bot.nick'),
         realname => $cfg->param('bot.realname'),
         ircname => $cfg->param('bot.ircname'),
         ident => $cfg->param('bot.ident'),
         username => $cfg->param('bot.username'),
         Server => $cfg->param('servers.server'),
         plugin_debug => 1,
         options => { trace => 0 },
  ) or die "Oh noooo! $!";

     # Load the Plugins
     $irc->plugin_add('AutoJoin', POE::Component::IRC::Plugin::AutoJoin->new(
        Channels => [ $cfg->param('channels.channels') ],
        
        # Rejoin on kick with delay
        RejoinOnKick => 1, # enable rejoin
		Rejoin_delay => 7, # delay for a bit (seconds)
		)
	);
	
	$irc->yield( register => qw(join) );
	$irc->yield( connect  => {} );
          
     $irc->plugin_add('Logger', POE::Component::IRC::Plugin::Logger->new(
     Path    => 'logs',
     DCC     => 0,
     Private => 0,
     Public  => 1,
     Sort_by_date => 1,
     )
     );
     
     # make the logs directory writable
     # If you are on windows, comment the next two lines
     my $logdir = 'logs';
     #system "chmod -R 755 $logdir";
     
	$irc->plugin_add('Help', POE::Component::IRC::Plugin::IRCDHelp->new());
     
     # bots password from config
     my $password = $cfg->param('bot.password');
     
     # Identify with NickServ
     $irc->yield('privmsg', 'nickserv', "identify $password");
     
     return;
 }
 
 # Joining and Identifying
  sub irc_join {
     my $nick = (split /!/, $_[ARG0])[0];
     my $channel = $_[ARG1];
     my $me =  $cfg->param('bot.nick');
     #my $birthday = DateTime->new( year => 2009, month => 5, day => 10, );
     my $dt = DateTime->now;
     # Need to script a yearly check here to announce the projects birthday in channel
     my $day = DateTime->today;
 	
     # only send this message is we are the one joining
     if ( $nick eq $irc->nick_name() ) {
	     $irc->yield( privmsg => $channel => "Hello everyone, I am $nick, the Channel Control bot..  (v $VERSION) revision $REVISION");
	     $irc->yield('privmsg', 'chanserv', "op $channel $me");
 	 }
 	 else {
 	 # Check to see if the owner logged in, if so, and owner is not op'd, do so
 	 # as long as I have +O in channel
 	 if ( $nick eq $owner ) {
	 	 # op the boss
	 	 $irc->yield('privmsg', 'chanserv', "op $channel $owner");
     }
     
     # Templated for future use
     # Idea is for trusted users to be OP'd in the channel automatically
     if ( $nick eq $trusted ) {
	     $irc->yield('privmsg', 'chanserv', "op $channel $trusted");
 	}
 	else {
 	
 	$irc->yield(privmsg => $channel, "Hello $nick, welcome to $channel! Please type !help if you require assistance.");
	}
 	 
     # Set the bot to an away status, mandatory for Rictus on the TweDev network
     $irc->yield(away => "saving humanity, one person at a time");

     return;
 	}

}
 
#######
# event handler for public
#######
sub irc_public {
	my ($kernel, $who, $where, $msg) = @_[KERNEL, ARG0, ARG1, ARG2];
	my $nick    = (split /!/, $who)[0];
    my $channel = $where->[0];
    
    if ( $msg =~ m/^!uptime$/i ) {

        my $time = sprintf( "%d Days, %02d:%02d:%02d",
            ( gmtime( time() - $^T ) )[ 7, 2, 1, 0 ] );
        $irc->yield(privmsg => $channel => "I've been up for $time" );

    }
    
    # Display server time when asked
    # Displays Day Month date Time (hr:mn:sec) year
    if ( $msg =~ m/^!time$/i ) {
	    my $stime = scalar(localtime);
		    $irc->yield( privmsg => $channel => "The time at my server is currently $stime");
	}
    
    # Shutting the bot down
    if ( $msg =~ m/^!die$/i ) {
	    if ( $nick =~ /$owner/) {
		    $irc->yield( shutdown => "Requested Quit by $nick.");
		}
		else {
			$irc->yield( privmsg => $channel => "$nick, You are not authorized to use this command!");
			$irc->yield( privmsg => $owner => "$owner, $nick just trying giving me the die command..");
		}
	}
	
	# TODO
	# messages
	# svn Commit
	# Announcing Email
	# handle rss 
	# Twitter
	
    return;
}


 
 # Says goodbye to a user who logs out
sub irc_part {
    my $nick = ( split /!/, $_[ARG0])[0];
    my $channel = $_[ARG1];
    my $irc = $_[SENDER]->get_heap();
    
    $irc->yield( privmsg => $nick => "Goodbye $nick, please visit us again soon!" );
}

1;