use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warnings/;

use Furl::Response;
use Dashi::API::Discord;

describe 'about Dashi::API::Discord#create_thread' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{invalid_token}       = 'this_is_invalid_token';
        $hash->{unknown_channel_id}  = 000;
        $hash->{invalid_channel_id}  = 111;
        $hash->{invalid_thread_name} = '';

        $hash->{valid_token}       = 'this_is_valid_token';
        $hash->{valid_channel_id}  = 999;
        $hash->{valid_thread_name} = 'test_thread_name';
    };

    describe "Negative testing" => sub {
        describe "case token is not valid" => sub {
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
                    my $res = $hash->{api}->create_thread(
                        $hash->{valid_channel_id},
                        $hash->{valid_thread_name}
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/401/;
                like $warnings->[1], qr/Unauthorized/;
            };
        };

        describe "case unknown channel_id" => sub {
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
                                q|{"message": "Unknown Channel", "code": 10003}|
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
                    my $res = $hash->{api}->create_thread(
                        $hash->{unknown_channel_id},
                        $hash->{valid_thread_name}
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/404/;
                like $warnings->[1], qr/Not Found/;
            };
        };

        describe "case invalid channel_id" => sub {
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
                                q|{"message": "Missing Access", "code": 50001}|
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
                    my $res = $hash->{api}->create_thread(
                        $hash->{invalid_channel_id},
                        $hash->{valid_thread_name}
                    );
                    is $res, undef;
                };

                like $warnings->[0], qr/403/;
                like $warnings->[1], qr/Forbidden/;
            };
        };

        describe "case channel_id is not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->create_thread();
                };

                like $throws, qr/Too few arguments for method create_thread/;
            };
        };

        describe "case thread_name is not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->create_thread($hash->{valid_channel_id});
                };

                like $throws, qr/Too few arguments for method create_thread/;
            };
        };

        describe "case thread_name is invalid" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);
                $hash->{mocks}->{furl} = mock "Furl" => (
                    override => [
                        request => sub {
                            Furl::Response->new(
                                1,
                                '400',
                                "Bad Request",
                                +{
                                    'content-type' => 'application/json'
                                },
                                q|{"message": "Invalid Form Body", "code": 50035, "errors": {"name": {"_errors": [{"code": "BASE_TYPE_BAD_LENGTH", "message": "Must be between 1 and 100 in length."}]}}}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $warns = warnings {
                    $hash->{api}->create_thread(
                        $hash->{valid_channel_id},
                        $hash->{invalid_thread_name}
                    );
                };

                like $warns->[0], qr/400/;
                like $warns->[1], qr/Bad Request/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "case user_id is valid" => sub {
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
                                q|{"id":"99999","type":11,"guild_id":"99","name":"test_thread_name","thread_metadata":{"archived":false,"auto_archive_duration":60},"message_count":0,"member_count":1,"total_message_sent":0}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->create_thread(
                    $hash->{valid_channel_id},
                    $hash->{valid_thread_name}
                );
                is $res->{id},                                       99999;
                is $res->{type},                                     11;
                is $res->{guild_id},                                 99;
                is $res->{name},                                     'test_thread_name';
                is $res->{thread_metadata}->{archived},              \0;
                is $res->{thread_metadata}->{auto_archive_duration}, 60;
            };
        };
    };
};

done_testing();
