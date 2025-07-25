package Moose::Exception::MetaclassMustBeASubclassOfMooseMetaClass;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class';

sub _build_message {
    my $self = shift;
    "The Metaclass ".$self->class_name." must be a subclass of Moose::Meta::Class."
}

__PACKAGE__->meta->make_immutable;
1;
