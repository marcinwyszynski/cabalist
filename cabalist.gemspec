# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cabalist/version"

Gem::Specification.new do |s|
  s.name        = "cabalist"
  s.version     = Cabalist::VERSION
  s.authors     = ["Marcin Wyszynski"]
  s.email       = ["marcin.pixie@gmail.com"]
  s.homepage    = "http://github.com/marcinwyszynski/cabalist"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "cabalist"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # Gem dependencies
  s.add_dependency('ai4r')
  s.add_dependency('haml',     '>= 3.0')
  s.add_dependency('kaminari', '>= 0.13.0')
  s.add_dependency('leveldb-ruby')
  s.add_dependency('padrino-helpers')
  s.add_dependency('sinatra')
  
  # Gem development dependencies
  s.add_development_dependency('activerecord')
  s.add_development_dependency('rspec')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('with_model')
  
end
