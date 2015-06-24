require 'rake'
require 'rake/tasklib'

class LibrarianSyncPuppet
  # Public: A Rake task that can be loaded and used with everything you need.
  #
  # Examples
  #
  #   require 'librarian-sync-puppet'
  #   LibrarianSyncPuppet::RakeTask.new
  class RakeTask < ::RakeTask::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    # Public: Initialise a new LibrarianSyncPuppet::RakeTask.
    #
    # Example
    #
    #   LibrarianSyncPuppet::RakeTask.new
    def initialize(*args, &task_block)
      @name = args.shift || :lint

      define(args, &task_block)
    end

    def define(args, &task_block)
      desc 'Update module references in the Puppetfile'

      task_block.call(*[self, args].slice(0, task_block.arity)) if task_block

      # clear any (auto-)pre-existing task
      Rake::Task[@name].clear if Rake::Task.task_defined?(@name)

      task @name do
        require 'augeas'
        require 'octokit'
        require 'puppet_forge'

        gh_opts = @gh_login.nil? ? { } : {
          :login    => @gh_login,
          :password => @gh_password,
        }
        github = Octokit::Client.new gh_opts

        basedir = File.dirname(__FILE__)
        lens_dir = File.expand_path(File.join(basedir, 'lenses'))
        Augeas.open(basedir, lens_dir, Augeas::NO_MODL_AUTOLOAD) do |aug|
          aug.transform(
            :incl => '/Puppetfile',
            :excl => [],
            :lens => 'Puppetfile.lns',
            :name => 'Puppetfile',
          )
          aug.load!
          update_github_refs(aug, github, user)
          update_forge_refs(aug, user)
          aug.save!
        end
      end
    end
  end
end
