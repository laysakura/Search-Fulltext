use strict;
use warnings;
use inc::Module::Install;

name     'Search-Fulltext';
author   'Sho Nakatani <lay.sakura@gmail.com>';
all_from 'lib/Search/Fulltext.pm',

test_requires 'Test::More';

auto_install;
WriteAll;
