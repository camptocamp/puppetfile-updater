require 'rake'
require 'rake/tasklib'

class PuppetfileUpdater
  # Public: A Rake task that can be loaded and used with everything you need.
  #
  # Examples
  #
  #   require 'librarian-sync-puppet'
  #   PuppetfileUpdater::RakeTask.new
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :user
    attr_accessor :module
    attr_accessor :major
    attr_accessor :gh_login
    attr_accessor :gh_password

    # Public: Initialise a new PuppetfileUpdater::RakeTask.
    #
    # Example
    #
    #   PuppetfileUpdater::RakeTask.new
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

        @user ||= '.*'

        gh_opts = @gh_login.nil? ? { } : {
          :login    => @gh_login,
          :password => @gh_password,
        }
        github = Octokit::Client.new gh_opts

        libdir = File.dirname(__FILE__)
        lens_dir = File.expand_path(File.join(libdir, '..', '..', 'augeas', 'lenses'))
        Augeas.open(Dir.pwd, lens_dir, Augeas::NO_MODL_AUTOLOAD) do |aug|
          aug.transform(
            :incl => '/Puppetfile',
            :excl => [],
            :lens => 'Puppetfile.lns',
            :name => 'Puppetfile',
          )
          aug.load!

          error_path = '/augeas/files/Puppetfile/error'
          unless aug.match('/augeas/files/Puppetfile/error').size == 0
            msg = "Failed to parse Puppetfile at line #{aug.get(error_path+'/line')}, "
            msg << "character #{aug.get(error_path+'/char')}: "
            msg << aug.get('/augeas/files/Puppetfile/error/message')
            abort msg
          end

          # Update from GitHub
          aug.match("/files/Puppetfile/*[git=~regexp('.*/#{@user}/.*')]").each do |mpath|
            m = aug.get(mpath)
            next if !@module.nil? && @module != m.gsub(%r{.*[-/]}, '')

            warn "W: #{m} is a fork!" unless m =~ /#{@user}/

            git_url = aug.get("#{mpath}/git")
            repo = Octokit::Repository.from_url(git_url.gsub(/\.git$/, ''))
            commits = github.commits(repo)
            aug.set("#{mpath}/ref", commits[0].sha[0...7])
          end

          # Update from Forge
          PuppetForge.user_agent = 'Puppetfile-Updater/0.1.0'
          aug.match("/files/Puppetfile/*[label()!='#comment' and .=~regexp('#{@user}/.*') and @version]").each do |mpath|
            m = aug.get(mpath).gsub('/', '-')
            next if !@module.nil? && @module != m.gsub(%r{.*[-/]}, '')
            v = aug.get("#{mpath}/@version")
            forge_m = PuppetForge::Module.find(m)
            release = forge_m.releases.select { |r| r.deleted_at.nil? }[0]
            new_v = release.version
            if new_v.split('.')[0] != v.split('.')[0]
              if @major
                warn "W: #{m} has incompatible changes between #{v} and #{new_v}"
                aug.set("#{mpath}/@version", new_v)
              else
                warn "W: Not upgrading #{m} from #{v} to new major version #{new_v}"
              end
            else
              warn "W: #{m} got new features between #{v} and #{new_v}" if new_v.split('.')[1] != v.split('.')[1]
              aug.set("#{mpath}/@version", new_v)
            end
          end

          aug.save!
        end
      end
    end
  end
end
