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

    $ bundle exec rake db:pull

## 6. Setup Solr

    $ rake sunspot:solr:start
    $ rake sunspot:solr:reindex




## Problems With Solr

Here is the process Richard was able to take to make solr start working again. Be careful with the `rm` command if you don't specify the correct target, you can delete valuable information



ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ rm -rf solr/

ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ ps aux |grep solr
rubyku         11998   0.0  0.7  2820704  60836   ??  Ss    7:59pm   0:56.51 /usr/bin/java -Djetty.port=8982 -Dsolr.data.dir=/Users/rubyku/Desktop/hourschool_v2/solr/data/development -Dsolr.solr.home=/Users/rubyku/Desktop/hourschool_v2/solr -Djava.util.logging.config.file=/var/folders/r6/nv2w5w9s1cz_lrpfp596gvnh0000gn/T/logging.properties20120209-11998-124njea -jar start.jar
rubyku          4415   0.0  0.9  2828832  76236   ??  Ss    4:49pm   1:09.12 /usr/bin/java -Djetty.port=8982 -Dsolr.data.dir=/Users/rubyku/Desktop/hourschool_v2/solr/data/development -Dsolr.solr.home=/Users/rubyku/Desktop/hourschool_v2/solr -Djava.util.logging.config.file=/var/folders/r6/nv2w5w9s1cz_lrpfp596gvnh0000gn/T/logging.properties20120209-4415-12vcbm6 -jar start.jar
rubyku         40704   0.0  0.0  2434892    536 s000  S+   10:17am   0:00.00 grep solr


ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ kill -9 11998

ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ ps aux |grep solr
rubyku          4415   0.0  0.9  2828832  76236   ??  Ss    4:49pm   1:09.13 /usr/bin/java -Djetty.port=8982 -Dsolr.data.dir=/Users/rubyku/Desktop/hourschool_v2/solr/data/development -Dsolr.solr.home=/Users/rubyku/Desktop/hourschool_v2/solr -Djava.util.logging.config.file=/var/folders/r6/nv2w5w9s1cz_lrpfp596gvnh0000gn/T/logging.properties20120209-4415-12vcbm6 -jar start.jar
rubyku         40750   0.0  0.0  2425480     24 s000  R+   10:17am   0:00.00 grep solr

ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ kill -9 4415


ruby-1.9.2-p290@hourschool  ~/Desktop/hourschool_v2 (rubyku/campaign)
→ rake sunspot:solr:start



##Using pow for sub-domains

    $ cd ~/.pow
    $ ln -s ~/Desktop/hourschool hourschool
    $ open http://subdomain.hourschool.dev/

    #When using pow and want to view logs, go back to project directory in terminal and run
    $ tail -f log/development.log


## Viewing HTML emails in browser

http://localhost:3000/mail_view/user_mailer/preview

http://localhost:3000/mail_view/student_mailer/preview



## Viewing routes in browser

http://localhost:3000/rake/routes


