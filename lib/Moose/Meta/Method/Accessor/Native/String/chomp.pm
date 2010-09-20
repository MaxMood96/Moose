package Moose::Meta::Method::Accessor::Native::String::chomp;

use strict;
use warnings;

our $VERSION = '1.13';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';

use base 'Moose::Meta::Method::Accessor::Native::String::Writer';

sub _minimum_arguments { 0 }
sub _maximum_arguments { 0 }

sub _potential_value {
    my ( $self, $slot_access ) = @_;

    return "( do { my \$val = $slot_access; chomp \$val; \$val } )";
}

sub _inline_set_new_value {
    my ( $self, $inv, $new ) = @_;

    return $self->SUPER::_inline_set_new_value(@_)
        if $self->_value_needs_copy;

    my $slot_access = $self->_inline_get($inv);

    return "chomp ${slot_access}";
}

1;