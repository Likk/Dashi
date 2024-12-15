package Dummy::Command::ActiveFoo;
use v5.40;

sub command_type { 'active' }
sub command_list { [qw/foo/] }
