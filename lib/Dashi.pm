package Dashi;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Dashi::Bot::Discord;

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

=cut

method new(%args) :Return(InstanceOf['Dashi']) {
    return bless {%args}, $self;
};

=head1 METHODS

=head2 start

  launch discord chat bot.

=cut

method start() {
    my $bot = Dashi::Bot::Discord->new(
        token => $self->{token},
    );
    $bot->run();
}

=head1 LICENSE

Copyright (C) Likkradyus.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Likkradyus Winston. E<lt>perl {at} li {dot} que {dot} jpE<gt>

=cut
