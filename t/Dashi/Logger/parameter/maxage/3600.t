use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Logger;

describe 'about Dashi#logger' => sub {
    my $hash;

    describe 'when call method with maxage maxage' => sub {
        before_all "setup" => sub {
            $hash->{logger} = Dashi::Logger->new(
                maxage => 86400 # 1 day
            );
        };

        it 'should return Dashi::Logger instance' => sub {
            my $logger      = $hash->{logger};
            my $rotate_logs = $logger->{logger};
            isa_ok    $logger,                ['Dashi::Logger'],    'instance is Dashi::Logger';
            isa_ok    $rotate_logs,           ['File::RotateLogs'], 'logger is File::RotateLogs';
            is        $rotate_logs->{maxage}, 86400,                'maxage is 1 day';
        };
    };
};

done_testing();
