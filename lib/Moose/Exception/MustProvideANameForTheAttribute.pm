package Moose::Exception::MustProvideANameForTheAttribute;
our $VERSION = '2.4001';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::ParamsHash';

has 'class' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    "You must provide a name for the attribute";
}

__PACKAGE__->meta->make_immutable;
1;
