requires 'DBD::SQLite', '1.30_01';
requires 'DBI';

on build => sub {
    requires 'File::Temp';
    requires 'Test::Exception';
    requires 'Test::More';
};
