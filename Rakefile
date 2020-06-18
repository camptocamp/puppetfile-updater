require 'github_changelog_generator/task'

task :default do
  puts "Nothing to do for now"
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'camptocamp'
  config.project = 'puppetfile-updater'
  config.future_release = '0.6.0'
  config.exclude_labels = ['help wanted','wontfix','invalid']
end
