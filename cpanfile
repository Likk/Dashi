# discrod bot Core.
requires 'AnyEvent::Discord';

# chat operations.
requires 'Furl';
requires 'Games::Dice';
requires 'JSON::XS';
requires 'List::Util';
requires 'String::Random';
requires 'Text::CSV_XS';

## util
requires 'Class::Singleton';
requires 'File::RotateLogs';
requires 'Function::Parameters';
requires 'Function::Return';
requires 'Types::Standard';
requires 'Log::Minimal';

## AnyEvent::Discord dependencys
requires 'LWP::Protocol::https';
requires 'Net::SSLeay';

on 'develop' => sub {
    requires 'Data::Dumper';
    requires 'YAML';
};

on 'test' => sub {
    requires 'App::ForkProve';
    # ./t layer
    requires 'Sub::Meta';
    # ./xt layer
    requires 'Test::More';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Test::Spelling';
};
