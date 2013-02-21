#!/usr/bin/perl
use POSIX qw/strftime/;

my $fifo = "/opt/fifologcheck/fifo/logcheck.fifo";
my $ignore = "/opt/fifologcheck/regexes-for-unimportant-messages.txt";
my $alertlog = "/opt/fifologcheck/logs/logcheck.alert";

# hierein werden spaeter die ignores geladen
my @logcheck_ignore;

if (sysopen(FIFO, $fifo, O_RDONLY)) {
    my $i=0;
    while(my $line = <FIFO>) {
        if (sysopen(IGNORE, $ignore, O_RDONLY)) {
            @logcheck_ignore = <IGNORE>;
            close(IGNORE);
        }
        chomp($line);
        my $match=0;
        foreach(@logcheck_ignore) {
            chomp($_);
            if( $line =~ m/$_/ig ) {
                $match=1;
            }
        }
        if($match == 0) {
            $cur_alertlog = $alertlog."-".strftime('%Y-%m-%d-%H', localtime).".log";
            open(ALERTLOG, ">>$cur_alertlog");
            print ALERTLOG $line."\n";
            close(ALERTLOG);
        }
        $i++;
    }
    close(FIFO);
}
