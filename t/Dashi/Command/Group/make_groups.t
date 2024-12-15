use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Command::Group;
use String::Random;

describe 'about Dashi::Command::Group#make_group' => sub {
    my $hash;

    # Negative testing
    describe 'Negative testing' => sub {
        describe 'case call make_group method without arguments' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    Dashi::Command::Group->make_groups();
                };

                like $throws, qr/Too few arguments for fun make_groups/;
            };
        };
        describe 'case call make_group method with 1 hash arguments' => sub {
            # size only
            tests 'where throws exception' => sub {
                {# size only
                    my $throws = dies {
                        Dashi::Command::Group->make_groups(
                            size => 2,
                        );
                    };

                    like $throws, qr/Too few arguments for fun make_groups/;
                }
                {# members only
                    my $throws = dies {
                        Dashi::Command::Group->make_groups(
                            members => ['foo', 'bar'],
                        );
                    };

                    like $throws, qr/Too few arguments for fun make_groups/;
                    qr/Too few arguments for fun make_groups/;
                }
            };
        };
        describe 'case members arugment is empty' => sub {
            it 'when returns empty array' => sub {
                my $res = Dashi::Command::Group->make_groups(
                    size    => 3,
                    members => [],
                );
                is $res, undef;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case call make_group method with 2 hashes arguments' => sub {
            describe 'case size equals or less than members' => sub {
                tests 'when returns array lenth equals size' => sub {
                    my $members = ['one', 'two', 'three', 'four', 'five', 'six', 'seven'];
                    for my $size (1..7){
                        my $res = Dashi::Command::Group->make_groups(
                            size    => $size,
                            members => $members,
                        );
                        is scalar @$res, $size;
                    }
                };
            };
            describe 'case size greater than members' => sub {
                tests 'when returns array lenth equals members' => sub {
                    my $members = ['one', 'two', 'three', 'four', 'five', 'six', 'seven'];
                    for my $size (8..10){
                        my $res = Dashi::Command::Group->make_groups(
                            size    => $size,
                            members => $members,
                        );
                        is scalar @$res, scalar @$members;
                    }
                };
            };

            describe 'cast members argument is ArrayRef[Str]' => sub {
                it "Everyone's been put into a group / with no duplicates" => sub {
                    for (1..10){
                        my $members = [map { String::Random->new->randregex("[A-Za-z]{3,10}") } 1..int(rand(10)) + 1];
                        my $res = Dashi::Command::Group->make_groups(
                            size    => 3,
                            members => $members,
                        );

                        for my $member (@$members){
                            my $found = 0;
                            for my $group (@$res){
                                $found++ if(grep { $_ eq $member } @$group);
                            }
                            is $found, 1;
                        }
                    }
                };
            };
        };
    };
};

done_testing();
