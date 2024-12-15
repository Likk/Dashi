use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Logger;

describe 'about Dashi#logger' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{logger} = Dashi::Logger->new;
        };
        it 'should return Dashi::Logger instance' => sub {
            my $logger = $hash->{logger};
            isa_ok    $logger,          ['Dashi::Logger'],           'instance is Dashi::Logger';
            is        refaddr($logger), refaddr(Dashi::Logger->new), 'Dashi::Logger is singleton';
        };
    };
};

done_testing();
