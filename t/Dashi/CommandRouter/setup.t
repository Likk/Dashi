use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use lib 't/lib'; # Dummy::Command::* classes are in t/lib
use Dashi::CommandRouter;

describe 'about Dashi::CommandRouter#setup' => sub {
    my $hash;

    before_all "setup" => sub {
        my $expect = 0;
    };

    describe 'Negative testing' => sub {
        describe 'case call constructor without empty array ref' => sub {
            before_all "setup" => sub {
                $hash->{router} = Dashi::CommandRouter->new(
                    command_search_path => [],
                );
            };

            it 'should return instance' => sub {
                my $router = $hash->{router};
                isa_ok $router, 'Dashi::CommandRouter';
            };

            it 'should fast_passive_commands is undef' => sub {
                my $router = $hash->{router};
                my $fast_passive_commands = $router->fast_passive_commands;
                is $fast_passive_commands, undef;
            };

            it 'should active_commands is undef' => sub {
                my $router = $hash->{router};
                my $active_commands = $router->active_commands;
                is $active_commands, undef;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case call constructor with command_search_path' => sub {
            before_all "setup" => sub {
                $hash->{router} = Dashi::CommandRouter->new(
                    command_search_path => ['Dummy::Command'],
                );
            };

            it 'should return instance' => sub {
                my $router = $hash->{router};
                isa_ok $router, 'Dashi::CommandRouter';
            };

            it 'should fast_passive_commands are ARRAY' => sub {
                my $router = $hash->{router};
                my $fast_passive_commands = $router->fast_passive_commands;
                ref_ok $fast_passive_commands, 'ARRAY';

                for my $package (@$fast_passive_commands) {
                    like $package, qr/\ADummy::Command::[A-Z][A-Za-z0-9]+\z/, $package;
                };
            };

            it 'should active_commands are HASH' => sub {
                my $router = $hash->{router};
                my $active_commands = $router->active_commands;
                ref_ok $active_commands, 'HASH';

                for my ($slash_command, $package) (%$active_commands) {
                    like $package, qr/\ADummy::Command::[A-Z][A-Za-z0-9]+\z/, $package;
                }
            };
        };
    };
};

done_testing;
