use Sys::Hostname;
use strict;
use warnings;
use LEGO::NXT;
use LEGO::NXT::Constants qw(:DEFAULT);
use LEGO::NXT::MacBlueComm;
use Mac::Growl ':all';
use Net::Twitter;
use Date::Format;
my $capsule = int(rand(99));
my $dev = new LEGO::NXT::MacBlueComm('/dev/tty.NXT-DevB-1');
my $bt = new LEGO::NXT( $dev );
my $speed = 100;
my $tachoticks = 1000;
my $tailFtac = 1000;
my $tailBtac = 1000;
my $tailSpeed = 100;
my $tailBSpeed = -100;
my $backSpeed = -100;
my $app = 'Growl/Twitter';
my @names = ('New Tweet');
my $bob = "test";
my $tail = "tail";
my $retract = "retract";
RegisterNotifications($app, \@names, [$names[0]]);

my $tweet = Net::Twitter->new( username=>'twitrnxtbot', password=>'password' );

my $last_id = undef;
my $switch = 0;

while(1)
{
    my @tt = ();

    if($last_id)
    {
        @tt = $tweet->friends_timeline({count => 5, since_id => $last_id });
    }
    else
    {
        @tt = $tweet->friends_timeline({count => 5 });
    }

    foreach my $t (@{$tt[0]})
    {
        my $target = $t->{text};
        if($target =~ m/$tail/i){
            $bt->set_output_state( $NXT_NORET, $NXT_MOTOR_A, $tailSpeed, $NXT_MOTOR_ON|$NXT_REGULATED, $NXT_REGULATION_MODE_MOTOR_SPEED, 0, $NXT_MOTOR_RUN_STATE_RUNNING, $tailFtac );
        }elsif($target =~ m/$retract/i) {
            $bt->set_output_state( $NXT_NORET, $NXT_MOTOR_A, $tailBSpeed, $NXT_MOTOR_ON|$NXT_REGULATED, $NXT_REGULATION_MODE_MOTOR_SPEED, 0, $NXT_MOTOR_RUN_STATE_RUNNING, $tailBtac );
        }
        else 
        {
            print $target;
            $bt->set_output_state( $NXT_NORET, $NXT_MOTOR_B, $speed, $NXT_MOTOR_ON|$NXT_REGULATED, $NXT_REGULATION_MODE_MOTOR_SPEED, 0, $NXT_MOTOR_RUN_STATE_RUNNING, $tachoticks );
            $bt->set_output_state( $NXT_NORET, $NXT_MOTOR_C, $speed, $NXT_MOTOR_ON|$NXT_REGULATED, $NXT_REGULATION_MODE_MOTOR_SPEED, 0, $NXT_MOTOR_RUN_STATE_RUNNING, $tachoticks );
            $bt->keep_alive($NXT_NORET);
        }
        PostNotification($app, $names[0], $t->{user}{screen_name}, $t->{text});

        printf("%s: %s\n", $t->{user}{screen_name}, $t->{text});
        print "sleep 4\n";

        sleep(4);
    }

    $switch = 0;
    print "sleep 4\n";
    sleep(4);
}

exit;


