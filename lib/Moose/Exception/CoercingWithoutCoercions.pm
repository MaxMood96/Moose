package Moose::Exception::CoercingWithoutCoercions;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::TypeConstraint';

sub _build_message {
    my $self = shift;
    "Cannot coerce without a type coercion";
}
1;
