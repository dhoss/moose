
package Moose::Meta::TypeCoercion;

use strict;
use warnings;
use metaclass;

use Carp 'confess';

use Moose::Meta::Attribute;
use Moose::Util::TypeConstraints '-no-export';

our $VERSION = '0.01';

__PACKAGE__->meta->add_attribute('type_coercion_map' => (
    reader  => 'type_coercion_map',
    default => sub { [] }
));
__PACKAGE__->meta->add_attribute(
    Moose::Meta::Attribute->new('type_constraint' => (
        reader   => 'type_constraint',
        weak_ref => 1
    ))
);

# private accessor
__PACKAGE__->meta->add_attribute('compiled_type_coercion' => (
    accessor => '_compiled_type_coercion'
));

sub new { 
    my $class = shift;
    my $self  = $class->meta->new_object(@_);
    $self->compile_type_coercion();
    return $self;
}

sub compile_type_coercion {
    my $self = shift;
    my @coercion_map = @{$self->type_coercion_map};
    my @coercions;
    while (@coercion_map) {
        my ($constraint_name, $action) = splice(@coercion_map, 0, 2);
        my $constraint = Moose::Util::TypeConstraints::find_type_constraint($constraint_name)->_compiled_type_constraint;       
        (defined $constraint)
            || confess "Could not find the type constraint ($constraint_name)";
        push @coercions => [ $constraint, $action ];
    }
    $self->_compiled_type_coercion(sub { 
        my $thing = shift;
        foreach my $coercion (@coercions) {
            my ($constraint, $converter) = @$coercion;
            if (defined $constraint->($thing)) {
			    local $_ = $thing;                
                return $converter->($thing);
            }
        }
        return $thing;
    });    
}

sub coerce { $_[0]->_compiled_type_coercion->($_[1]) }


1;

__END__

=pod

=head1 NAME

Moose::Meta::TypeCoercion - The Moose Type Coercion metaclass

=head1 DESCRIPTION

For the most part, the only time you will ever encounter an 
instance of this class is if you are doing some serious deep 
introspection. This API should not be considered final, but 
it is B<highly unlikely> that this will matter to a regular 
Moose user.

If you wish to use features at this depth, please come to the 
#moose IRC channel on irc.perl.org and we can talk :)

=head1 METHODS

=over 4

=item B<meta>

=item B<new>

=item B<compile_type_coercion>

=item B<coerce>

=item B<type_coercion_map>

=item B<type_constraint>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2006 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut