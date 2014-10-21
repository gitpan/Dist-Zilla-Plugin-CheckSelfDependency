use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::DZil;
use Test::Fatal;
use Path::Tiny;

{
    my $tzil = Builder->from_config(
        { dist_root => 't/corpus/basic' },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    'GatherDir',
                    'CheckSelfDependency',
                    [ 'Prereqs / RuntimeRequires' => { 'Foo::Bar' => '1.23' } ],
                ),
                path(qw(source lib Foo Bar.pm)) => "package Foo::Bar::Baz;\n1;\n",
            },
        },
    );

    is(
        exception { $tzil->build },
        undef,
        'build is not aborted - prereq not actually provided by dist',
    );
}

{
    my $tzil = Builder->from_config(
        { dist_root => 't/corpus/basic' },
        {
            add_files => {
                'source/dist.ini' => simple_ini(
                    'GatherDir',
                    'CheckSelfDependency',
                    [ 'Prereqs / RuntimeRequires' => { 'Foo::Bar::Baz' => '1.23' } ],
                ),
                path(qw(source lib Foo Bar.pm)) => "package Foo::Bar::Baz;\n1;\n",
            },
        },
    );

    like(
        exception { $tzil->build },
        qr{Foo::Bar::Baz is listed as a prereq, but is also provided by this dist \(lib/Foo/Bar.pm\)!},
        'build is aborted',
    );
}

done_testing;
