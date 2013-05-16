#!/usr/bin/perl
# @author Frank Schubert
# Testlauf der logcheck-ignore files. Syntaxfehler gehen nach stderr.

my $ignore = "/opt/fifologcheck/regexes-for-unimportant-messages.txt";

# hierein werden spaeter die ignores geladen
my @logcheck_ignore;

if (sysopen(IGNORE, $ignore, O_RDONLY)) {
    @logcheck_ignore = <IGNORE>;
    close(IGNORE);
}
my $match=0;
foreach(@logcheck_ignore) {
    chomp($_);
    if( 'foo' =~ m/$_/ig ) {
        $match=1;
    }
}
