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

    describe 'message prefix `rename`' => sub {
        # Negative testing
        describe 'case message pattern is `rename` only. no key, no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'rename',
                    guild_id => 1,
                    username => 'test_dict_rename',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        describe 'case message pattern is `rename <key>` only. no value' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'rename foo',
                    guild_id => 1,
                    username => 'test_dict_rename',
                );
                $hash->{receiver} = $receiver;
            };

            it 'when returns empty entity' => sub {
                my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                is $entity->is_empty, 1, 'empty';
            };
        };

        # Positive testing
        describe 'case message pattern is `rename <key> <value>`' => sub {
            before_all "setup CommunicationReceiver" => sub {
                my $receiver = Dashi::Entity::CommunicationReceiver->new(
                    message  => 'rename foo bar',
                    guild_id => 1,
                    username => 'test_dict_rename',
                );
                $hash->{receiver} = $receiver;

            };
            describe 'case success' => sub {
                before_all "mockup Dashi::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Dashi::Model::Dictionary" => (
                        override => [
                            move => sub {
                                return 1;
                            }
                        ]
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Dashi::Entity::CommunicationEmitter'], 'instance is Dashi::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'changed: foo => bar',                  'rename key and value';
                };
            };
            describe 'case failure' => sub {
                before_all "mockup Dashi::Model::Dictionary" => sub {
                    $hash->{mock}->{dict} = mock "Dashi::Model::Dictionary" => (
                        override => [
                            'move' => sub {
                                return 0;
                            }
                        ]
                    );
                };

                it 'when returns undef' => sub {
                    my $entity = Dashi::Command::Dictionary->run($hash->{receiver});
                    isa_ok $entity,             ['Dashi::Entity::CommunicationEmitter'], 'instance is Dashi::Entity::CommunicationEmitter';
                    is     $entity->as_content, 'cant find foo',                        'failed to rename key and value';
                };
            };
        };
    };

};

done_testing();
