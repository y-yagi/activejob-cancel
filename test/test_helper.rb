$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!
require 'active_job/cancel'
require 'active_job'
require 'active_job/test_helper'
require 'sidekiq'
require 'jobs/hello_job'
require 'jobs/fail_job'
require 'jobs/default_queue_name'

require 'minitest/autorun'
