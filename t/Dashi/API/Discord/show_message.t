use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warnings/;

use Furl::Response;
use Dashi::API::Discord;

describe 'about Dashi::API::Discord#show_message' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{invalid_channel_id} = 111;
        $hash->{invalid_message_id} = 1111;

        $hash->{valid_token}        = 'this_is_valid_token';
        $hash->{valid_channel_id}   = 999;
        $hash->{valid_message_id}   = 9999;
    };

    describe "Negative testing" => sub {
        describe "case token is invalid" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{invalid_token}, interval => 0);

                $hash->{mocks}->{furl} = mock "Furl" => (
                    override => [
                        request => sub {
                            Furl::Response->new(
                                1,
                                '401',
                                "Unauthorized",
                                +{
                                    'content-type' => 'application/json'
                                },
                                q|{"message": "401: Unauthorized", "code": 0}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};

            };

            it 'when return undef and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->show_message(
                        $hash->{valid_channel_id},
                        $hash->{valid_message_id}
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/401/;
                like $warnings->[1], qr/Unauthorized/;
            };
        };

        describe "case unknown message_id" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{mocks}->{furl} = mock "Furl" => (
                    override => [
                        request => sub {
                            Furl::Response->new(
                                1,
                                '404',
                                "Not Found",
                                +{
                                    'content-type' => 'application/json'
                                },
                                q|{"message": "Unknown Message", "code": 10008}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return undef and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->show_message(
                        $hash->{valid_channel_id},
                        000, # is not exists message_id
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/404/;
                like $warnings->[1], qr/Not Found/;
            };
        };

        describe "case unauthorized" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{mocks}->{furl} = mock "Furl" => (
                    override => [
                        request => sub {
                            Furl::Response->new(
                                1,
                                '403',
                                "Forbidden",
                                +{
                                    'content-type' => 'application/json'
                                },
                                q|{"message": "Missing Access", "code": 50001}}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return undef and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->show_message(
                        $hash->{invalid_channel_id},
                        $hash->{valid_message_id}
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/403/;
                like $warnings->[1], qr/Forbidden/;
            };
        };

        describe "case channel_id and message_id are not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->show_message();
                };
                like $throws, qr/Too few arguments for method show_message/;
            };
        };
        describe "case message_id is not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->show_message($hash->{valid_channel_id});
                };
                like $throws, qr/Too few arguments for method show_message/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "case channel_id is valid" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);
                $hash->{mocks}->{furl} = mock "Furl" => (
                    override => [
                        request => sub {
                            Furl::Response->new(
                                1,
                                '200',
                                "OK",
                                +{
                                    'content-type' => 'application/json'
                                },
                                q|{"content":"test message","mentions":[],"mention_roles":[],"attachments":[],"embeds":[],"flags":0,"components":[],"id":"9999","channel_id":"999","author":{"id":"333","username":"nick"}}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->show_message(
                    $hash->{valid_channel_id},
                    $hash->{valid_message_id}
                );
                is $res->{content},            'test message';
                is $res->{channel_id},         $hash->{valid_channel_id};
                is $res->{id},                 $hash->{valid_message_id};
                is $res->{author}->{id},       '333';
                is $res->{author}->{username}, 'nick';

            };
        };
    };
};

done_testing();
