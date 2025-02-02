use 5.40.0;
use Test2::V0;
use Test::Perl::Critic;

Test::Perl::Critic->import( -profile => 'xt/perlcriticrc');
all_critic_ok('lib');
