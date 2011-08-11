package Params::Validate::Dependencies;

use strict;
use warnings;

use vars qw($VERSION @EXPORT @EXPORT_OK %EXPORT_TAGS);

use base qw(Exporter);

$VERSION = '1.00';
@EXPORT = ();
@EXPORT_OK = qw(any_of all_of validate_dependencies);

%EXPORT_TAGS = (
  all => \@EXPORT_OK,
);

=head1 NAME

Params::Validate::Dependencies

=head1 DESCRIPTION

Extends Params::Validate to make it easy to validate
that you have been passed the correct combinations of parameters.

=head1 SYNOPSIS

This validates that sub 'foo's arguments are of the right types,
and that either we have at least one of alpha, beta and gamma, or
we have both of bar amd baz:

  use Params::Validate::Dependencies qw(:all);
  use Params::Validate;

  sub foo {
    validate(@_, {
      alpha => { type => ARRAYREF, optional => 1 },
      beta  => { type => ARRAYREF, optional => 1 },
      gamma => { type => ARRAYREF, optional => 1 },
      bar   => { type => SCALAR, optional => 1 },
      baz   => { type => SCALAR, optional => 1 },
      validate_dependencies(
        any_of(
          qw(alpha beta gamma),
          all_of(qw(bar baz)),
        )
      )
    });
  }

=head1 HOW IT WORKS

Params::Validate supports validation via callbacks.  This module
provides subroutines that make it easy to construct those callbacks.

=head1 SUBROUTINES

None of these are exported by default.  You probably want to export
them though, by passing ':all' on import as above.

=head2 validate_dependencies

This returns the basic shell of a callback definition.  It takes
an optional name, and then a mandatory code-ref.  Failure to provide
a code-ref is fatal.

  validate_dependencies($foo)

returns

  _wfbiobowcv => { callbacks => { autogenerated => $foo } }

The weird string '_wfbiobowcv' is intended to be something that you
would never normally have as a parameter name in your code.  If for
some reason you would rather have something else, then:

  validate_dependencies('i_like_puppies', $foo)

will return

  i_like_puppies => { ... }

=cut

sub validate_dependencies {
  my $coderef = shift;
  my $name = '_wfbiobowcv';
  if(!ref($coderef)) {
    ($name, $coderef) = ($coderef, shift());
  }

  die(__PACKAGE__."::validate_dependencies: code-ref required\n")
    unless(ref($coderef) =~ /CODE/);

  return $name => { callbacks => { autogenerated => $coderef } };
}

=head2 any_of

This returns a code-ref which, when called by Params::Validate,
checks that the hashref it receives as its second argument contains
any of the specified scalar keys or which, when passed in the same
style to a code-ref, returns true.

=cut

sub any_of {
  my @options = @_;
}

=head2 all_of

This returns a code-ref which, when called by Params::Validate,
checks that the hashref it receives as its second argument contains
all of the specified scalar keys and which, when passed in the same
style to a code-ref, returns true.

=cut

sub all_of {
}

1;
