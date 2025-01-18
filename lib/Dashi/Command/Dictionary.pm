package Dashi::Command::Dictionary;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Dashi::Model::Dictionary;
use Dashi::Entity::CommunicationEmitter;
use Dashi::Entity::CommunicationEmitter::FileDownload;

use Types::Standard -types;

use constant {
    "Dashi"                                => InstanceOf['Dashi'],
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver'],
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
};

=head1 NAME

  Dashi::Command::Dictionary

=head1 DESCRIPTION

  Dashi::Command::Dictionary

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) :Return(Str) {
    return 'active';
}

fun command_list(ClassName $class) :Return(ArrayRef[Str]) {
    return [qw/dict/];
}

fun help(ClassName $class) :Return(Str) {
    return <<'EOT';
## /dict - dictionary
this command is dictionary.
### /dict add key value
add key and value to dictionary.
example: /dict add foo bar
### /dict overwrite key value
overwrite key and value to dictionary.
example: /dict overwrite foo baz
### /dict get key
get value from dictionary.
example: /dict get foo
### /dict delete key
delete key from dictionary.
example: /dict delete foo
### /dict rename before after
rename key from dictionary.
example: /dict rename foo bar
### /dict file
download dictionary as tsv file.
example: /dict file
EOT
}

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Dashi::Entity::CommunicationReceiver $receiver) :Return(Maybe[Dashi::Entity::CommunicationEmitter]) {
    my $hear     = $receiver->message;
    my $guild_id = $receiver->guild_id;
    return undef unless $hear;

    my $dict = Dashi::Model::Dictionary->new({ file_name => $guild_id});

    if($hear =~ m{\Afile\z}){
        my $filename = $dict->create_tsv_file();
        my $entity = Dashi::Entity::CommunicationEmitter::FileDownload->new(+{
            filename    => $filename,
        });
        return $entity;
    }

    my $entity = Dashi::Entity::CommunicationEmitter->new;
    if($hear =~ m{\A(?:rename|move)\s+(.*)\s+(.*)}){
        my $before = $1;
        my $after  = $2;
        my $res = $dict->move($before, $after);
        $entity->message(
            $res ? sprintf("changed: %s => %s", $before, $after)
                 : sprintf("cant find %s", $before)
        );
    }
    elsif($hear =~ m{\A(?:get|show)\s+(.+)}){
        my $key    = $1;
        my $res = $dict->get($key);
        $entity->message(
            $res ? $res
                 : 'not registrated'
        );
    }
    elsif($hear =~ m{\A(?:add|set)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(add|set)\s+$key\s*}{};
        my $res = $dict->set($key => $value);
        $entity->message(
            $res ? 'registrated'
                 : 'the key already exists'
        );
    }
    elsif($hear =~ m{\A(?:overwrite)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(overwrite)\s+$key\s*}{};
        my $res = $dict->overwrite($key => $value);
        $entity->message(
            $res ? 'overwrote'
                 : 'not registrated'
        );
    }
    elsif($hear =~ m{\A(?:delete|remove)\s+(.+)}){
        my $key    = $1;
        my $res = $dict->remove($key);
        $entity->message(
            $res ? 'removed'
                 : 'not registrated'
        );
    }

    return $entity;
}
