use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Logger;

describe 'about Dashi::Logger#infof' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{mocks}  = mock "File::RotateLogs" => (
                override => [
                    print => sub { $hash->{log} = $_[1]; }
                ],
            );

            Dashi::Logger->new->infof('info message');
        };
        it 'should return Dashi::Logger instance' => sub {
            my $log    = $hash->{log};
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[INFO\] info message at .* line \d+\s\z/;
        };
    };
};

done_testing();
