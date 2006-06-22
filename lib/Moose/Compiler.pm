
package Moose::Compiler;
use Moose;

our $VERSION = '0.01';

has 'engine' => (
    is       => 'rw', 
    does     => 'Moose::Compiler::Engine',
    handles  => [qw(
        compile_class
    )],
    required => 1,     
);

1;

__END__

=pod

=head1 NAME

Moose::Compiler - The front end for the Moose compiler

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<meta>

This will return the metaclass associated with the given class.

=item B<engine>

=back

=head1 DELEGATED METHODS

=over 4

=item B<compile_class>

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