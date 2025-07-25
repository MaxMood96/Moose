package Moose::Exception::AttributeValueIsNotAnObject;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::Instance', 'Moose::Exception::Role::Attribute';

has 'method' => (
    is       => 'ro',
    isa      => 'Moose::Meta::Method::Delegation',
    required => 1,
);

has 'given_value' => (
    is       => 'ro',
    isa      => 'Any',
    required => 1,
);

sub _build_message {
    my $self = shift;
    "Cannot delegate ".$self->method->name." to "
    .$self->method->delegate_to_method." because the value of "
    . $self->attribute->name . " is not an object (got '".$self->given_value."')";
}

__PACKAGE__->meta->make_immutable;
1;
