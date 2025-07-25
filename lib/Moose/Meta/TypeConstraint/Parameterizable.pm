package Moose::Meta::TypeConstraint::Parameterizable;
our $VERSION = '2.4001';

use strict;
use warnings;
use metaclass;

use parent 'Moose::Meta::TypeConstraint';
use Moose::Meta::TypeConstraint::Parameterized;
use Moose::Util::TypeConstraints ();

use Moose::Util 'throw_exception';

use Carp 'confess';

__PACKAGE__->meta->add_attribute('constraint_generator' => (
    accessor  => 'constraint_generator',
    predicate => 'has_constraint_generator',
    Class::MOP::_definition_context(),
));

__PACKAGE__->meta->add_attribute('inline_generator' => (
    accessor  => 'inline_generator',
    predicate => 'has_inline_generator',
    Class::MOP::_definition_context(),
));

sub generate_constraint_for {
    my ($self, $type) = @_;

    return unless $self->has_constraint_generator;

    return $self->constraint_generator->($type->type_parameter)
        if $type->is_subtype_of($self->name);

    return $self->_can_coerce_constraint_from($type)
        if $self->has_coercion
        && $self->coercion->has_coercion_for_type($type->parent->name);

    return;
}

sub _can_coerce_constraint_from {
    my ($self, $type) = @_;
    my $coercion   = $self->coercion;
    my $constraint = $self->constraint_generator->($type->type_parameter);
    return sub {
        local $_ = $coercion->coerce($_);
        $constraint->(@_);
    };
}

sub generate_inline_for {
    my ($self, $type, $val) = @_;

    throw_exception( CannotGenerateInlineConstraint => parameterizable_type_object_name => $self->name,
                                                       type_name                        => $type->name,
                                                       value                            => $val,
                   )
        unless $self->has_inline_generator;

    return '( do { ' . $self->inline_generator->( $self, $type, $val ) . ' } )';
}

sub _parse_type_parameter {
    my ($self, $type_parameter) = @_;
    return Moose::Util::TypeConstraints::find_or_create_isa_type_constraint($type_parameter);
}

sub parameterize {
    my ($self, $type_parameter) = @_;

    my $contained_tc = $self->_parse_type_parameter($type_parameter);

    ## The type parameter should be a subtype of the parent's type parameter
    ## if there is one.

    if(my $parent = $self->parent) {
        if($parent->can('type_parameter')) {
            unless ( $contained_tc->is_a_type_of($parent->type_parameter) ) {
                throw_exception( ParameterIsNotSubtypeOfParent => type_parameter => $type_parameter,
                                                                  type_name      => $self->name,
                               );
            }
        }
    }

    if ( $contained_tc->isa('Moose::Meta::TypeConstraint') ) {
        my $tc_name = $self->name . '[' . $contained_tc->name . ']';
        return Moose::Meta::TypeConstraint::Parameterized->new(
            name               => $tc_name,
            parent             => $self,
            type_parameter     => $contained_tc,
            parameterized_from => $self,
        );
    }
    else {
        confess("The type parameter must be a Moose meta type");
    }
}


1;

# ABSTRACT: Type constraints which can take a parameter (ArrayRef)

__END__


=pod

=head1 DESCRIPTION

This class represents a parameterizable type constraint. This is a
type constraint like C<ArrayRef> or C<HashRef>, that can be
parameterized and made more specific by specifying a contained
type. For example, instead of just an C<ArrayRef> of anything, you can
specify that is an C<ArrayRef[Int]>.

A parameterizable constraint should not be used as an attribute type
constraint. Instead, when parameterized it creates a
L<Moose::Meta::TypeConstraint::Parameterized> which should be used.

=head1 INHERITANCE

C<Moose::Meta::TypeConstraint::Parameterizable> is a subclass of
L<Moose::Meta::TypeConstraint>.

=head1 METHODS

This class is intentionally not documented because the API is
confusing and needs some work.

=head1 BUGS

See L<Moose/BUGS> for details on reporting bugs.

=cut
