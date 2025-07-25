package Moose::Meta::TypeConstraint::Enum;
our $VERSION = '2.4001';

use strict;
use warnings;
use metaclass;

use B;
use Moose::Util::TypeConstraints ();

use parent 'Moose::Meta::TypeConstraint';

use Moose::Util 'throw_exception';

__PACKAGE__->meta->add_attribute('values' => (
    accessor => 'values',
    Class::MOP::_definition_context(),
));

__PACKAGE__->meta->add_attribute('_inline_var_name' => (
    accessor => '_inline_var_name',
    Class::MOP::_definition_context(),
));

my $inliner = sub {
    my $self = shift;
    my $val  = shift;

    return 'defined(' . $val . ') '
             . '&& !ref(' . $val . ') '
             . '&& $' . $self->_inline_var_name . '{' . $val . '}';
};

my $var_suffix = 0;

sub new {
    my ( $class, %args ) = @_;

    $args{parent} = Moose::Util::TypeConstraints::find_type_constraint('Str');
    $args{inlined} = $inliner;

    if ( scalar @{ $args{values} } < 1 ) {
        throw_exception( MustHaveAtLeastOneValueToEnumerate => params => \%args,
                                                               class  => $class
                       );
    }

    for (@{ $args{values} }) {
        if (!defined($_)) {
            throw_exception( EnumValuesMustBeString => params => \%args,
                                                       class  => $class,
                                                       value  => $_
                           );
        }
        elsif (ref($_)) {
            throw_exception( EnumValuesMustBeString => params => \%args,
                                                       class  => $class,
                                                       value  => $_
                           );
        }
    }

    my %values = map { $_ => 1 } @{ $args{values} };
    $args{constraint} = sub { $values{ $_[0] } };

    my $var_name = 'enums' . $var_suffix++;;
    $args{_inline_var_name} = $var_name;
    $args{inline_environment} = { '%' . $var_name => \%values };

    my $self = $class->SUPER::new(\%args);

    $self->compile_type_constraint()
        unless $self->_has_compiled_type_constraint;

    $self->message( sub {
        my $value = shift;
        sprintf(
            '%s. Value must be equal to %s.',
            $self->_default_message->( $value ),
            Moose::Util::_english_list_or( map B::perlstring($_), @{ $self->values } ),
        )
    } );

    return $self;
}

sub equals {
    my ( $self, $type_or_name ) = @_;

    my $other = Moose::Util::TypeConstraints::find_type_constraint($type_or_name);

    return unless $other->isa(__PACKAGE__);

    my @self_values  = sort @{ $self->values };
    my @other_values = sort @{ $other->values };

    return unless @self_values == @other_values;

    while ( @self_values ) {
        my $value = shift @self_values;
        my $other_value = shift @other_values;

        return unless $value eq $other_value;
    }

    return 1;
}

sub constraint {
    my $self = shift;

    my %values = map { $_ => undef } @{ $self->values };

    return sub { exists $values{$_[0]} };
}

sub create_child_type {
    my ($self, @args) = @_;
    return Moose::Meta::TypeConstraint->new(@args, parent => $self);
}

1;

# ABSTRACT: Type constraint for enumerated values.

__END__

=pod

=head1 DESCRIPTION

This class represents type constraints based on an enumerated list of
acceptable values.

=head1 INHERITANCE

C<Moose::Meta::TypeConstraint::Enum> is a subclass of
L<Moose::Meta::TypeConstraint>.

=head1 METHODS

=head2 Moose::Meta::TypeConstraint::Enum->new(%options)

This creates a new enum type constraint based on the given
C<%options>.

It takes the same options as its parent, with several
exceptions. First, it requires an additional option, C<values>. This
should be an array reference containing a list of valid string
values. Second, it automatically sets the parent to the C<Str> type.

Finally, it ignores any provided C<constraint> option. The constraint
is generated automatically based on the provided C<values>.

=head2 $constraint->values

Returns the array reference of acceptable values provided to the
constructor.

=head2 $constraint->create_child_type

This returns a new L<Moose::Meta::TypeConstraint> object with the type
as its parent.

Note that it does I<not> return a C<Moose::Meta::TypeConstraint::Enum>
object!

=head1 BUGS

See L<Moose/BUGS> for details on reporting bugs.

=cut
