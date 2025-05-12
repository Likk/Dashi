package Dashi::Bot::Discord::Ready;
use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Dashi::Logger;
use Dashi::Util::Activity;

use Types::Standard -types;

use constant {
    "AnyEvent::Discord" => InstanceOf['AnyEvent::Discord'],
};

=encoding utf8

=head1 NAME

  Dashi::Bot::Discord::Ready

=head1 DESCRIPTION

  Dashi::Bot::Discord::Ready is a ready event handler of discord bot.
  this provides a function to update status of bot.


=head1 SYNOPSIS

  my $client = AnyEvent::Discord->new({
      token => $token,
  });
  $client->on('ready' => \&Dashi::Bot::Discord::Ready::ready);

=head1 METHODS

=head2 ready

  request update status to discord api server.

=cut

fun ready(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $logger     = $client->{logger};

    # setup activity
    my $playlist   = $client->{playlist}   || [];
    my $activities = $client->{activities} || [{}];
    push @$activities, map { +{
        name => $_,
        type => 0,
    } } @$playlist;

    my $activity = Dashi::Util::Activity->new(
        activities => $activities,
    );
    my $picked = $activity->pick;
    $logger->infof('Connected');
    try {

        $client->update_status({
            since      => time,
            status     => 'online',
            afk        => 'false',
            $picked ? (activities => [ $picked ]) : (),
        });
        return false;
    }
    catch ($e) {
        $logger->croakf('Failed to update status: %s', $e);
        return true;
    };
}

=head1 SEE ALSO

L<Dashi::Util::Activity>

=cut
