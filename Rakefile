require 'rake/testtask'
require 'bundler/setup'
Bundler.setup
require 'releasy'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs = ['lib']
  t.warning = false
  t.verbose = true
  t.test_files = FileList['test/**/*_test.rb']
end

Releasy::Project.new do
  name 'Bump'
  version '1.0.0'
  executable 'bin/bump'
  verbose
  files ['lib/**/*.rb', 'data/**/*.yml', 'template/**/*.*', 'bin/**/*.*']
  exposed_files 'README.md'
  add_link 'http://github.com/timcolonel/bump', 'Homepage'
  exclude_encoding

  add_build :source do
    add_package :'7z'
  end

  add_build :windows_folder do
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe # Windows self-extracting archive.
  end

  add_deploy :local
end

