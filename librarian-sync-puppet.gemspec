Gem::Specification.new do |spec|
  spec.name        = 'librarian-sync-puppet'
  spec.version     = '0.1.0'
  spec.homepage    = 'https://github.com/camptocamp/librarian-sync-puppet'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Camptocamp'
  spec.email       = 'raphael.pinson@camptocamp.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'Keep your Puppetfile up-to-date.'
  spec.description = <<-EOF
    Keep your Puppet file up-to-date with latest versions from the Forge and GitHub.
  EOF

  spec.add_development_dependency 'rake'
end
