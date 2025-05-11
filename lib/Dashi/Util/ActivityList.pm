package Dashi::Util::ActivityList;
use 5.40.0;
use utf8;

use Function::Parameters;
use Function::Return;
use List::Util;
use Types::Standard -types;

=head1 NAME

  Dashi::Util::ActivityList

=head1 SYNOPSIS

  my $ActivityList = Dashi::Util::ActivityList->new(
    activities =>[
        { name => 'playing',   type => 0 },
        { name => 'streaming', type => 1 },
        { name => 'listening', type => 2 },
        { name => 'watching',  type => 3 },
  )
  $ActivityList->pick;


=head1 PACKAGE GLOBAL VARIABLES

=over

=item B<PLAY_LIST>

  process list.

=back

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

method new($class: %args) :Return(InstanceOf[Dashi::Util::ActivityList]) {
    my $self = bless {%args}, $class;
    return $self;
}

=head1 METHODS

=head2 pick

  pick up one from ActivityList.

=cut

method pick() :Return(Str) {
    $self->ActivityList;
    $self->_shuffle;
    return shift @{ $self->{_ActivityList} };
}

=head2 ActivityList

  set ActivityList.

  Returns:
    ArrayRef[HashRef]

=cut

method ActivityList() :Return(ArrayRef[Str]) {

    my $ActivityList = $self->{ActivityList} || [];
    if(!$self->{_ActivityList} || scalar @{$self->{_ActivityList}} == 0) {
        $self->{_ActivityList} = [@$ActivityList]; #clone copy.
    }
    return $self->{_ActivityList};
}

=head1 PRIVATE METHODS

=head2 _shuffle

  shuffle ActivityList.

=cut

sub _shuffle {
     my $self = shift;
     $self->{_ActivityList} = [List::Util::shuffle @{ $self->ActivityList }];
}

1;
