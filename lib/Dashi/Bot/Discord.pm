package Dashi::Bot::Discord;
use 5.40.0;

use AnyEvent::Discord;
use Function::Parameters;
use Function::Return;

use Dashi::AnyEvent::Discord;
use Dashi::Bot;
use Dashi::Bot::Discord::Ready;
use Dashi::Bot::Discord::MessageCreate;
use Dashi::Bot::Discord::MessageUpdate;
use Dashi::Logger;

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

=cut

use constant {
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver']
};

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
        token    => $self->{token},
        logger   => $self->{logger},
        playlist => $self->{playlist},
    });

    $bot->{talk}   = fun($receiver) { $self->_talk($receiver) };
    $bot->{logger} = $self->{logger};

    $bot->on('ready'          => \&Dashi::Bot::Discord::Ready::ready );
    $bot->on('message_create' => \&Dashi::Bot::Discord::MessageCreate::message_create );
    $bot->on('message_update' => \&Dashi::Bot::Discord::MessageUpdate::message_update );

    $bot->connect();
    AnyEvent->condvar->recv;

    return $bot;
};


=head1 PRIVATE METHODS

=head2 _talk

  shortcut of Dashi::Bot#talk
  if command_router is set, use it.

=cut

sub _talk {
    my $self     = shift;
    my $receiver = shift;
    my $command_router = $self->{di}->{command_router};
    return Dashi::Bot->talk(
        $receiver,
        ($command_router ? $command_router : ())
    );
}

=head1 SEE ALSO

L<AnyEvent::Discord>

=cut
