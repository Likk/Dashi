package Dashi::Bot::Discord::MessageUpdate;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Dashi::API::Discord;
use Dashi::Bot;
use Dashi::Logger;

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

=head1 METHODS

=head2 message_update

  request send message on thread and join a thread to discord api server.

=cut

fun message_update(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $logger  = $client->{logger};
    my $discord = Dashi::API::Discord->new( token => $client->token );
    my $content = $data->{content};

    return false if $data->{author}->{bot};
    # XXX: スレッド作成は message_update で送られてくる。
    #      既存メッセージの更新がないのに、メッセージ更新でおくられくるもの、かつ flags が 32 (= has_thread )をスレッド作成として扱う
    if( $data->{flags}                 &&
        $data->{flags} == 32           &&
        !defined $data->{member}       &&
        !defined $data->{author}->{id} &&
        !defined $data->{content}
    ){
        # スレッド情報が取れたら取る
        my $message      = $discord->show_message($data->{channel_id}, $data->{id});
        return false unless $message->{thread}->{owner_id};

        # スレッドのあるチャンネルの情報が知りたい
        my $channel    = $discord->show_channel($message->{channel_id});

        ##チャンネル権限の設定がしてあったら閲覧者限定されてるので反応しない方がいい
        my $is_private = scalar @{ $channel->{permission_overwrites} };
        return false if $is_private;

        # スレッドは誰が作ったのか知りたい
        my $owner        = $discord->show_user($message->{thread}->{owner_id});
        return false unless $owner->{username};

        my $res = sprintf("`%s` create thread `%s` in `%s` =>  https://discord.com/channels/%s/%s\n",
            # who, what, when.
            $owner->{username},
            $message->{thread}->{name},
            $client->channels->{$data->{channel_id}},

            # url
            $message->{thread}->{guild_id},
            $data->{id},
        );

        my $post_channel_id = $data->{channel_id};

        $client->send($post_channel_id, $res) if $res;
        $discord->join_thread($data->{id});
        return true;
    }
    else {
        return false;
    }
}

