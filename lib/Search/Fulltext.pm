package Search::Fulltext;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';
use Search::Fulltext::SQLite;

sub new {
    my ($class, @args) = @_;
    my %args = ref $args[0] eq 'HASH' ? %{$args[0]} : @args;

    unless ($args{docs}) { die "'docs' is required for creating new instance of $class" }
    $args{index_file} = ":memory:" unless defined $args{index_file};
    $args{tokenizer}  = "simple"   unless defined $args{tokenizer};
    $args{sqliteh}    = Search::Fulltext::SQLite::->new(
        docs      => $args{docs},
        dbfile    => $args{index_file},
        tokenizer => $args{tokenizer},
    );

    bless {
        %args
    }, $class;
}

sub search {
    my ($self, $query) = @_;
    return [] unless $query;

    my $sqliteh = $self->{sqliteh};
    $sqliteh->search_docids($query);
}

1;
__END__

=encoding utf8

=head1 NAME

Search::Fulltext - Fulltext search module

=head1 SYNOPSIS

    my $query = 'beer';
    my @docs = (
        'I like beer the best',
        'Wine makes people saticefied',  # does not include beer
        'Beer makes people happy',
    );
    
    my $fts = Search::Fulltext->new({
        docs => \@docs,
    });
    my $results = $fts->search($query);
    is_deeply($results, [0, 2]);         # 1st & 3rd doc include 'beer'

=head1 DESCRIPTION

Search::Fulltext is a fulltext search module. It can be used in a few steps.

Languages not separated by white spaces (unlike English, like Japanese) are not supported yet,
although future version would support it.

Currently SQLite's FTS4 is used as an indexer.
Various queries supported by FTS4 (AND, OR, NEAR, ...) are fully provided.

=head1 METHODS

=head2 Search::Fulltext->new

=pod

Creates fulltext index for documents.

=over 4

=item C<@param docs> B<[required]>

Reference to array whose contents are document to be searched.

=item C<@param index_file> B<[optional]>

File path to write fulltext index. By default, on-memory index is used.

=item C<@param tokenizer> B<[optional]>

Tokenizer name to use. 'simple' (default) and 'porter' is supported in the current version.
See L<http://www.sqlite.org/fts3.html#tokenizer> for more details on FTS4 tokenizers.
Future release would support Japanese tokenizer.

=back

=cut

=head2 Search::Fulltext->search

Search terms in documents by query language.

=pod

=over 4

=item C<@returns>

Array of indexes of C<docs> passed through C<Search::Fulltext->new> in which C<query> is matched.

=item C<@param query>

Query to search from documents.
The simplest query would be a term.

    my $results = $fts->search('beer');

Other queries below and combination of them can be also used.

    my $results = $fts->search('beer AND happy');
    my $results = $fts->search('saticefied OR happy');
    my $results = $fts->search('people NOT beer');
    my $results = $fts->search('make*');
    my $results = $fts->search('"makes people"');
    my $results = $fts->search('beer NEAR happy');
    my $results = $fts->search('beer NEAR/1 happy');

See L<http://www.sqlite.org/fts3.html#section_3> for detail.

=back

=cut

=head1 VERSION

Version 0.01

=head1 CHANGES

=over 4

=item B<0.01>  2013-10-09 / 21:23:17 JST

First release. Has SQLite's FTS4 as a backend and supports array of string as a document.

=back

=head1 AUTHOR

Sho Nakatani <lay.sakura@gmail.com>, a.k.a. @laysakura

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Sho Nakatani.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut
