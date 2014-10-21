use strict;
use warnings FATAL => 'all';

use utf8;
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
                [ 'Prereqs / RuntimeRequires' => { 'Foo::Bar' => '1.23' } ],
            ),
            path(qw(source lib Foo Bar.pm)) => do {
                my $content = "package Foo::Bar;\nsub ohnoes { print 'ಠ_ಠ' }\n1;\n";
                utf8::encode($content) if Dist::Zilla->VERSION < 5;      # it spews :raw!
                $content;
            },
        },
    },
);

like(
    exception { $tzil->build },
    qr{Foo::Bar is listed as a prereq, but is also provided by this dist \(lib/Foo/Bar.pm\)!},
    'build is aborted',
);

done_testing;
