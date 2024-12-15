use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::CommandRouter;

describe 'about Dashi::CommandRouter::new' => sub {
    my $hash;

    before_all "setup" => sub {
        my $expect = 0;
        $hash->{expect} = $expect;
    };

    describe 'Positive testing' => sub {
        describe 'case call constructor' => sub {
            before_all "setup" => sub {
                $hash->{mocks} = mock "Dashi::CommandRouter" => (
                    override => [
                        # update expect value if called setup by new
                        setup => sub {
                            my $caller = [caller(1)];
                            my $method = $caller->[3];
                            $hash->{expect} = 1 if ($method eq 'Dashi::CommandRouter::new');
                        },
                    ],
                );
                $hash->{router} = Dashi::CommandRouter->new();
            };

            it 'should return instance' => sub {
                my $router = $hash->{router};
                isa_ok $router, 'Dashi::CommandRouter';
            };

            it 'should call setup' => sub {
                is $hash->{expect}, 1, 'called setup';
            };
        };
    };
};

done_testing;
