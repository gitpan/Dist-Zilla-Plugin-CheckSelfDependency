use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::DZil;
use Test::Fatal;
use Path::Tiny;

my $tzil = Builder->from_config(
    { dist_root => 't/does_not_exist' },
    {
        add_files => {
            'source/dist.ini' => simple_ini(
                'GatherDir',
                'CheckSelfDependency',
                [ GenerateFile => source => {
                    filename => 'lib/Foo/Bar.pm',
                    content => [ 'package Foo::Bar;', '1;' ],
                  } ],
                [ 'Prereqs / RuntimeRequires' => { 'Foo::Bar' => '1.23' } ],
            ),
        },
    },
);

like(
    exception { $tzil->build },
    qr{Foo::Bar is listed as a prereq, but is also provided by this dist \(lib/Foo/Bar.pm\)!},
    'build is aborted',
);

done_testing;
