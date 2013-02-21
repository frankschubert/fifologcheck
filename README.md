fifologcheck
============

Logfile check programm that listens on a named pipe (FIFO special file)

The Idea
========

When you run standard logcheck on a central logserver, filtering can take a long time. To get results fast you need filtering when the messages arrive at the logserver. 

fifologcheck sorts the filtered important messages into seprate files named using date and time. (Standard is to write hourly files. Can be easily adapted to use anything strftime accepts.)

These hourly logs can be mailed or fed into another system for processing.
```
LOGPATH=/data/log/fifologcheck
DATE=`date -d "1 hour ago" +"%Y-%m-%d-%H"`
if [ -e $LOGPATH/logcheck.alert-${DATE}.log ]; then
    cat $LOGPATH/logcheck.alert-${DATE}.log |mail -s "fifologcheck alert [$DATE]" admin@foobar.foo
fi
```

Usage Example
=============

rsyslog can easily be configured to send all messages into a file using the pipe symbol:
```
*.* |/var/tmp/logcheck.fifo
```

fifologcheck listens for messages on this named pipe and feeds them to a list of regexes, e.g.
```
smartd\[.+\]: Device: /dev/sd., Failed SMART usage Attribute: .+ Unknown_Attribute
```

A comprehensive list of unimportant messages can be complied from the logcheck database.

fifologcheck itself is a simple perl while-loop reading from the named pipe and filtering everything unimportant out.
I recommend running it using some kind of service supervision tool, e.g. runit.

```
### /etc/service/fifologcheck/run
#!/bin/sh
exec /usr/local/sbin/fifologcheck.pl >/dev/null 2>&1
```

TODO
====

- find a more efficient way to handle regex files
- implement the regex part in C
