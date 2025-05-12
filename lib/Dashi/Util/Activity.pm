package Dashi::Util::Activity;
use 5.40.0;
use utf8;

use Clone qw(clone);
use Function::Parameters;
use Function::Return;
use List::Util qw/sample/;
use Types::Standard -types;

use Class::Accessor::Lite (
    rw  => [qw/activities/],
);

=head1 NAME

  Dashi::Util::Activities

=head1 SYNOPSIS

  my $Activities = Dashi::Util::Activity->new(
    activities => [
        { name => 'playing',   type => 0 },
        { name => 'streaming', type => 1 },
        { name => 'listening', type => 2 },
        { name => 'watching',  type => 3 },
        { name => 'custom',    type => 4 },
        { name => 'competing', type => 5 },
    ],
    # or
    activity => +{
        name => 'playing',
        type => 0,
    },
  )
  $Activities->pick;

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

method new($class: %args) :Return(InstanceOf[Dashi::Util::Activity]) {
    my $self = bless {}, $class;
    $self->activities($args{activities}) if $args{activities};
    $self->activities([$args{activity}])  if $args{activity};
    return $self;
}

=head1 ACCESSORS

=head2 activities

  set Activities.

  Returns:
    ArrayRef[HashRef]

=cut

=head1 METHODS

=head2 pick

  pick up one from Activities.

=cut

method pick() :Return(HashRef) {
    return sample( 1, @{ $self->activities });
}

1;
