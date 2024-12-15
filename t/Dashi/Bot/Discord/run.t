use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Bot::Discord;

describe 'about Dashi::Bot::Discord#run' => sub {
    my $hash = {};

    before_all setup => sub {
        $hash->{mocks} =+{
            connect => mock("AnyEvent::WebSocket::Client" => (
                override => [
                    connect => sub {
                        $hash->{called}->{connect} = 1;
                        return AE::cv;
                    },
                ],
            )),
            recv    =>  mock("AnyEvent::CondVar" => (
                override => [
                    recv => sub {
                        $hash->{called}->{recv} = 1;
                    },
                ],
            )),
        };
    };

    describe 'when call run method' => sub {
        before_all create_bot_instance => sub {
            my $discord_bot = Dashi::Bot::Discord->new(token => 'your token');
            $hash->{bot}    = $discord_bot->run();

        };
        it 'return AnyEvent::Discord instance that has events and connect' => sub {
            my $bot       = $hash->{bot};
            my $events    = $bot->_events;

            is $hash->{called}->{connect}, 1, 'called AnyEvent::WebSocket::Client#connect';
            is $hash->{called}->{recv},    1, 'called AnyEvent#condvar';

            my $message_create = Sub::Meta->new(sub => $events->{message_create}->[0]);
            my $message_update = Sub::Meta->new(sub => $events->{message_update}->[0]);
            my $ready          = Sub::Meta->new(sub => $events->{ready}->[0]         );

            is $message_create->fullname, 'Dashi::Bot::Discord::MessageCreate::message_create';
            is $message_update->fullname, 'Dashi::Bot::Discord::MessageUpdate::message_update';
            is $ready->fullname,          'Dashi::Bot::Discord::Ready::ready';
        };
    };
};

done_testing();
