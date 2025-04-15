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
            my $logger      = $hash->{logger};
            my $rotate_logs = $logger->{logger};
            isa_ok    $logger,          ['Dashi::Logger'],                                'instance is Dashi::Logger';
            isa_ok    $rotate_logs,     ['File::RotateLogs'],                             'logger is File::RotateLogs';
            is        refaddr($logger), refaddr(Dashi::Logger->new),                      'Dashi::Logger is singleton';
            is        $rotate_logs->{logfile}, '/var/log/dashi/bot/%Y/%m/%Y%m%d%H%M.log', 'default path_pattern';
            is        $rotate_logs->{linkname},     '/var/log/dashi/bot/log',             'default linkname';
            is        $rotate_logs->{maxage},       604800,                               'default maxage';
        };
    };
};

done_testing();
