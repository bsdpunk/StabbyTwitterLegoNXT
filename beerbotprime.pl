use Sys::Hostname;
use strict;
use warnings;
use LEGO::NXT;
use LEGO::NXT::Constants qw(:DEFAULT);
use LEGO::NXT::MacBlueComm;
use Net::Twitter;
use Date::Format;
my $dev = new LEGO::NXT::MacBlueComm('/dev/tty.NXT-DevB');
my $bt = new LEGO::NXT( $dev );
my $speed = 100;
my $tachoticks = 360;
my $tailFtac = 100;
my $tailBtac = 100;
my $tailSpeed = 100;
my $tailBSpeed = 100;
my $backSpeed = 100;
my @names = ('New Tweet');
my $bob = "test";
my $tail = "tail";
my $retract = "retract";
my $say;

my $tweet = Net::Twitter->new( username=>'beerbotprime', password=>'insertyourpassword' );
print "logged in? \n";
my $last_id = undef;
my $switch = 0;

while(1){
 my @tt = ();

 if($last_id){
  @tt = $tweet->friends_timeline({count => 5, since_id => $last_id });
 }else{
  @tt = $tweet->friends_timeline({count => 5 });
 }

 foreach my $t (@{$tt[0]}){
  my $target = $t->{text};
  
  if($target =~ m/beerbotprime/i){
    $say = `say $'`;
    $bt->set_output_state( $NXT_NORET, $NXT_MOTOR_A, $speed, $NXT_MOTOR_ON|$NXT_REGULATED, $NXT_REGULATION_MODE_MOTOR_SPEED, 0, $NXT_MOTOR_RUN_STATE_RUNNING, $tachoticks );
    $bt->keep_alive($NXT_NORET);

   printf("%s: %s\n", $t->{user}{screen_name}, $t->{text});
   print "sleep 4\n";

   sleep(4);
  }

  $switch = 0;
  print "sleep 4\n";
  sleep(4);
 }
}
exit;
