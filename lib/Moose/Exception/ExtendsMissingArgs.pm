package Moose::Exception::ExtendsMissingArgs;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class';

sub _build_message {
    "Must derive at least one class";
}

__PACKAGE__->meta->make_immutable;
1;
