# Hourschool


## Welcome

**Please have some tea**

# Set up Git

First, make sure `git` is installed: `which git`. If it's not installed,
follow directions below to install Homebrew then run `brew install git`.

Most importantly, set your full name and email correctly:

    $ git config --global user.name "Your Name"
    $ git config --global user.email "you@gmail.com"

Then set these very helpful options:

    $ git config --global --bool branch.autosetupmerge true
    $ git config --global branch.autosetuprebase always
    $ git config --global push.default tracking
    $ git config --global core.autocrlf input
    $ git config --global help.autocorrect 1

# Bootstrapping a Development Environment

## 1. OS X with Developer Tools (Xcode)

Have OSX 10.6+ and Xcode installed. Get the OS X/Developer Tools DVD from
someone in the office, or get the .dmg from a local share somewhere. Don't
download it from Apple—it's over 4GB.

## 2. Homebrew & RVM

We use [Homebrew][1] for OS X package management and [RVM][2] for Ruby version
management.

 [1]: http://mxcl.github.com/homebrew/
 [2]: https://rvm.beginrescueend.com/

Prepare your `/usr/local` dir for use with Homebrew:

    $ sudo chown -R `whoami` /usr/local

[Install homebrew][3] - Follow their recommended installation.

 [3]: https://github.com/mxcl/homebrew/wiki/installation

Use GCC for compiling, otherwise Postgres and friends get angry:

    export CC=/usr/bin/gcc-4.2
    export CXX=/usr/bin/g++-4.2

Install the software packages we use (via Homebrew):

    $ brew install postgresql redis memcached solr ec2-api-tools

Update your PATH before continuing to rvm install:

    export PATH="${PATH}:${HOME}/.gem/ruby/1.8/bin"

[Install RVM][4] - Follow their recommended installation.

 [4]: http://rvm.beginrescueend.com/rvm/install/



## 3. Install the app, install gems, set up a PostgreSQL DB

First check out a copy of the app from GitHub andd acquaint it with RVM:

    $ git clone #...
    $ cd #...
    # Tell rvm to approve and trust the .rvmrc file. (<Ent>, q, "yes", <Ent>)

Then install bundler and bundle the gems:

    $ gem install bundler
    $ bundle install

Then initialize a new PostgreSQL database:

    $ initdb /usr/local/var/postgres

## 4. Start up peripheral servers

Either install the provided `launchctl` configs and use `lunchy` to start them:

    $ ./local/launchctl-setup
    $ lunchy start postgres
    $ lunchy start redis
    $ lunchy start memcache

(Note: You may need to update the plists in ~/Library/LaunchAgents/ with paths for the current versions and restart with lunchy)

Or start the servers manually (and manage them manually from now on):

    $ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    $ redis-server local/redis.conf
    $ memcached &

## 4. Seed your development database

    $ rake db:setup

## 5. Pull the Production DB from heroku

    $ heroku db:pull --app sharp-sunset-8021

## 6. Setup Solr

    $ rake sunspot:solr:start
    $ rake sunspot:solr:reindex
