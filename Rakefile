require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'camptocamp'
  config.project = 'puppetfile-updater'
  config.future_release = '0.5.0'
  config.exclude_labels = ['help wanted','wontfix','invalid']
end
