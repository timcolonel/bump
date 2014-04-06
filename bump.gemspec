$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'bump/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'bumper'
  s.version = Bump::VERSION
  s.authors = ['Timothee Guerin']
  s.email = %w(timothee.guerin@outlook.com)
  s.homepage = 'http://github.com/timcolonel/bump'
  s.summary = 'Bump the version of your project'
  s.description = 'Bump the version of your project.'

  s.files = Dir['{data,bin,config,template,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.license = 'MIT'
  s.test_files = Dir['test/**/*']
  s.executables = ['bump']

  s.add_dependency 'rake'
  s.add_dependency 'activesupport'
  s.add_dependency 'minitest'
  s.add_dependency 'minitest-reporters'
  s.add_dependency 'coveralls'
end