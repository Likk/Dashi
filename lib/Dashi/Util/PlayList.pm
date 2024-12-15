package Dashi::Util::PlayList;
use 5.40.0;
use utf8;

use Function::Parameters;
use Function::Return;
use List::Util;
use Types::Standard -types;

=head1 NAME

  Dashi::Util::PlayList

=head1 SYNOPSIS

  my $playlist = Dashi::Util::PlayList->new(
     playlist => [qw(music1 music2 music3)],
  )
  $playlist->pick;


=head1 PACKAGE GLOBAL VARIABLES

=over

=item B<PLAY_LIST>

  process list.

=cut

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

method new($class: %args) :Return(InstanceOf[Dashi::Util::PlayList]) {
    my $self = bless {%args}, $class;
    return $self;
}

=head1 METHODS

=head2 pick

  pick up one from playlist.

=cut

method pick() :Return(Str) {
    $self->playlist;
    $self->_shuffle;
    return shift @{ $self->{_playlist} };
}

=head2 playlist

  set playlist.

  Returns:
    ArrayRef[Str]

=cut

method playlist() :Return(ArrayRef[Str]) {

    my $playlist = $self->{playlist} || [];
    if(!$self->{_playlist} || scalar @{$self->{_playlist}} == 0) {
        $self->{_playlist} = [@$playlist]; #clone copy.
    }
    return $self->{_playlist};
}

=head1 PRIVATE METHODS

=head2 _shuffle

  shuffle playlist.

=cut

sub _shuffle {
     my $self = shift;
     $self->{_playlist} = [List::Util::shuffle @{ $self->playlist }];
}

1;
