package Moose::Meta::Method::Accessor::Native::Hash::elements;
our $VERSION = '2.4001';

use strict;
use warnings;

use Moose::Role;

with 'Moose::Meta::Method::Accessor::Native::Reader';

sub _maximum_arguments { 0 }

sub _return_value {
    my $self = shift;
    my ($slot_access) = @_;

    return 'map { $_, ' . $slot_access . '->{$_} } '
             . 'keys %{ (' . $slot_access . ') }';
}

no Moose::Role;

1;
