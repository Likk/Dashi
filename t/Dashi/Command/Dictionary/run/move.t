use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use File::Temp qw/tempdir/;
use Dashi::Entity::CommunicationReceiver;
use Dashi::Command::Dictionary;

local $ENV{DICT_DIR} = tempdir( CLEANUP => 1 );

describe 'about Dashi::Command::Dictionary#run' => sub {
    my $hash;

    describe 'message prefix `move`' => sub {
        # Negative testing
        describe 'case message pattern is `move` only. no key, no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'move',
                    guild_id => 1,
                    username => 'test_dict_move',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        describe 'case message pattern is `move <key>` only. no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'move foo',
                    guild_id => 1,
                    username => 'test_dict_move',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        # Positive testing
        describe 'case message pattern is `move <key> <value>`' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'move foo bar',
                    guild_id => 1,
                    username => 'test_dict_move',
                );
                $hash->{receiver} = $receiver;

            };
            describe 'case success' => sub {
                before_all "mockup Dashi::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Dashi::Model::Dictionary" => (
                        override => [
                            move => sub {
                                return 1;
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Dashi::Entity::CommunicationEmitter'], 'instance is Dashi::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'changed: foo => bar',                  'move key and value';
                };
            };
            describe 'case failure' => sub {
                before_all "mockup Dashi::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Dashi::Model::Dictionary" => (
                        override => [
                            move => sub {
                                return 0;
                            },
                        ],
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Dashi::Entity::CommunicationEmitter'], 'instance is Dashi::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'cant find foo',                        'failed to move key and value';
                };
            };
        };
    };

};

done_testing();
