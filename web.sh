#! /bin/bash
/etc/init.d/cron start && bundle exec thin start -p 3000 -e production