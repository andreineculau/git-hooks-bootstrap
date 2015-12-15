# git hooks bootstrap

This is a collection of git "server" hooks (i.e. hooks to check commits being pushed to the server).

The collection is built for
[Atlassian Bitbucket Server](https://www.atlassian.com/software/bitbucket/server) (formerly known as Atlassian Stash) with the
[External Hooks](https://marketplace.atlassian.com/plugins/com.ngs.stash.externalhooks.external-hooks)
plugin, which implements pre- and post- (async) hooks on `git push` á la [gitolite](http://gitolite.com).

Beyond the dependencies on the environment variables below,
the scripts are abstract and can be used in any other environment.
They should also run with minimal intervention/configuration,
but they are not meant to be an off-the-shelf product - merely a bootstrap and a FAQ solution for a common set of questions: filtering branch names, filtering whitespace commits, notifying external systems of commits referencing a ticket, etc.


## Structure

Hooks should be organized by `project/repository`.

Each `project/repository` folder should contain a `pre` and `post` symlinking to the root `hook.tpl`,
and then implement `pre.process_range.<function>` and/or `post.process_range.<function>` scripts,
which will be run in alphabetical order.

These `process_range` scripts will be called once per range
i.e. ref being updated from one SHA to another.
Each `process_range` script has a `process_range`, `process_sha` (and maybe a `process_file`), `process_ref` functions
that are run in a flow like this:

* process range
  * each range has 1+ commits (SHAs), so process those
    * each commits has 1+ files, so process those
* process ref

Have a look at the existing hooks on how to write new ones. A template for the `*.process_range.*` scripts exist in [hook.process_range.tpl](hook.process_range.tpl).


## Environment variables

Each shell script can make use of the following environment variables:

From https://github.com/ngsru/atlassian-external-hooks/wiki/Configuration:

> Also, there are number of environment variables, that will be passed to executable:
> * `STASH_USER_NAME` --- name of the user that invokes a push;
> * `STASH_USER_EMAIL` --- e-mail of that user;
> * `STASH_REPO_NAME` --- repository name, without `.git` part;
> * `STASH_IS_ADMIN` --- either "true" or "false", when user either is repo admin or not.
> * `STASH_PROJECT_NAME` --- human-readable name of the project repository belongs to;
> * `STASH_PROJECT_KEY` --- project key for the repository;
> * `STASH_BASE_URL` --- base URL where Stash instance is hosted;
> * `STASH_REPO_CLONE_SSH` --- SSH URL which can be used for cloning repo;
> * `STASH_REPO_CLONE_HTTP` --- same, but for HTTP;

As well as

`STASH_ADMIN_HOME` --- e.g. /home/atlstash/stash-admin
`STASH_WWW_BASE_URL` --- e.g. https://stash.example.com
`STASH_GIT_BASE_URL` --- e.g. git@stash.example.com
`STASH_REPO_MAIN_REFS` --- e.g. refs/heads/master refs/heads/develop

Defaults for these environment variables are provided in the root of `env.sh`,
that can be overridden by `project/repository/env.sh`.
