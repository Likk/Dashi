use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi;

describe 'about Dashi#start' => sub {
    my $hash;

    describe 'when call start method' => sub {
        before_all "setup" => sub {
            $hash->{oden} = Dashi->new(token => 'your token');

            $hash->{mocks} = mock "Dashi::Bot::Discord" => (
                override => [
                    run => sub { 'called Dashi::Bot::Discord#run' },
                ],
            );
        };

        it 'should execute Dashi::Bot::Discord#run' => sub {
            my $oden = $hash->{oden};
            isa_ok    $oden,          ['Dashi'],                        'instance is Dashi';
            is        $oden->{token}, 'your token',                    'token is your token';
            is        $oden->start(), 'called Dashi::Bot::Discord#run', 'called Dashi::Bot::Discord#run';
        };

    };
};

done_testing();
