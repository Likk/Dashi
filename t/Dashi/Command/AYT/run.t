use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Command::AYT;
use Dashi::Entity::CommunicationReceiver;
use List::Util qw/shuffle/;
use String::Random;

describe 'about Dashi::Command::AYT#run' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case call run method without arguments' => sub {
            it 'when returns undef' => sub {
                my $throws = dies {
                    Dashi::Command::AYT->run();
                };
                like $throws, qr/Too few arguments for fun run/;
            };
        };
    };

    describe 'Positive testing' => sub {
        before_all "setup" => sub {
            my $create_ayt = sub {
                my $are_part = [ # A,R,Are
                    String::Random->new->randregex("[Rr]"),
                    String::Random->new->randregex("[Aa]"),
                    String::Random->new->randregex("[Aa][Rr][Ee]"),
                ];

                my $you_part = [ # Y,U,You
                    String::Random->new->randregex("[Yy]"),
                    String::Random->new->randregex("[Uu]"),
                    String::Random->new->randregex("[Yy][Oo][Uu]"),
                ];

                my $there_part = [ # T,There
                    String::Random->new->randregex("[Tt]"),
                    String::Random->new->randregex("[Tt][Hh][Ee][Rr][Ee]"),
                ];

                my $ayt = sprintf("%s %s %s",
                    [List::Util::shuffle @$are_part  ]->[0],
                    [List::Util::shuffle @$you_part  ]->[0],
                    [List::Util::shuffle @$there_part]->[0],
                );
                return $ayt
            };
            $hash->{create_ayt} = $create_ayt
        };

        describe 'case call run method with "Are You There?"' => sub {

            it 'when returns "[yes]"' => sub {
                for(1..10){
                    my $talk = $hash->{create_ayt}();
                    my $reciever = Dashi::Entity::CommunicationReceiver->new(
                        message  => $talk,
                        guild_id => 1,
                        username => 'test',
                    );
                    my $res = Dashi::Command::AYT->run($reciever);
                    isa_ok $res, ['Dashi::Entity::CommunicationEmitter'];
                    is $res->as_content, "[yes]";
                }
            };
        };
    };
};

done_testing;
