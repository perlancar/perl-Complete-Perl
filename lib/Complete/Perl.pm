package Complete::Perl;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

#use List::MoreUtils qw(uniq);

use Complete::Common qw(:all);

our %SPEC;
require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_perl_version
                       complete_perl_builtin_function
                       complete_perl_builtin_symbol
               );

$SPEC{complete_perl_builtin_function} = {
    v => 1.1,
    description => <<'_',

Currently using `@Functions` from <pm:B::Keywords>.

_
    args => {
        %arg_word,
    },
    result_naked => 1,
};
sub complete_perl_builtin_function {
    require B::Keywords;
    require Complete::Util;

    my %args = @_;
    Complete::Util::complete_array_elem(
        word => $args{word},
        array => \@B::Keywords::Functions,
    );
}

$SPEC{complete_perl_builtin_symbols} = {
    v => 1.1,
    description => <<'_',

Currently using `@Symbols` from <pm:B::Keywords>.

_
    args => {
        %arg_word,
    },
    result_naked => 1,
};
sub complete_perl_builtin_symbol {
    require B::Keywords;
    require Complete::Util;

    my %args = @_;
    Complete::Util::complete_array_elem(
        word => $args{word},
        array => \@B::Keywords::Symbols,
    );
}

$SPEC{complete_perl_version} = {
    v => 1.1,
    args => {
        %arg_word,
        use_v => {
            summary => 'Whether to prefix the perl versions with "v"',
            schema => 'bool',
            description => <<'_',

If not specified, then if the word starts with v then will default to true.

_
        },
        dev => {
            summary => 'Whether to include development perl releases',
            schema => 'bool',
            description => <<'_',

If not specified, then will first try completing without development releases
and if none is found will try with.

_
        },
    },
    result_naked => 1,
};
sub complete_perl_version {
    require Complete::Util;
    require Module::CoreList;

    my %args = @_;
    my $word = $args{word} // '';
    my $use_v = $args{use_v} // do {
        $word =~ /\A[Vv]/ ? 1:0;
    };
    my $dev = $args{dev};

    my @with_devs;
    if ($dev) {
        @with_devs = (1);
    } elsif (defined $dev) {
        @with_devs = (0);
    } else {
        @with_devs = (0,1);
    }

    my $res;
    for my $with_dev (@with_devs) {
        my @vers   = sort keys %Module::CoreList::version;
        unless ($with_dev) {
            @vers = grep {
                my $v = version->parse($_)->normal;
                my ($minor) = $v =~ /\.(\d+)/; $minor //= 0;
                $minor % 2 == 0;
            } @vers;
        }
        my @vers_normalv    = map {version->parse($_)->normal} @vers;
        my @vers_normalnonv = map {my $v = $_; $v =~ s/\Av//; $v }
            @vers_normalv;

        local $Complete::Common::OPT_FUZZY = 0;
        if ($use_v) {
            $res = Complete::Util::complete_array_elem(
                word=>$word, array => \@vers_normalv);
        } elsif ($word =~ /\..+\./) {
            $res = Complete::Util::complete_array_elem(
                word=>$word, array => \@vers_normalnonv);
        } else {
            $res = Complete::Util::complete_array_elem(
                word=>$word, array => \@vers);
        }
        last if @$res;
    }
    $res;
}

1;
#ABSTRACT: Complete various Perl entities

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete>

L<Complete::Module>

L<Reply> (which has plugins to complete global variables, user-defined
functions, lexicals, methods, packages, and so on).

=cut
