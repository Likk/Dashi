package Dashi::Bot::Discord::MessageCreate;
use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Dashi::API::Discord;
use Dashi::Bot;
use Dashi::Entity::CommunicationReceiver;
use Dashi::Logger;

use Types::Standard -types;

use constant {
    "AnyEvent::Discord" => InstanceOf['AnyEvent::Discord'],
};

=encoding utf8

=head1 NAME

  Dashi::Bot::Discord::MessageCreate

=head1 DESCRIPTION

  Dashi::Bot::Discord::MessageCreate is a message create event handler of discord bot.
  this provides a function to response message.

=head1 SYNOPSIS

  my $client = AnyEvent::Discord->new({
      token => $token,
  });
  $client->on('message_create' => \&Dashi::Bot::Discord::MessageCreate::message_create);

=head1 METHODS

=head2 message_create

  request send message to discord api server.

=cut

fun message_create(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $logger = Dashi::Logger->new;
    my $api    = Dashi::API::Discord->new( token => $client->token );

    my $content = $data->{content};

    # bot には反応しない
    return false if $data->{author}->{bot};

    #TODO: thread
    my $channel_name = $client->channels->{$data->{channel_id}} || 'thread';

    my $message = sprintf("%s@%s: %s\n",
        $data->{author}->{username},
        $channel_name,
        $data->{content},
    );
    $logger->say(Encode::encode_utf8($message));

    my $receiver = Dashi::Entity::CommunicationReceiver->new(+{
        message  => $content,
        guild_id => $data->{guild_id},
        username => $data->{author}->{username},
        user_id  => $data->{author}->{id},
    });

    my $res = Dashi::Bot->talk($receiver);
    return false unless($res);

    # レスポンスが Dashi::Response::Dictionary の場合はファイルを添付して送信
    if($res->isa('Dashi::Entity::CommunicationEmitter::FileDownload')){
        my $filename = $res->filename;
        $api->send_attached_file($data->{channel_id}, $filename, 'dictionary.tsv');
    }
    # レスポンスが Dashi::Response::CommunicationEmitter の場合は as_content() が返信本文
    elsif($res->isa('Dashi::Entity::CommunicationEmitter')){
        return false if $res->is_empty;
        $client->send($data->{channel_id}, $res->as_content);
    }
    else { #型がなければ通常のテキスト返信
        $client->send($data->{channel_id}, $res) if $res
    }
    return true;
};

=head1 SEE ALSO

L<Dashi::Bot>,
L<Dashi::API::Discord>

=cut
