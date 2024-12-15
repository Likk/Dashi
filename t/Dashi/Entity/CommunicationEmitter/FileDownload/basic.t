use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Dashi::Entity::CommunicationEmitter::FileDownload;

describe 'about Dashi::Entity::CommunicationEmitter::FileDownload#new' => sub {
   my $hash;

   before_all "setup" => sub {
       $hash->{entity} = Dashi::Entity::CommunicationEmitter::FileDownload->new();
   };

   describe 'case call method' => sub {
        it 'should return Dashi::Entity::CommunicationEmitter::FileDownload instance' => sub {
            my $entity = $hash->{entity};
            isa_ok $entity, ['Dashi::Entity::CommunicationEmitter::FileDownload'], 'instance is Dashi::Entity::CommunicationEmitter::FileDownload';
        };
    };
};

done_testing();
