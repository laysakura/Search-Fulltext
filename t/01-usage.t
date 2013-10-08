#!perl -T
use strict;
use warnings;
use Test::More;

use Search::Fulltext;

plan tests => 1;

sub usage {
    my $query = 'beer';
    my @docs = (
        'Beer makes people happy',
        'Wine makes people saticefied',  # does not include beer
        'I like beer the best',
        'Buy fruits, beer, and eggs',    # 'beer,' does not match to 'beer'
    );
    # my $path = '/tmp/01-usage.sqlite';  # TODO:     POSIX way to get a path

    my $fts = Search::Fulltext->new({
        docs     => \@docs,
        # index_to => $path,  # default:  ':memory:'
        # tokenizer => 'simple',     # see: http://www.sqlite.org/fts3.html#tokenizer
    });
    
    my $results = $fts->search($query);
    is_deeply($results, [0, 2]);
}

usage;
