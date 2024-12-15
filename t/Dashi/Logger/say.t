use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Logger;


describe 'about Dashi::Logger#say' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{mocks}  = mock "File::RotateLogs" => (
                override => [
                    print => sub { $hash->{log} = $_[1]; }
                ],
            );

            Dashi::Logger->new->say('say message');
        };
        it 'should logging message' => sub {
            my $log = $hash->{log};
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[SAY\] say message/;
        };
    };
};

done_testing();
