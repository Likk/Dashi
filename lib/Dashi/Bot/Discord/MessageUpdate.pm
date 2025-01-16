package Dashi::Bot::Discord::MessageUpdate;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Dashi::API::Discord;
use Types::Standard -types;

use constant {
    "AnyEvent::Discord" => InstanceOf['AnyEvent::Discord'],
};

=encoding utf8

=head1 NAME

  Dashi::Bot::Discord::MessageUpdate

=head1 DESCRIPTION

  Dashi::Bot::Discord::MessageUpdate is a message update event handler of discord bot.
  this provides a function to message update.

=head1 SYNOPSIS

  my $client = AnyEvent::Discord->new({
      token => $token,
  });
  $client->on('message_update' => \&Dashi::Bot::Discord::MessageUpdate::message_update);

=head1 FUNCTIONS

=head2 message_update

  request send message on thread and join a thread to discord api server.

=cut

fun message_update(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $logger  = $client->{logger};
    my $discord = Dashi::API::Discord->new( token => $client->token );
    my $content = $data->{content};

    return false if $data->{author}->{bot};
    return _try_join_thread($discord, $data->{channel_id}, $data->{id}) if _is_thread($data);
    return false;
}

=head1 PRIVATE FUNCTIONS

=head2 _try_join_thread

  try join thread.

=cut

sub _try_join_thread {
    my ($discord, $channel_id, $message_id) = @_;

    # スレッド情報が取れたら取る
    my $message = $discord->show_message($channel_id, $message_id);
    return false unless $message->{thread}->{owner_id};

    # スレッドのあるチャンネルの情報が知りたい
    my $channel = $discord->show_channel($message->{channel_id});

    #チャンネル権限の設定がしてあったら閲覧者限定されてるので反応しない方がいい
    my $is_private = scalar @{ $channel->{permission_overwrites} };
    return false if $is_private;

    $discord->join_thread($message_id);
    return true;
}

=head2 _is_thread

  check thread.

=cut

sub _is_thread {
    my $data = shift;

    # XXX: スレッド作成は message_update で送られてくる。
    #      既存メッセージの更新がないのに、メッセージ更新でおくられくるもの、かつ flags が 32 (= has_thread )をスレッド作成として扱う
    return true if(
        $data->{flags}                 &&
        $data->{flags} == 32           &&
        !defined $data->{member}       &&
        !defined $data->{author}->{id} &&
        !defined $data->{content}
    );
    return false;
}
