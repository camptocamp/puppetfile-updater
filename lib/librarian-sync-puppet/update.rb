class LibrarianSyncPuppet
  module Update
    def github(aug, github, user='.*', mod)
      aug.match("/files/Puppetfile/*[git=~regexp('.*/#{user}/.*')]").each do |mpath|
        m = aug.get(mpath)
        next if mod && mod != m.gsub(%r{.*[-/]}, '')

        warn "W: #{m} is a fork!" unless m =~ /#{user}/

        git_url = aug.get("#{mpath}/git")
        repo = Octokit::Repository.from_url(git_url.gsub(/\.git$/, ''))
        commits = github.commits(repo)
        aug.set("#{mpath}/ref", commits[0].sha[0...7])
      end
    end

    def forge(aug, user='.*', mod)
      PuppetForge.user_agent = 'Librarian-Sync-Puppet/0.1.0'
      aug.match("/files/Puppetfile/*[label()!='#comment' and .=~regexp('#{user}/.*') and @version]").each do |mpath|
        m = aug.get(mpath).gsub('/', '-')
        next if mod && mod != m.gsub(%r{.*[-/]}, '')
        v = aug.get("#{mpath}/@version")
        forge_m = PuppetForge::Module.find(m)
        new_v = forge_m.releases[0].version
        if new_v.split('.')[0] != v.split('.')[0]
          warn "W: Not upgrading #{m} from #{v} to new major version #{new_v}"
        else
          warn "W: #{m} got new features between #{v} and #{new_v}" if new_v.split('.')[1] != v.split('.')[1]
          aug.set("#{mpath}/@version", forge_m.releases[0].version)
        end
      end
    end
  end
end
