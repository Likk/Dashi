package Dashi::Command::Choice;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use List::Util qw/shuffle/;
use Dashi::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver'],
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
};

=head1 NAME

  Dashi::Command::Place - random choice

=head1 DESCRIPTION

  Dashi::Command::Place is random sampling.

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) : Return(Str) {
    return 'active';
}

fun command_list(ClassName $class) : Return(ArrayRef[Str]) {
    return [qw/
        choice
        place
    /];
}

fun help(ClassName $class) : Return(Str) {
    return <<'EOT';
## /choice - random choice from list.
this command is random choice.
example: /choice alice,bob,carol,dave
EOT
}

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Dashi::Entity::CommunicationReceiver $receiver) :Return(Dashi::Entity::CommunicationEmitter) {
    my $message = $receiver->message;
    my $entity  = Dashi::Entity::CommunicationEmitter->new();

    $entity->message(
        List::Util::shuffle(split /[\s,]+/, $message) || '',
    );

    return $entity;
}
