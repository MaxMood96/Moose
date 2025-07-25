package Moose::Meta::Method::Accessor::Native::Array::first;
our $VERSION = '2.4001';

use strict;
use warnings;

use List::Util ();
use Params::Util ();

use Moose::Role;

with 'Moose::Meta::Method::Accessor::Native::Reader';

sub _minimum_arguments { 1 }

sub _maximum_arguments { 1 }

sub _inline_check_arguments {
    my $self = shift;

    return (
        'if (!Params::Util::_CODELIKE($_[0])) {',
            $self->_inline_throw_exception( InvalidArgumentToMethod =>
                                            'argument                => $_[0],'.
                                            'method_name             => "first",'.
                                            'type_of_argument        => "code reference",'.
                                            'type                    => "CodeRef",',
            ) . ';',
        '}',
    );
}

sub _return_value {
    my $self = shift;
    my ($slot_access) = @_;

    return '&List::Util::first($_[0], @{ (' . $slot_access . ') })';
}

no Moose::Role;

1;
