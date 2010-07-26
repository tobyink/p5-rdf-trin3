package RDF::TriN3;

use 5.008;
use RDF::Trine;
use RDF::Trine::Node::Formula;
use RDF::Trine::Parser::Notation3;
use RDF::Trine::Serializer::Notation3;

1;

__END__

=head1 NAME

RDF::TriN3 - notation 3 extensions for RDF::Trine

=head1 DESCRIPTION

This module extends L<RDF::Trine> in three ways:

=over 4

=item * Adds a Notation 3 parser.

=item * Adds a Notation 3 serializer.

=item * Provides a subclass of literals to represent Notation 3 formulae.

=back

Implementing N3 logic and the cwm built-ins is considered outside the scope
of this module, though I am interested in doing that as part of a separate
project.

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<RDF::Trine::Node::Formula>,
L<RDF::Trine::Parser::Notation3>,
L<RDF::Trine::Serializer::Notation3>.

L<RDF::Trine>.

L<http://www.perlrdf.org/>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
