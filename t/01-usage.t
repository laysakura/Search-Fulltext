use strict;
use warnings;
use utf8;
use Test::More;

use Search::Fulltext;
use Search::Fulltext::TestSupport;

plan tests => 3;

my $query = 'beer';
my @docs = (
    'Beer makes people happy',
    'Wine makes people saticefied',  # does not include beer
    'I like beer the best',
    'Buy fruits, beer, and eggs',    # 'beer,' does not match to 'beer'
);

# Common usage
{
    my $fts = Search::Fulltext->new({
        docs => \@docs,
    });
    my $results = $fts->search($query);
    is_deeply($results, [0, 2]);
}

# Using index file on disk (when 'docs' is large)
# TODO: Large docs should not come with array. Rather (filepath0, filepath1, ...) is better.
{
    my $dbfile = Search::Fulltext::TestSupport::make_tmp_file;
    my $fts = Search::Fulltext->new({
        docs       => \@docs,
        index_file => $dbfile,
    });
    my $results = $fts->search($query);
    is_deeply($results, [0, 2]);
}

# Using non-default tokenizer
{
    my $dbfile = Search::Fulltext::TestSupport::make_tmp_file;
    my $fts = Search::Fulltext->new({
        docs      => \@docs,
        tokenizer => 'porter',
    });
    my $results = $fts->search($query);
    is_deeply($results, [0, 2]);
}
