$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_job/cancel'
require 'active_job'
require 'sidekiq'
require 'jobs/hello_job'
require 'jobs/fail_job'

require 'minitest/autorun'
