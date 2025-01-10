use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationEmitter::CreateThread;

describe 'about Dashi::Entity::CommunicationEmitter::CreateThread#new' => sub {
   my $hash;

   before_all "setup" => sub {
       $hash->{entity} = Dashi::Entity::CommunicationEmitter::CreateThread->new();
   };

   describe 'case call method' => sub {
        it 'should return Dashi::Entity::CommunicationEmitter::CreateThread instance' => sub {
            my $entity = $hash->{entity};
            isa_ok $entity, ['Dashi::Entity::CommunicationEmitter::CreateThread'], 'instance is Dashi::Entity::CommunicationEmitter::CreateThread';
        };
    };
};

done_testing();
