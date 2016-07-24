# ActiveJob::Cancel

`activejob-cancel` provides cancel method to Active Job. Currently it supports only `Sidekiq` and `Delayed Job`.

[![Build Status](https://travis-ci.org/y-yagi/activejob-cancel.svg?branch=master)](https://travis-ci.org/y-yagi/activejob-cancel)
[![Gem Version](https://badge.fury.io/rb/activejob-cancel.svg)](http://badge.fury.io/rb/activejob-cancel)
[![Code Climate](https://codeclimate.com/github/y-yagi/activejob-cancel/badges/gpa.svg)](https://codeclimate.com/github/y-yagi/activejob-cancel)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activejob-cancel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activejob-cancel

## Usage

```ruby
# app/jobs/hello_job.rb
class HelloJob < ActiveJob::Base
  def perform
  end
end
```

```ruby
job = HelloJob.perform_later
job.cancel
```

Or

```ruby
HelloJob.cancel(job id) # You must use the job id that Active Job provided.
```

If you want to use an id that backend job provided, use the `cancel_by` method.

```ruby
HelloJob.cancel_by(provider_job_id: job_id)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/y-yagi/activejob-cancel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

