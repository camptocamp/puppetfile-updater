Librarian-sync-puppet
=====================

Puppetfile is a cool format, used by [librarian-puppet](https://github.com/rodjek/librarian-puppet) and [r10k](https://github.com/puppetlabs/r10k) to install and maintain collection of Puppet modules.

However, keeping it up-to-date with newer versions of said modules can be a difficult task.

This gem provides rake tasks to ease this job, by connecting to the Puppet Forge and GitHub and fetching the new versions or references for you.
