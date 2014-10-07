require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

desc 'Run RSpec code examples with simplecov'
task :cov do
  ENV['WEAVR_COV'] = 'true'
  Rake::Task[:spec].invoke
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:spec]
