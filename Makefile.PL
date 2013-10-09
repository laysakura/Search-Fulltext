use strict;
use warnings;
use utf8;

use inc::Module::Install;

name     'Search-Fulltext';
author   'Sho Nakatani <lay.sakura@gmail.com>';
all_from 'lib/Search/Fulltext.pm',

requires 'DBI';
requires 'DBD::SQLite' => '1.30_01';

test_requires 'Test::More';
test_requires 'Test::Exception';
test_requires 'File::Temp';

auto_install;
WriteAll;
