use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::CommandRouter;

describe 'about Dashi::CommandRouter::route_active' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{mocks}       = mock "Dashi::CommandRouter" => (
            override => [
                setup => sub {
                    return 1;
                },
                active_commands => sub {
                    # DummyFoo and DummyBar are dummy classes
                    # Dashi::CommandRouter#route_active should return ClassName on Types::Standard. ClassName must have @ISA or $VERSION defined
                    $Dashi::Command::DummyFoo::VERSION = 0.01;
                    $Dashi::Command::DummyBar::VERSION = 0.01;
                    return +{
                        foo => 'Dashi::Command::DummyFoo',
                        bar => 'Dashi::Command::DummyBar',
                    };
                },
            ],
        );
    };

    describe 'Positive testing' => sub {
        describe 'case commands are exist' => sub {
            it 'should return class name' => sub {
                my $router = Dashi::CommandRouter->new();
                for my $command (qw/foo bar/) {
                    my $class_name = $router->route_active($command);
                    ok $class_name, $command;
                }
            };
        };

        describe 'case command is not exists' => sub {
            it 'should return undef' => sub {
                my $router = Dashi::CommandRouter->new();
                for my $command (qw/hoge fuga/) {
                    my $class_name = $router->route_active($command);
                    is $class_name, undef, $command;
                }
            };
        };
    };
};

done_testing;
