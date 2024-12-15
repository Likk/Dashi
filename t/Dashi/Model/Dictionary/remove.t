use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Model::Dictionary;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Dashi::Model::Dictionary#remove' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{file} = 'remove.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};

        my $dictionary = Dashi::Model::Dictionary->new(+{
            file_name => $hash->{file},
        });
        $hash->{dictionary} = $dictionary;
    };

    after_all "cleanup" => sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    describe 'Negative testing' => sub {
        describe 'case no parameter' => sub {
            it 'when no parameter' => sub {
                my $throws = dies {
                    $hash->{dictionary}->remove();
                };
                like $throws, qr/Too few arguments for method remove/, 'no parameter';
            };
        };
        describe 'case no key' => sub {
            it 'when return false' => sub {
                my $res =  $hash->{dictionary}->remove('');
                is $res, false, 'no key';
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case doesnt exist key' => sub {
            it 'when return false' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->remove('foo');
                is $res, false, 'cant remove';
            };
        };

        describe 'case already exists key' => sub {
            before_all "create dictionary" => sub {
                $hash->{dictionary}->set('foo2' => 'bar');
            };
            it 'when can remove' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->remove('foo2');

                is $res, true, 'remove correct';
                is $dictionary->get('foo2'), undef, 'remove correct';
            };
        };
    };
};

done_testing();
