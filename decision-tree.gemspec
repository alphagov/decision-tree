# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "decision-tree"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Russell Garner"]
  s.email       = ["rgarner@zephyros-systems.co.uk"]
  s.homepage    = ""
  s.summary     = %Q{Create and traverse decision trees}

  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE.txt README.rdoc Gemfile Gemfile.lock VERSION)
  s.executables  = []
  s.require_path = 'lib'
end