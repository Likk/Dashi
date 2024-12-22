package Dashi::AnyEvent::Discord;
# TODO: moops#class requires 5.14.0
# How about send a patch to the author?
# or Inheritance AnyEvent::Discord and add methods,
# or not using "use Moops;".
use 5.14.0;
use strict;
use warnings;
use Moops;

=head1 NAME

  Dashi::AnyEvent::Discord

=head1 DESCRIPTION

  Dashi::AnyEvent::Discord is a AnyEvent::Discord monkey patch for discord api v9.

=head1 SYNOPSIS

  use Dashi::AnyEvent::Discord;
  my $bot = Dashi::AnyEvent->new({
      token => $token,
  });

=head1 Overwrite or additional methods

=head2 AnyEvent::Discord::update_status

  send "Presence Update" to discord API.

=head2 AnyEvent::Discord::_discord_identify

  patch for _discord_identify method.
  v9 API requires `intents` parameter.

=head2 AnyEvent::Discord::_lookup_gateway

  patch for _lookup_gateway method.
  using discord API v9.

=head1 SEE ALSO

  L<AnyEvent::Discord>
  L<https://discord.com/developers/docs/reference>

=cut

class AnyEvent::Discord 0.7 {

    #XXX: `no warnings 'redefine'` is not working from Kavorka::Sub#L80
    local $SIG{__WARN__} = sub {
    my $message = shift;
        return if $message =~ /AnyEvent::Discord::_discord_identify redefined/;
        return if $message =~ /AnyEvent::Discord::_lookup_gateway redefined/;
    };

    use AnyEvent::Discord::Payload;

    has intents => (
        is => 'rw',
        isa => Item,
        default => 1<<0 | 1<<9, # GUILDS, GUILD_MESSAGES
        trigger => sub {
            my ($self, $val) = @_;
            return $self->{intents} = $val || 1<<0 | 1<<9;
        },
    );
    has api_version => (
        is => 'rw',
        isa => Maybe[Int],
        default => 6,
        trigger => sub {
            my ($self, $val) = @_;
            return $self->{api_version} = $val || 6;
        },
    );

    method update_status(HashRef $data,) {

        $data->{since }     ||= time;
        $data->{status}     ||= 'online';
        $data->{afk}        ||= 'false';
        $data->{activities} ||= [];

        $self->_ws_send_payload(AnyEvent::Discord::Payload->from_hashref({
          op => 3,
          d  => $data,
        }));

    }

    method _discord_identify() {
      $self->_debug('Sending identify');
      $self->_ws_send_payload(AnyEvent::Discord::Payload->from_hashref({
        op => 2,
        d  => {
          token           => $self->token,
          properties => {
            'os'      => 'linux',
            'browser' => $self->user_agent(),
            'device'  => $self->user_agent(),
          },

          compress        => JSON::false,
          large_threshold => 250,
          shard           => [0, 1],

          # TODO: enhance at an `Event::Discord#new` parameter.
          #intents    => 1<<0|1<<1|1<<9|1<<11,
          # intents => 1<<0 | 1<<1 | 1<<8 | 1<<9 | 1<<11,
          intents => $self->intents,
        }
      }));
    }

    method _lookup_gateway() {
      my $payload = $self->_discord_api('GET', 'gateway');
      die 'Invalid gateway returned by API' unless ($payload and $payload->{url} and $payload->{url} =~ /^wss/);

      # Add the requested version and encoding to the provided URL
      my $gateway = $payload->{url};
      $gateway .= '/' unless ($gateway =~/\/$/);
      $gateway .= sprintf('?v=%d&encoding=json', $self->api_version);
      warn $gateway;
      return $gateway;
    }
};

1;
