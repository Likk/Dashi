package Dashi::Bot;

use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Dashi::Entity::CommunicationReceiver;
use Dashi::CommandRouter;

use Types::Standard -types;

use constant {
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver'],
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
    "Dashi::CommandRouter"                 => InstanceOf['Dashi::CommandRouter'],
};

=encoding utf8

=head1 NAME

  Dashi::Bot

=head1 DESCRIPTION

  Odeb bot is a main logic of chat bot.
  # チャットボットのクライアントシステムに依存しないロジックを記述する

=head1 SYNOPSIS

  use Dashi::Bot;
  my $res = $bot->talk($content, $guild_id, $username);

=head1 METHODS

=head2 talk

  talk method is a main logic of chat bot.
  It create a receiver object and route a command.
  It returns a emitter object.

  Args:
    Dashi::Entity::CommunicationReceiver

  Returns:
    Maybe[Str]|Dashi::Entity::CommunicationEmitter

=cut

method talk(
    Dashi::Entity::CommunicationReceiver $receiver,
    Dashi::CommandRouter                 $command_router = Dashi::CommandRouter->new()
    )
    :Return(Maybe[Str]|Dashi::Entity::CommunicationEmitter) {
    my $content        = $receiver->message;
    return undef unless $content;

    # Automatically responds to chat messages not starting with '/'.
    # Fas paassive commands take precedence over '/'-initiated commands
    my $fast_passive_commands = $command_router->fast_passive_commands;
    for my $command (@$fast_passive_commands){
        my $emitter = $command->run($receiver);
        return $emitter if $emitter;
    }

    # Responds to chat messages starting with '/'.
    my ($command, $message);
    if($content =~ m{\A/(?<command>\w+)(?:\s+(?<message>.*))?\z}){
        $command = $+{command} || '';
        $message = $+{message} || '';
        if(my $command = $command_router->route_active($command)){
            $receiver->message($message);
            my $emitter = $command->run($receiver);
            return $emitter if $emitter;
        }
    }

    # Automatically responds to chat messages not starting with '/'.
    # passive commands is lower priority than passive commands
    my $passive_commands = $command_router->passive_commands;
    for my $command (@$passive_commands){
        my $emitter = $command->run($receiver);
        return $emitter if $emitter;
    }

    return undef;
}
