package Data::Convert::Hash::Rename;
use 5.008005;
use strict;
use warnings;
use parent qw(Exporter);

our $VERSION = "0.01";

sub new {
    my ($class, @args) = @_;

    my %rules;
    if ( ref $args[0] eq 'HASH' ) {
        %rules = %{$args[0]};
    }
    else {
        %rules = %{@args};
    }

    bless { rules => \%rules }, $class;
}

sub rename {
    my ($self, $before) = @_;

    $self->rename_hash($before, $self->{rules});
}

sub rename_hash {
    my ($self, $before, $rules) = @_;

    my $after = +{};
    for my $before_key ( keys %$before ) {
        unless ( exists $rules->{$before_key} ) {
            next;
        }

        my $after_rule = $rules->{$before_key};
        unless ( ref $after_rule ) {
            $after->{$after_rule} = $before->{$before_key};
        }
        elsif ( ref $after_rule eq 'CODE' ) {
            $after = { %$after, %{ $after_rule->( $before_key, $before->{$before_key}, $before ) } };
        }
        else {
            die "not supported type";
        }
    }
    return $after;
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::Convert::Hash::Rename - It's new $module

=head1 SYNOPSIS

    use Data::Convert::Hash::Rename;

=head1 DESCRIPTION

Data::Convert::Hash::Rename is ...

=head1 LICENSE

Copyright (C) Hiroyoshi Houchi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hiroyoshi Houchi E<lt>hixi@cpan.orgE<gt>

=cut

