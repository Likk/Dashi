use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::API::Discord;

describe 'about Dashi::API::Discord#new' => sub {
    my $hash;

    describe "Negative testing" => sub {
        describe "token parameter is not set" => sub {
            it 'throw exception' => sub {
                my $throws = dies {
                    Dashi::API::Discord->new()
                };
                like $throws, qr/require token parameter/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "token parameter is set" => sub {
            before_all "create Dashi::API::Discord object"  => sub {
                $hash->{api} = Dashi::API::Discord->new(token => 'dummy');
            };
            it 'return Dashi::API::Discord object' => sub {
                my $api = $hash->{api};
                isa_ok $api, ['Dashi::API::Discord'];
            };
            it 'object has default hash' => sub {
                my $api = $hash->{api};
                is   $api->{base_url}, 'https://discord.com/api/v10';
                like $api->{last_req}, qr/\d+/;
                is   $api->{interval}, 1;
            };
        };
    };
};

done_testing();
