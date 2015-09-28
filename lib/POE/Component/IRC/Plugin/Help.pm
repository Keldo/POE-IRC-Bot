package POE::Component::IRC::Plugin::Help;

use warnings;
use POE::Component::IRC::Plugin qw( PCI_EAT_NONE );

sub PCI_register {
my ( $self, $irc ) = @_;

$irc->plugin_register( $self, 'SERVER', qw( public ) );

POE::Session->create(
package_states => [
main => [ qw( S_public ) ],
],
);

return 1;
}

sub PCI_unregister {
my ( $self, $irc ) = @_;

return 1;
}

sub new {

    my $class = shift;
    my $self = {};
    return bless $self, $class;

}

 # Someone asked for help in a chan, return list.
sub S_public {

    my ( $self,$msg, $nick, $channel  ) = @_;
	if ( $msg =~ /!help/ ) {
		print "An error has occured if nothing goes to the channel";
		 $irc->yield( privmsg => $channel => "Hello $nick, Welcome to Help");
    	$irc->yield( privmsg => $channel => "Type NickServ to get assistance with the Nick Services");
    	$irc->yield( privmsg => $channel => "Type ChanServ to get assistance with the Channel Services");
    	$irc->yield( privmsg => $channel => "Type MemoServ to get assistance with the Memo Services");
    	$irc->yield( privmsg => $channel => "Type ChangeNick to get assistance with Changing Your Nick");
    }
    
    return;
}

1;