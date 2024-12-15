use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;
use Dashi::Model::Dictionary;
use Storable qw/retrieve/;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Dashi::Model::Dictionary#set' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{file} = 'set.dat';
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
                    $hash->{dictionary}->set();
                };
                like $throws, qr/Too few arguments for method set/, 'no parameter';
            };
        };
        describe 'case no key' => sub {
            it 'when return false' => sub {
                my $res =  $hash->{dictionary}->set('' => 'bar');
                is $res, false, 'no key';
            };
        };
        describe 'case no value' => sub {
            it 'when return false' => sub {
                my $res = $hash->{dictionary}->set('foo' => '');
                is $res, false, 'no value';
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case call set method' => sub {
            before_all "create dictionary" => sub {
                $hash->{currect} = $hash->{dictionary}->set('foo' => 'bar');
            };
            it 'when return true' => sub {
                my $res = $hash->{currect};
                is $res, true, 'set correct';
            };

            it 'when write file' => sub {
                my $table = retrieve(sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}));
                is $table->{foo}, 'bar', 'write file correct';
            };
        };

        describe 'case call set already exists key' => sub {
            before_all "create dictionary" => sub {
                $hash->{dictionary}->set('foo2' => 'bar');
            };
            it 'when dont overwrite' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->set('foo2' => 'bar2');
                is $res, false, 'already exists key';
            };
        };
    };
};

done_testing();
