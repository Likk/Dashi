use 5.40.0;
use autodie;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Model::Dictionary;

local $ENV{DICT_DIR} = './t/Dashi/Model/Dictionary/data/';

describe 'about Dashi::Model::Dictionary#get' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{file} = 'get.dat';
         my $dictionary = Dashi::Model::Dictionary->new(+{
              file_name => $hash->{file},
          });
        $hash->{dictionary} = $dictionary;
    };

    describe 'Negative testing' => sub {
        describe 'case no parameter' => sub {
            it 'when no parameter' => sub {
                my $throws = dies {
                    $hash->{dictionary}->get();
                };
                like $throws, qr/Too few arguments for method get/, 'no parameter';
            };
        };
        describe 'case no key' => sub {
            it 'when return undef' => sub {
                my $res =  $hash->{dictionary}->get('');
                is $res, undef, 'no key';
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case call get that doesnt exist' => sub {

            it 'when get undef' => sub {
                my $dictionary = $hash->{dictionary};

                my $res = $dictionary->get('bar');
                is $res, undef, 'get undef';
            };
        };

        describe 'case call get that exist' => sub {

            it 'when get value' => sub {
                my $dictionary = $hash->{dictionary};

                my $res = $dictionary->get('hoge');
                is $res, 'fuga', 'get value';
            };
        };
    };
};

done_testing();
