package Complete::Perl;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

#use List::MoreUtils qw(uniq);

our %SPEC;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw();

# TODO: complete_lexical, though probably you should just use
# complete_array_elem(array => [keys %{ lexicals() }]) (see L<lexicals>)

# TODO: complete_function(package => ...)

# TODO: complete_global_variable(package => ...) # can complete
# array/hash/scalar, can accept sigil or not

# TODO: complete_method()

# TODO: complete_keyword()

1;
#ABSTRACT: Complete various Perl entities

=head1 SYNOPSIS


=head1 DESCRIPTION

Not yet implemented, land grab :)


=head1 SEE ALSO

L<Complete>

L<Complete::Module>

L<Reply> (which has plugins to complete global variables, user-defined
functions, lexicals, methods, packages, and so on).

=cut
