use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Util::PlayList;

describe 'about Dashi::Util::PlayList' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{playlist} = Dashi::Util::PlayList->new(
                playlist => [qw/music1 music2 music3/],
            );
        };
        it 'should return Dashi::Util::PlayList instance' => sub {
            my $playlist = $hash->{playlist};
            isa_ok    $playlist, ['Dashi::Util::PlayList'], 'instance is Dashi::Util::PlayList';
        };

        it 'pick up a song' => sub {
            my $playlist = $hash->{playlist};
            ok $playlist->pick;
        };
    };
};

done_testing();
