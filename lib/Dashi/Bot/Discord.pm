package Dashi::Bot::Discord;
use 5.40.0;

use AnyEvent::Discord;
use Function::Parameters;
use Function::Return;

use Dashi::AnyEvent::Discord;
use Dashi::Bot::Discord::Ready;
use Dashi::Bot::Discord::MessageCreate;
use Dashi::Bot::Discord::MessageUpdate;

use Types::Standard -types;

=head1 NAME

  Dashi::Bot::Discord

=head1 DESCRIPTION

  Dashi::Bot::Discord is a discord bot starter.

=head1 SYNOPSIS

  my $bot = Dashi::Bot::Discord->new({
      token => $token,
  });
  $bot->run;

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  create and return a new discord bot object.

=cut

method new($class: %args) :Return(InstanceOf['Dashi::Bot::Discord']) {
    return bless {%args}, $class;
};

=head1 METHODS

=head2 run

  setup event handler and launch discord bot.

=cut

method run() {
    my $bot = AnyEvent::Discord->new({
        token   => $self->{token},
    });

    $bot->on('ready'          => \&Dashi::Bot::Discord::Ready::ready );
    $bot->on('message_create' => \&Dashi::Bot::Discord::MessageCreate::message_create );
    $bot->on('message_update' => \&Dashi::Bot::Discord::MessageUpdate::message_update );

    $bot->connect();
    AnyEvent->condvar->recv;

    return $bot;
};

=head1 SEE ALSO

L<AnyEvent::Discord>

=cut
