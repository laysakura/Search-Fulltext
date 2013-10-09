package Search::Fulltext::SQLite;
use strict;
use warnings;
use utf8;

use DBI;

use constant {
    TABLE  => 'fts4table',
    COLUMN => 'content',
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

    $dbh->do("DROP TABLE IF EXISTS " . TABLE) or die DBI::errstr;
    $dbh->do("CREATE VIRTUAL TABLE " . TABLE . " USING fts4(" . COLUMN . ", tokenize=$tokenizer)") or die DBI::errstr;

    $dbh->begin_work;
    $dbh->do("INSERT INTO " . TABLE . " (" . COLUMN . ") VALUES ('$_')") foreach (@{$self->{docs}});
    # FIXME: This code must be faster but produce segmentation fault...
    # my $sth = $dbh->prepare("INSERT INTO " . TABLE . " (content) VALUES (?)");
    # $sth->execute($_) foreach (@{$docs});
    # $sth->finish;
    $dbh->commit;
}

sub DESTROY {
    my $self = shift;
    $self->{dbh}->disconnect;
}

1;
