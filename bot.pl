use strict;
use warnings;
use utf8;

use Config::Pit qw/pit_get/;
use Oden;

my $config = +{
    "token" => $ENV{DISCORD_TOKEN},
};

my $oden    = Oden->new(
    %$config,
);

$oden->start;

__END__

=encoding utf8

=head1 NAME

  bot.pl

=head1 SYNOPSIS

  ./env.sh perl bot.pl

=cut

=head1 SEE ALSO

  L<Oden>

=cut
