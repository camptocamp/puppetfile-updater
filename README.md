Puppetfile-updater
===================

[![Build Status](https://img.shields.io/travis/camptocamp/puppetfile-updater.svg)](https://travis-ci.org/camptocamp/puppetfile-updater)
[![Gem Version](https://img.shields.io/gem/v/puppetfile-updater.svg)](https://rubygems.org/gems/puppetfile-updater)
[![Gem Downloads](https://img.shields.io/gem/dt/puppetfile-updater.svg)](https://rubygems.org/gems/puppetfile-updater)
[![Coverage Status](https://img.shields.io/coveralls/camptocamp/puppetfile-updater.svg)](https://coveralls.io/r/camptocamp/puppetfile-updater?branch=master)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppetfile-updater.svg)](https://gemnasium.com/camptocamp/puppetfile-updater)

Puppetfile is a cool format, used by [librarian-puppet](https://github.com/rodjek/librarian-puppet) and [r10k](https://github.com/puppetlabs/r10k) to install and maintain collection of Puppet modules.

However, keeping it up-to-date with newer versions of said modules can be a difficult task.

This gem provides rake tasks to ease this job, by connecting to the Puppet Forge and GitHub and fetching the new versions or references for you.
