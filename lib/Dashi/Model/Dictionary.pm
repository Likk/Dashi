package Dashi::Model::Dictionary;
use 5.40.0;
use utf8;
use autodie;
use feature qw/try/;

use Encode;
use File::Temp qw/tempfile/;
use Function::Parameters;
use Function::Return;
use Storable   qw/lock_nstore lock_retrieve/;
use Text::CSV_XS;
use Types::Standard -types;

=head1 NAME

  Dashi::Model::Dictionary

=head1 DESCRIPTION

  Dashi::Model::Dictionary is key-word dictionary.

=head1 SYNOPSIS

  my $dictionary =  Dashi::Model::Dictionary->new({ file_name=> xxxx });
  $dictionary->set( foo => 'bar');
  print $dictionary->get('foo'); # bar

=head1 CONSTRUCTOR AND STARTUP METHODS

=head2 new

  Creates and returns a Item Object

=cut

method new($class: HashRef $opt) :Return(InstanceOf['Dashi::Model::Dictionary']) {
    die 'require file_name option. Dashi::Model::Dictionary->new({ file_name => xxxx })'
      unless $opt->{file_name};

    my $self = bless $opt, $class;
    $self->dictionaly_path($ENV{DICT_DIR} || './dict');
    return $self;
}

=head1 Accessor

=over

=item B<dictionaly_directory_path>

  dictionaly data file path.

=cut

method dictionaly_path(Str $path) :Return(Str){
    return $self->{dic_dir} ||= $path;
}


=back

=head1 METHODS

=head2 create_tsv_file

  create tsv file from dictionary.

=cut

method create_tsv_file() :Return(Str){
    my ($fh, $filename) = tempfile(SUFFIX => '.tsv', UNLINK => 0);
    my $tsv        = Text::CSV_XS->new(+{
        binary   => 1,
        sep_char => "\t",
        eol      => "\n",
    });

    my $dictionary = $self->_dictionary;
    for my $key (sort keys %$dictionary) {
        my $value = $dictionary->{$key};
        chomp $value;
        my $row = [$key, $value];
        $tsv->combine(@$row) or die $tsv->error_diag();
        $fh->print(Encode::encode_utf8($tsv->string()));
    }
    $fh->close;

    return $filename;
}

=head2 set

  set key-value data on dictionary.

=cut

method set(Str $key, Str $value) :Return(Bool){
    return false unless $key;
    return false unless $value;

    my $dictionary = $self->_dictionary;
    return false if exists $dictionary->{$key};

    $dictionary->{$key} = $value;
    lock_nstore($dictionary, $self->_file());
    return true;
}

=head2 overwrite

  overwrite key-value data on dictionary.

=cut

method overwrite(Str $key, Str $value) :Return(Bool){
    return false unless $key;
    return false unless $value;

    my $dictionary = $self->_dictionary;
    return false unless delete $dictionary->{$key};

    $dictionary->{$key} = $value;
    lock_nstore($dictionary, $self->_file());
    return true;
}

=head2 remove

 remove value from key on dictionary.

=cut

method remove(Str $key) :Return(Bool){
    return false unless $key;

    my $dictionary = $self->_dictionary;
    my $value = delete $dictionary->{$key};
    return false unless $value;

    lock_nstore($dictionary, $self->_file());
    return true;
}

=head2 get

  get value from key on dictionary.

=cut

method get(Str $key) :Return(Maybe[Str]){
    return undef unless $key;

    my $dictionary = $self->_dictionary;
    return undef unless exists $dictionary->{$key};
    return $dictionary->{$key};
}

=head2 move

  rename key on dictionary.

=cut

method move(Str $before, Str $after) :Return(Bool){
    return false unless $before;
    return false unless $after;

    my $dictionary = $self->_dictionary;
    my $value = delete $dictionary->{$before};
    return false unless $value;

    $dictionary->{$after} = $value;
    lock_nstore($dictionary, $self->_file());
    return true;
}

=head1 PRIVATE METHODS

=head2 _dictionary

  create or find dictionaly

=cut

sub _dictionary {
    my ($self) = @_;
    my $dictionary;
    try {
        my $file    = $self->_file;
        if(-s $file){
            $dictionary = lock_retrieve($file);
        }
        else {
            $dictionary = +{};
        }
    }
    catch ($e) {
        if($e =~ m{No such file or directory}){
            $dictionary = +{};
        }
        #TODO: not FileIO Error
    };

    return $dictionary;
}

=head2 _file

  create or find dictionaly file

=cut

sub _file {
    my ($self) = @_;
    my $file = sprintf("%s/%s", $self->{dic_dir} , $self->{file_name});
    unless (-e $file){
        open my $fh, '>', $file;
        close $fh;
    }
    return $file;
}

=head1 SEE ALSO

  L<Storable>

=cut
