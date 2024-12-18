package Dashi;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Dashi::Bot::Discord;
use Dashi::Logger;
use Types::Standard -types;

=head1 NAME

  Dashi

=head1 DESCRIPTION

  Dashi is chat bot client on discord.

=head1 SYNOPSIS

  use Dashi;
  my $oden = Dashi->new(token => 'your token');
  $oden->start();

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

  Args:
    # Required
    token:  Str
    # Optional
    di:     Hash
      command_router: Dashi::CommandRouter
    logger: Hash
      path:   Str

=cut

method new($class: %args) :Return(InstanceOf['Dashi']){
    my $self = bless {%args}, $class;
    $self->_setup_logger();
    return $self;
};

=head1 METHODS

=head2 start

  launch discord chat bot.

=cut

method start() {
    my $bot = Dashi::Bot::Discord->new(
        token  => $self->{token},
        logger => $self->{logger},
        di     => $self->{di},
    );
    $bot->run();
}

=head1 PRIVATE METHODS

=head2 _setup_logger

  create and return a new logger object.

=cut

sub _setup_logger {
    my $self = shift;
    my $logger = Dashi::Logger->new(
        path_pattern => delete $self->{logger}->{path_pattern},
        linkname     => delete $self->{logger}->{linkname},
    );
    $self->{logger} = $logger;
}

=head1 LICENSE

Copyright (C) Likkradyus.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Likkradyus Winston. E<lt>perl {at} li {dot} que {dot} jpE<gt>

=cut
