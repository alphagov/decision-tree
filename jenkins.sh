#!/bin/bash -x
source '/usr/local/lib/rvm'
bundle install --path "/home/jenkins/bundles/${JOB_NAME}" --deployment
bundle exec rake spec