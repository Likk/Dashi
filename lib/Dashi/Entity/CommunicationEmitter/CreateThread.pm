package Dashi::Entity::CommunicationEmitter::CreateThread;
use 5.40.0;
use parent 'Dashi::Entity::CommunicationEmitter';

=head1 NAME

  Dashi::CommunicationEmitter::CreateThread;

=head1 DESCRIPTION

  Dashi::CommunicationEmitter::CreateThread is response entity for Start Thread API.

=head1 SYNOPSIS

  my $entity = Dashi::CommunicationEmitter::CreateThread->new(
    text => "xxxx",
  );
  $entity->title("title");

=head1 Accessor

=over

=item B<title>

  thread name.

=back

=cut

use Class::Accessor::Lite (
    new => 1,
    rw  => [qw/title/],
);
