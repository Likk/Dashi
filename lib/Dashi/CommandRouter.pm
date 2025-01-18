package Dashi::CommandRouter;
use 5.40.0;
use builtin qw(load_module);
no warnings 'experimental::builtin';

use Function::Parameters;
use Function::Return;
use Module::Pluggable::Object;
use Types::Standard -types;

use constant {
    "Dashi::Entity::CommunicationEmitter" => InstanceOf['Dashi::Entity::CommunicationEmitter'],
};

=encoding utf8

=head1 NAME

  Dashi::Dispatcher

=head1 DESCRIPTION

  Dashi::Dispatcher is a class designed to dispatch commands to the appropriate class.

=head1 SYNOPSIS

  my $dispatcher = Dashi::Dispatcher->new();
  my $class      = $dispatcher->dispatch('itemsearch');
  # $class is Dashi::Command::ItemSearch

=cut

=head1 Accessors

=cut

use Class::Accessor::Lite (
    rw  => [qw/
        command_search_path
        fast_passive_commands
        passive_commands
        active_commands
        help_list
    /],
);

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  create and return a new router object.

=cut

method new($class: %args) :Return(InstanceOf['Dashi::CommandRouter']) {
    my $self = bless { %args }, $class;
    $self->setup();
    return $self;
}

=head2 setup

  Load all the classes in the Dashi::Command namespace and register the command name.

=cut

method setup() :Return(Bool) {
    my $command_search_path = $self->command_search_path || ['Dashi::Command'];
    my $pluggable = Module::Pluggable::Object->new(
        search_path => $command_search_path,
    );
    my $plguins = [$pluggable->plugins];
    for my $package (@$plguins) {
        load_module($package);

        my $command_type =  $package->command_type();
        my $command_list =  $package->command_list();

        # fast passive commands
        if($command_type eq 'fast_passive'){
            my $route_fast_passive = $self->fast_passive_commands() || [];
            push @$route_fast_passive, $package;
            $self->fast_passive_commands($route_fast_passive);
        }

        # passive commands
        if($command_type eq 'passive'){
            my $route_passive = $self->passive_commands() || [];
            push @$route_passive, $package;
            $self->passive_commands($route_passive);
        }

        # active commands
        for my $command (@$command_list) {
            my $command_router = $self->active_commands() || +{};
            $command_router->{$command} = $package;
            $self->active_commands($command_router);
        }

        try {
            my $help_list = $self->help_list() || [];
            push @$help_list, $package->help();
            $self->help_list($help_list);
        }
        catch ($e) {
            # no implementation of help method
        };
    }
    return 1;
}

=head1 CLASS METHODS

=head2 route_active

  route_active method returns the class name that corresponds to the command name.

=cut

method route_active(Str $command) :Return(Maybe[ClassName]) {
    my $active_commands = $self->active_commands || +{};
    my $package         = $active_commands->{$command};
    return undef unless $package;
    return $package;
}

=head2 show_help

  show_help method returns the help message.

=cut

method show_help() :Return(Dashi::Entity::CommunicationEmitter) {
    my $emitter = Dashi::Entity::CommunicationEmitter->new(
        message => join("\n", @{$self->help_list}),
    );
    return $emitter;
}
