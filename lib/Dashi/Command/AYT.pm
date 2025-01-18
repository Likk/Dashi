package Dashi::Command::AYT;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Dashi::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver'],
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
};

=head1 NAME

  Dashi::Command::AYT - are you there.

=head1 DESCRIPTION

  Dashi::Command::AYT is ping for Dashi.

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) :Return(Str) {
    return 'fast_passive';
}

fun command_list(ClassName $class) :Return(ArrayRef[Str]) {
    return [qw/ayt/];
}

fun help(ClassName $class) :Return(Str) {
    return <<'EOT';
## /ayt - are you there.
this command is ping. like AYT command on telnet. its means 'are you there?'.
EOT
}

=head2 run

  Its main talking method.
  If you say 'Are You There?' to Dashi, Dashi will respond with '[yes]'.

=cut

fun run(ClassName $class, Dashi::Entity::CommunicationReceiver $receiver) :Return(Maybe[Dashi::Entity::CommunicationEmitter]) {
    my $message = $receiver->message;
    return undef unless $message;
    if ($message =~ m{^([/!])?(A(?:re)*|R)(?:\s*)(Y(?:ou)*|U)(?:\s*)T(?:here)?(?:\?)?$}i) {
        my $entity = Dashi::Entity::CommunicationEmitter->new();
        $entity->message('[yes]');
        return $entity;
    }
    return undef;
}

=head1 SEE ALSO

  Dashi

=cut
