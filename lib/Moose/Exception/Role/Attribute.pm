package Moose::Exception::Role::Attribute;
our $VERSION = '2.4001';

use Moose::Role;

has 'attribute' => (
    is        => 'ro',
    isa       => 'Class::MOP::Attribute',
    predicate => 'is_attribute_set'
);

1;
