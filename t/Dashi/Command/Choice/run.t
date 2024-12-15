use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationReceiver;
use Dashi::Command::Choice;

describe 'about Dashi::Command::Choice#run' => sub {
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
                    Dashi::Command::Choice->run();
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
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity  = Dashi::Command::Choice->run($hash->{receiver});
                is $entity->is_empty, 1;
            };
        };
        describe 'case message is "a b c"' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'a b c',
                    guild_id => 1,
                    username => 'test',
                );
                $hash->{receiver} = $receiver;
            };

            tests 'when returns entity' => sub {
                for(1..10){
                    my $entity  = Dashi::Command::Choice->run($hash->{receiver});
                    my $content = $entity->as_content;
                    like $content, qr/\A[abc]\z/;
                }
            };
        };
    };

};

done_testing();
