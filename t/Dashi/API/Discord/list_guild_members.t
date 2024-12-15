use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warnings/;

use Furl::Response;
use Dashi::API::Discord;

describe 'about Dashi::API::Discord#list_guild_members' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{invalid_token}    = 'this_is_invalid_token';
        $hash->{unknown_guild_id} = 000;
        $hash->{invalid_guild_id} = 111;

        $hash->{valid_token}    = 'this_is_valid_token';
        $hash->{valid_guild_id} = 999;
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
                        my $res = $hash->{api}->list_guild_members($hash->{valid_guild_id});
                    is $res, undef;
                };

                like $warnings->[0], qr/401/;
                like $warnings->[1], qr/Unauthorized/;
            };
        };

        describe "case unknown guild_id" => sub {
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
                                q|{"message": "Unknown Guild", "code": 10004}|
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
                    my $res = $hash->{api}->list_guild_members($hash->{unknown_guild_id});
                    is $res, undef;
                };

                like $warnings->[0], qr/404/;
                like $warnings->[1], qr/Not Found/;
            };
        };

        describe "case missing access" => sub {
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
                                q|{"message": "Unknown Guild", "code": 10004}|
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
                    my $res = $hash->{api}->list_guild_members($hash->{invalid_guild_id});
                    is $res, undef;
                };

                like $warnings->[0], qr/404/;
                like $warnings->[1], qr/Not Found/;
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
                    $hash->{api}->list_guild_members();
                };

                like $throws, qr/Too few arguments for method list_guild_members/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "case guild_id is valid" => sub {
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
                                q|[{"avatar": null,"nick": null,"pending": false,"user": {"id": "111","username": "name","bot": true}}]|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->list_guild_members($hash->{valid_guild_id});
                ref_ok $res, 'ARRAY';
                is $res->[0]->{user}->{id}, '111';
                is $res->[0]->{user}->{username}, 'name';
            };
        };
    };
};

done_testing();
