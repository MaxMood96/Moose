package Moose::Exception::CoercionNeedsTypeConstraint;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::InvalidAttributeOptions';

sub _build_message {
    my $self = shift;
    "You cannot have coercion without specifying a type constraint on attribute (".$self->attribute_name.")";
}

__PACKAGE__->meta->make_immutable;
1;
