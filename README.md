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

Version 0.05

# TODO

\- Pluggable tokenizer

\- Japanese tokenizer

# AUTHOR

Sho Nakatani <lay.sakura@gmail.com>, a.k.a. @laysakura
