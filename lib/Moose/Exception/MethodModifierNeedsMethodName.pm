package Moose::Exception::MethodModifierNeedsMethodName;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Class';

sub _build_message {
    "You must pass in a method name";
}

__PACKAGE__->meta->make_immutable;
1;
