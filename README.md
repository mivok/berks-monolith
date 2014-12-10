# Berkshelf Monolith plugin

This plugin adds a new subcommand `monolith` to berkshelf, which gets all
cookbooks mentioned in a Berksfile and places development friendly versions of
them under a single directory. Usually, this means you will end up with git
clones for all cookbooks with git repositories in the Berksfile, and static
copies of cookbooks that don't have identifiable VCS repositories.

## WARNING

Currently this is not ready for use. It only supports the initial
cloning of git/github URLs, and for the moment requires that berkshelf be
called with the bin/monolith wrapper script.

## Use cases

* You have a Berksfile with many git based sources, and want a quick way to
  clone them all under a single directory.
* You have a monolithic repository, but make use of berkshelf to manage
  dependencies and use external key sources, and you'd like to have everything
  in one place to be able to search.
* You are transitioning between a monolithic repository workflow and a
  independent software artefacts workflow, and have a mix of artefacts in a
  Berksfile as well as cookbooks in a monolithic repository, and you want all
  cookbooks in one place.

## Why not X?

The `berks vendor` command comes close to what monolith does, grabbing all
cookbooks mentioned in a Berksfile and putting copies of them under a single
directory. However, berks vendor is intended for production rather than
development use, and explicitly strips any VCS directories, chef ignored
files, and metadata.rb files.

The `berks install` command collects all cookbooks into
`~/.berkshelf/cookbooks`, but again VCS information is stripped out, and this
contains all cookbooks, not just those associated with a specific Berksfile.
