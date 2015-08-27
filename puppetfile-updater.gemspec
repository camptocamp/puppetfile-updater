Gem::Specification.new do |spec|
  spec.name        = 'puppetfile-updater'
  spec.version     = '0.3.0'
  spec.homepage    = 'https://github.com/camptocamp/puppetfile-updater'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Camptocamp'
  spec.email       = 'raphael.pinson@camptocamp.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'augeas/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'Keep your Puppetfile up-to-date.'
  spec.description = <<-EOF
    Keep your Puppet file up-to-date with latest versions from the Forge and GitHub.
  EOF

  spec.add_dependency 'rake'
  spec.add_dependency 'ruby-augeas'
  spec.add_dependency 'octokit'
  spec.add_dependency 'puppet_forge'
end
