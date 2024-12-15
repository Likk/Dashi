use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationReceiver;
use Dashi::Command::Dice;

describe 'about Dashi::Command::Dice#run' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case no parametor' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => '',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when throws exception' => sub {
                my $throws = dies {
                    Dashi::Command::Dice->run();
                };

                like $throws, qr/Too few arguments for fun run/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case message is ""' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => '',
                    guild_id => 1,
                    username => 'test_dict_get',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns emoticon of 1d6 result' => sub {
                my $entity  = Dashi::Command::Dice->run($hash->{receiver});
                my $content = $entity->as_content;
                like $content, qr/[1⃣2⃣3⃣4⃣5⃣6⃣]/;
            };
        };
    };

};

done_testing();
