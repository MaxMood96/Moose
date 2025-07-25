package Moose::Exception::CannotAddAdditionalTypeCoercionsToUnion;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';

has 'type_coercion_union_object' => (
    is       => 'ro',
    isa      => 'Moose::Meta::TypeCoercion::Union',
    required => 1
);

sub _build_message {
    return "Cannot add additional type coercions to Union types";
}

__PACKAGE__->meta->make_immutable;
1;
