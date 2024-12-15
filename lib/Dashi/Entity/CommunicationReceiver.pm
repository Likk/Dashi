package Dashi::Entity::CommunicationReceiver;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Types::Standard -types;

=head1 NAME

  Dashi::Entity::CommunicationReceiver

=head1 DESCRIPTION

  Dashi::Entity::CommunicationReceiver is a class designed to capture and process incoming data from Discord message_create event.

=head1 SYNOPSIS

  my $receiver = Dashi::Entity::CommunicationReceiver->new(+{
    message => 'Are You There?',
    guild_id => 1234567890,
    username => 'yournick',
  };

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new CommunicationReceiver object.

  Args:
    HashRef:
      message  => Str
      guild_id => Int
      username => Str
      user_id  => Int

=head1 Accessor

=over

=item B<message>

  This accessor represents a line of dialogue from a sender, which is used to generate a response.

=item B<guild_id>

  This accessor represents the unique identifier of the guild where the message was sent.

=item B<username>

  This accessor represents the username of the sender of the message.

=item B<user_id>

  This accessor represents the user'id of the sender of the message.

=back

=cut

use Class::Accessor::Lite (
    new => 1,
    rw  => [qw/message guild_id username user_id/],
);
