# berks-monolith

Berks-monolith is a companion command to berkshelf that takes all cookbooks
mentioned in a Berksfile and places development friendly versions of them
under a single directory. Usually, this means you will end up with git clones
for all cookbooks with git repositories in the Berksfile, and static copies of
cookbooks that don't have identifiable VCS repositories.

## Use cases

* You have a Berksfile with many git based sources, and want a quick way to
  clone them all under a single directory.
* You have a mostly monolithic repository, but make use of berkshelf to manage
  dependencies and use external cookbook sources, and you'd like to have
  everything in one place to be able to search.
* You are transitioning between a monolithic repository workflow and a
  independent software artefacts workflow, and have a mix of artefacts in a
  Berksfile as well as cookbooks in a monolithic repository, and you want all
  cookbooks in one place.

## Why not just use X?

The `berks vendor` command comes close to what monolith does, grabbing all
cookbooks mentioned in a Berksfile and putting copies of them under a single
directory. However, berks vendor is intended for production rather than
development use, and explicitly strips any VCS directories, chef ignored
files, and metadata.rb files.

The `berks install` command collects all cookbooks into
`~/.berkshelf/cookbooks`, but again VCS information is stripped out, and this
contains all cookbooks, not just those associated with a specific Berksfile.

## Usage

### berks-monolith install

Clones/copies all cookbooks mentioned in the berksfile. By default they go
into the 'cookbooks' directory. You can specify an alternate path if you wish
by specifying it on the command line: `berks-monolith install vendor`.

Exactly what you get depends on what the source of the cookbook is in the
berksfile:

* Normal community cookbooks (e.g. if you just specify `cookbook 'foo'` with
  no other options) are just copied in place from the berkshelf directory.
* Git cookbooks will result in a clone of the repository pointing to the
  original source repository.
* Path cookbooks will be skipped completely. This means you don't have to
  worry if you have existing local cookbooks in a monolithic repository in
  your Berksfile. They won't be copied again.

### berks-monolith update

Updates the cloned copies of cookbooks if possible. In practice this means
'run git pull' for all git clones.

### berks-monolith clean

Removes all cookbooks that were installed with `berks-monolith install`.
Anything else in the cookbooks directory is left alone.
