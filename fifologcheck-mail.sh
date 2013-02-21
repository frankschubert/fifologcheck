#!/bin/bash
# logcheck.alert-2012-02-15-08.log
#                YYYY-MM-dd-hh
export LANG=en_US.utf-8
LOGPATH=/opt/fifologcheck/logs
DATE=`date -d "1 hour ago" +"%Y-%m-%d-%H"`
if [ -e $LOGPATH/logcheck.alert-${DATE}.log ]; then
    cat $LOGPATH/logcheck.alert-${DATE}.log |mail -s "fifologcheck alert for [$DATE]" admin@foobar.foo
fi
