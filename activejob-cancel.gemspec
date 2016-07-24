lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job/cancel/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob-cancel"
  spec.version       = ActiveJob::Cancel::VERSION
  spec.authors       = ["Yuji Yaginuma"]
  spec.email         = ["yuuji.yaginuma@gmail.com"]

  spec.summary       = %q{activejob-cancel provides cancel method to Active Job}
  spec.homepage      = "https://github.com/y-yagi/activejob-cancel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activejob', '>= 4.2.0'
  spec.add_dependency 'activesupport', '>= 4.2.0'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "activerecord", '>= 4.2.0'
  spec.add_development_dependency "delayed_job"
  spec.add_development_dependency "delayed_job_active_record"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "sucker_punch"
  spec.add_development_dependency "byebug"
end
