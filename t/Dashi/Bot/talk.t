use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Bot;
use Dashi::Entity::CommunicationEmitter;
use Dashi::Entity::CommunicationReceiver;

describe 'about Dashi::Bot#talk' => sub {
    my $hash = {};

    describe 'Negative testing' => sub {
        describe 'when parameter is not set' => sub {
            it 'should exception' => sub {
                my $throw = dies {
                    Dashi::Bot->talk;
                };
                like $throw, qr/Too few arguments for method talk/;
            };
        };
        describe 'when arguments is not Dashi::Entity::CommunicationReceiver' => sub {
            it 'should exception (undef)' => sub {
                my $throw = dies {
                    Dashi::Bot->talk(undef);
                };
                like $throw, qr/did not pass type constraint \(not isa Dashi::Entity::CommunicationReceiver\)/;
            };

            it 'should exception (Str)' => sub {
                my $throw = dies {
                    Dashi::Bot->talk('content');
                };
                like $throw, qr/did not pass type constraint \(not isa Dashi::Entity::CommunicationReceiver\)/;
            };

            it 'should exception (Other Object)' => sub {
                my $throw = dies {
                    Dashi::Bot->talk(Dashi::Entity::CommunicationEmitter->new);
                };
                like $throw, qr/did not pass type constraint \(not isa Dashi::Entity::CommunicationReceiver\)/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'when parameter is set' => sub {
            describe 'when message is ""' => sub {
                it 'should return undef' => sub {
                    my $entity = Dashi::Entity::CommunicationReceiver->new(
                        message => '',
                        guild_id => 1,
                        username => 'username',
                    );
                    my $res = Dashi::Bot->talk($entity);
                    is $res, undef, 'no response';
                };
            };
            describe 'when content is "slashCommand"' => sub {
                before_all 'create mock' => sub {
                    $hash->{mock} = +{
                        command_router =>  mock("Dashi::CommandRouter" => (
                            override => [
                                setup => sub {
                                    return 1;
                                },
                                route_active => sub {
                                    return 'Dashi::Command::Dummy';
                                },
                            ]
                        )),
                        command_dummy => mock("Dashi::Command::Dummy" => (
                            add => [
                                run => sub {
                                    return 'response SlashCommand';
                                },
                            ]
                        )),
                    };
                };
                it 'should return response' => sub {
                    my $entity = Dashi::Entity::CommunicationReceiver->new(
                        message => '/Dummy',
                        guild_id => 1,
                        username => 'username',
                    );
                    my $res = Dashi::Bot->talk($entity);
                    is $res, 'response SlashCommand', 'response is "response SlashCommand"';
                };
            };
        };
    };
};

done_testing;
