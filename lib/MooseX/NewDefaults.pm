#
# This file is part of MooseX-NewDefaults
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::NewDefaults;
{
  $MooseX::NewDefaults::VERSION = '0.002';
}

# ABSTRACT: Alter attribute defaults with less pain

use Moose 0.94 ();
use namespace::autoclean;
use Moose::Exporter;
use Moose::Util;

sub default_for {
    my ($meta, $attribute_name, $new_default) = (shift, shift, shift);

    # yes, Moose::Role will explode letting the caller know that roles don't
    # currently support attribute extension... but that's M::R's problem, not
    # ours :)

    my $sub
       = $meta->isa('Moose::Meta::Role')
       ? \&Moose::Role::has
       : \&Moose::has
       ;

    # massage into what has() expects
    @_ = ($meta, "+$attribute_name", default => $new_default);
    goto \&$sub;
    return;
}

Moose::Exporter->setup_import_methods(with_meta => [ qw{ default_for } ]);

!!42;



=pod

=head1 NAME

MooseX::NewDefaults - Alter attribute defaults with less pain

=head1 VERSION

version 0.002

=head1 SYNOPSIS

    package One;
    use Moose;
    use namespace::autoclean;

    has A => (is => 'ro', default => sub { 'say ahhh' });
    has B => (is => 'ro', default => sub { 'say whoo' });

    package Two;
    use Moose;
    use namespace::autoclean;
    use MooseX::NewDefaults;

    # sugar for defining a new default
    default_for A => sub { 'say oooh' };

    # this is also legal
    default_for B => 'say oooh';

=head1 DESCRIPTION

Ever start using a package from the CPAN, only to discover that it requires
lots of subclassing and "has '+foo' => (default => ...)"?  It's not
recommended Moose best practice, and it's certanly not the prettiest thing
ever, either.

That's where we come in.

This package introduces new sugar that you can use in the baseclass,
default_for (as seen above).

e.g.

    has '+foo' => (default => sub { 'a b c' });

...is the same as:

    default_for foo => sub { 'a b c' };

=head1 NEW SUGAR

=head2 default_for

This package exports one function, default_for().  This is shorthand sugar to
give an attribute defined in a superclass a new default; it expects the name
of an attribute and a legal value to be used as the new default.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Bugs, feature requests and pull requests through GitHub are most welcome; our
page and repo (same URI):

    https://github.com/RsrchBoy/moosex-newdefaults

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__

