use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Model::Dictionary;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Dashi::Model::Dictionary#create_tsv_file' => sub {
    my $hash;

    before_each "setup" => sub {
        $hash->{file} = 'create_tsv_file.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};

        my $dictionary = Dashi::Model::Dictionary->new(+{
            file_name => $hash->{file}
        });
        $hash->{dictionary} = $dictionary;
    };

    after_each "cleanup" => sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    describe 'Positive testing' => sub {
        describe 'case empty dictionary' => sub {
            it 'when create empty create_tsv_file' => sub {
                my $dictionary = $hash->{dictionary};
                my $filename = $dictionary->create_tsv_file();
                my $tsv = do {
                    local $/;
                    open my $fh, '<', $filename;
                    <$fh>
                };
                is $tsv, '', 'empty dictionary';
            };
        };
        describe 'case dictionary has key' => sub {
            it 'when create create_tsv_file' => sub {
                $hash->{dictionary}->set('foo' => 'bar');
                my $dictionary = $hash->{dictionary};
                my $filename = $dictionary->create_tsv_file();
                my $tsv = do {
                    local $/;
                    open my $fh, '<', $filename;
                    <$fh>
                };
                is $tsv, "foo\tbar\n", 'dictionary has key';
            };
        };
    };
};

done_testing();
