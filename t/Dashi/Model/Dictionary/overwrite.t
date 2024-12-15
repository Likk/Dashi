use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Model::Dictionary;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Dashi::Model::Dictionary#overwrite' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{file} = 'overwrite.dat';
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
                    $hash->{dictionary}->overwrite();
                };
                like $throws, qr/Too few arguments for method overwrite/, 'no parameter';
            };
        };
        describe 'case no key' => sub {
            it 'when return false' => sub {
                my $res =  $hash->{dictionary}->overwrite('' => 'bar');
                is $res, false, 'no key';
            };
        };
        describe 'case no value' => sub {
            it 'when return false' => sub {
                my $res = $hash->{dictionary}->overwrite('foo' => '');
                is $res, false, 'no value';
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case doesnt exist key' => sub {
            it 'when return false' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->overwrite('foo' => 'bar');
                is $res, false, 'cant overwrite';
            };
        };

        describe 'case already exists key' => sub {
            before_all "create dictionary" => sub {
                $hash->{dictionary}->set('foo2' => 'bar');
            };
            it 'when dont overwrite' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->overwrite('foo2' => 'bar2');
                is $res, true, 'overwrite correct';
            };
        };
    };
};

done_testing();
