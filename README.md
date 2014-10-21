# NAME

Dist::Zilla::Plugin::CheckSelfDependency - Check if your distribution declares a dependency on itself

# VERSION

version 0.006

# SYNOPSIS

In your `dist.ini`:

    [CheckSelfDependency]

# DESCRIPTION

This is a [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugin that runs in the _after build_ phase, which
checks all of your module prerequisites (all phases, all types except develop) to confirm
that none of them refer to modules that are __provided__ by this distribution
(that is, the metadata declares the module is indexable).

In addition, all modules __in__ the distribution are checked against all module
prerequisites (all phases, all types __including__ develop). Thus, it is
possible to ship a [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugin and use (depend on) yourself, but
errors such as declaring a dependency on `inc::HelperPlugin` are still caught.

While some prereq providers (e.g. [`[AutoPrereqs]`](https://metacpan.org/pod/Dist::Zilla::Plugin::AutoPrereqs))
do not inject dependencies found internally, there are many plugins that
generate code and also inject the prerequisites needed by that code, without
regard to whether some of those modules might be provided by your dist.

If such modules are found, the build fails.  To remedy the situation, remove
the plugin that adds the prerequisite, or remove the prerequisite itself with
[`[RemovePrereqs]`](https://metacpan.org/pod/Dist::Zilla::Plugin::RemovePrereqs). (Remember that
plugin order is significant -- you need to remove the prereq after it has been
added.)

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-CheckSelfDependency)
(or [bug-Dist-Zilla-Plugin-CheckSelfDependency@rt.cpan.org](mailto:bug-Dist-Zilla-Plugin-CheckSelfDependency@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
