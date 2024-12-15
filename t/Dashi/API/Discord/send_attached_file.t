use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warnings/;

use Furl::Response;
use Dashi::API::Discord;

describe 'about Dashi::API::Discord#send_attached_file' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{unknown_channel_id} = 000;
        $hash->{invalid_channel_id} = 111;
        $hash->{not_found_file}     = '__not_found_file.txt';

        $hash->{valid_token}      = 'this_is_valid_token';
        $hash->{valid_channel_id} = 999;
        $hash->{path}             = './t/Dashi/API/Discord/__attach_test_file.txt';
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

            it 'when return false and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{valid_channel_id},
                        $hash->{path}
                    );
                    is $res, false;
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
            it 'when return false and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{unknown_channel_id},
                        $hash->{path}
                    );
                    is $res, false;
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
            it 'when return false and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{invalid_channel_id},
                        $hash->{path}
                    );
                    is $res, false;
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
                    $hash->{api}->send_attached_file();
                };

                like $throws, qr/Too few arguments for method send_attached_file/;
            };
        };

        describe "case path is not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->send_attached_file($hash->{valid_channel_id});
                };
                like $throws, qr/Too few arguments for method send_attached_file/;
            };
        };

        describe "case path is not found" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Dashi::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->send_attached_file(
                        $hash->{valid_channel_id},
                        $hash->{not_found_file},
                    );
                };
                like $throws, qr/No such file or directory/;
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
                                q|{"content":"test_message","mentions":[],"attachments":[],"id":"1111","channel_id":"999","attachments":[{"id":"9999","filename":"attach_test_file.txt","size":26,"url":"https://cdn.example.com/attachments/999/9999/attach_test_file.txt?ex=hash&is=hash&","content_type":"text/plain; charset=utf-8","content_scan_version":0,"title":"__attach_test_file"}],"author":{"id":"9999","username":"nickname","public_flags":0,"flags":0,"bot":true}}|
                            );
                        },
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{mocks}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->send_attached_file(
                    $hash->{valid_channel_id},
                    $hash->{path}
                );
                is $res, 1;
            };
        };
    };
};

done_testing();
