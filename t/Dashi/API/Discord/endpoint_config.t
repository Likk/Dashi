use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::API::Discord;

describe 'about Dashi::API::Discord#endpoint_config' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{discord} = Dashi::API::Discord->new(token => 'dummy');
    };

    describe "call endpoint_config method" => sub {
        it 'will return endpoint list' => sub {
            my $discord   = $hash->{discord};
            my $endpoints = $discord->endpoint_config();

            ref_ok $endpoints, 'HASH';
            is $endpoints, +{
                show_message       => 'https://discord.com/api/v10/channels/%s/messages/%s',
                show_channel       => 'https://discord.com/api/v10/channels/%s',
                show_user          => 'https://discord.com/api/v10/users/%s',
                list_guild_members => 'https://discord.com/api/v10/guilds/%s/members',
            }, 'return endpoint list';
        };
    };
};

done_testing();
