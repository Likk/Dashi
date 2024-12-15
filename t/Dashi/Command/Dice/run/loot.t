use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationReceiver;
use Dashi::Command::Dice;

describe 'about Dashi::Command::Dice#run' => sub {
    my $hash;

    describe 'case message is "loot"' => sub {
        before_all "setup CommunicationReceiver"=> sub {
            my $receiver = Dashi::Entity::CommunicationReceiver->new(
                message  => 'loot',
                guild_id => 1,
                username => 'test',
            );
            $hash->{receiver} = $receiver;
        };

        tests 'when returns 1to99 result' => sub {
            for (1..100){
                my $entity  = Dashi::Command::Dice->run($hash->{receiver});
                my $content = $entity->as_content;
                my ($loot, $mention) = split /\s/, $content;
                like $loot,       qr/\d{1,2}/;
                is   $loot <= 99, 1;
                is   $loot >= 1,  1;
                is   $mention,    '@test';
            }
        };
    };

};

done_testing();
