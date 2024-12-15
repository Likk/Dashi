use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Model::Dictionary;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Dashi::Model::Dictionary#new' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{file} = 'new.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};
    };

    after_all "cleanup"=> sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    describe 'Positive testing' => sub {
        describe 'case constructor' => sub {
            it 'when create new instance' => sub {
                my $dictionary = Dashi::Model::Dictionary->new(+{
                    file_name => $hash->{file}
                });
                isa_ok $dictionary, ['Dashi::Model::Dictionary'], 'create new instance';
            };
        };
    };
};

done_testing();
