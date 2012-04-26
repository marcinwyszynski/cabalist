# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cabalist/version"

Gem::Specification.new do |s|
  s.name        = "cabalist"
  s.version     = Cabalist::VERSION
  s.authors     = ["Marcin Wyszynski"]
  s.email       = ["marcin.pixie@gmail.com"]
  s.homepage    = "http://github.com/marcinwyszynski/cabalist"
  s.licenses    = ['MIT']
  s.summary     = %q{Minimum setup machine learning (classification) library for Ruby on Rails applications.}
  s.description = <<-EOF
Cabalist is conceived as a simple way of adding some smarts 
(machine learning capabilities) to your Ruby on Rails models 
without having to dig deep into mind-boggling AI algorithms. 
Using it is meant to be as straightforward as adding a few 
lines to your existing code and running a Rails generator or two.
EOF

  s.rubyforge_project = "cabalist"
  s.required_ruby_version = '>= 1.9.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # Gem dependencies
  s.add_dependency('ai4r')
  s.add_dependency('haml',     '>= 3.0')
  s.add_dependency('googlecharts', '>= 1.6.8')
  s.add_dependency('kaminari', '>= 0.13.0')
  s.add_dependency('leveldb-ruby')
  s.add_dependency('padrino-helpers')
  s.add_dependency('rake')
  s.add_dependency('sinatra')
  
  # Gem development dependencies
  s.add_development_dependency('activerecord')
  s.add_development_dependency('rspec')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('with_model')
  
end
