package Search::Fulltext::SQLite;
use strict;
use warnings;
use utf8;

use DBI;

use constant {
    TABLE       => 'fts4table',
    CONTENT_COL => 'content',
    DOCID_COL   => 'docid',
};

sub _make_dbh {
    my $dbfile = shift;
    DBI->connect(
        "dbi:SQLite:dbname=$dbfile", "", "",
        {
            RaiseError     => 1,
            AutoCommit     => 1,
            sqlite_unicode => 1,
        }
    );
}

sub new {
    my ($class, @args) = @_;
    my %args = ref $args[0] eq 'HASH' ? %{$args[0]} : @args;

    unless ($args{docs})      { die "'docs' is required for creating new instance of $class" }
    unless ($args{dbfile})    { die "'dbfile' is required for creating new instance of $class" }
    unless ($args{tokenizer}) { die "'tokenizer' is required for creating new instance of $class" }

    my $self = bless {
        dbh => _make_dbh($args{dbfile}),
        %args
    }, $class;
    $self->_make_fts4_index;
    $self;
}

sub _make_fts4_index {
    my $self      = shift;
    my $dbh       = $self->{dbh};
    my $tokenizer = $self->{tokenizer};

    $dbh->do("DROP TABLE IF EXISTS " . TABLE) or die $dbh->errstr;
    $dbh->do("CREATE VIRTUAL TABLE " . TABLE . " USING fts4(" . CONTENT_COL . ", tokenize=$tokenizer)")
        or die $dbh->errstr;

    $dbh->begin_work;
    foreach (@{$self->{docs}}) {
        $dbh->do("INSERT INTO " . TABLE . " (" . CONTENT_COL . ") VALUES ('$_')")
            or die $dbh->errstr;
    }
    # FIXME: This code must be faster but produce segmentation fault...
    # foreach (@{$self->{docs}}) {
    #     my $sth = $dbh->prepare("INSERT INTO " . TABLE . " (" . CONTENT_COL . ") VALUES ('?')")
    #         or die $dbh->errstr;
    #     $sth->execute($_) foreach (@{$self->{docs}});
    #     $sth->finish;
    # }
    $dbh->commit;
}

sub search_docids {
    my ($self, $query) = @_;
    my $dbh            = $self->{dbh};
    my $sth = $dbh->prepare("SELECT " . DOCID_COL . "-1 FROM " . TABLE . " WHERE " . CONTENT_COL . " MATCH ?")
        or die $dbh->errstr;
    $sth->execute($query) or die $dbh->errstr;
    my @docids = ();
    while (my @row = $sth->fetchrow_array) {
        push @docids, $row[0];
    }
    \@docids;
}

sub DESTROY {
    my $self = shift;
    $self->{dbh}->disconnect;
}

1;
