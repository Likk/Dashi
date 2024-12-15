use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warning/;

use Dashi::Logger;

describe 'about Dashi::Logger#warnf' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{mocks}  = mock "File::RotateLogs" => (
                override => [
                    print => sub { $hash->{log} = $_[1]; }
                ],
            );
        };
        it 'should return Dashi::Logger instance' => sub {
            my $warning = warning {
                Dashi::Logger->new->warnf('warn message');
            }; qr/warn message at .* line \d+/;
            my $log    = $hash->{log};
            like $warning, qr/warn message at .* line \d+/;
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[WARN\] warn message at .* line \d+\s\z/;
        };
    };
};

done_testing();
