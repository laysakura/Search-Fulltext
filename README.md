# NAME

Search::Fulltext - Fulltext search module

# SYNOPSIS

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

# DESCRIPTION

Search::Fulltext is a fulltext search module. It can be used in a few steps.

Languages not separated by white spaces (unlike English, like Japanese) are not supported yet,
although future version would support it.

Currently SQLite's FTS4 is used as an indexer.
Various queries supported by FTS4 (AND, OR, NEAR, ...) are fully provided.

# METHODS

## Search::Fulltext->new

Creates fulltext index for documents.

- `@param docs` __\[required\]__

    Reference to array whose contents are document to be searched.

- `@param index_file` __\[optional\]__

    File path to write fulltext index. By default, on-memory index is used.

- `@param tokenizer` __\[optional\]__

    Tokenizer name to use. 'simple' (default) and 'porter' is supported in the current version.
    See [http://www.sqlite.org/fts3.html\#tokenizer](http://www.sqlite.org/fts3.html\#tokenizer) for more details on FTS4 tokenizers.
    Future release would support Japanese tokenizer.

## Search::Fulltext->search

Search terms in documents by query language.

- `@returns`

    Array of indexes of `docs` passed through `Search::Fulltext-\`new> in which `query` is matched.

- `@param query`

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

    See [http://www.sqlite.org/fts3.html\#section\_3](http://www.sqlite.org/fts3.html\#section\_3) for detail.

# VERSION

Version 0.04

# TODO

\- Pluggable indexer (not only SQLite)

\- Pluggable tokenizer

\- Japanese tokenizer

# AUTHOR

Sho Nakatani <lay.sakura@gmail.com>, a.k.a. @laysakura

# LICENSE AND COPYRIGHT

Copyright 2013 Sho Nakatani.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic\_license\_2\_0)

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


