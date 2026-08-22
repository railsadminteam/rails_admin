# Continuous integration

RailsAdmin uses [Hudson](http://hudson-ci.org/) as its continuous integration server.

* Test builds are available for public browsing at [ci.railsadmin.org](http://ci.railsadmin.org/)
* An RSS feed for following failed builds is available at [feed://ci.railsadmin.org/job/RailsAdmin/rssFailed](feed://ci.railsadmin.org/job/RailsAdmin/rssFailed)

RailsAdmin is tested with

* jruby-1.6.3 [ linux-i386-java ]
* rbx-1.2.4-20110705 [ ]
* ree-1.8.7-2011.03 [ i386 ]
* ruby-1.8.7-p352 [ i386 ]
* ruby-1.9.2-p290 [ i386 ]

and

* MySQL
* PostgreSQL
* SQLite3

This document describes the Hudson setup used with RailsAdmin in case there's need to duplicate it manually. 

### Installing Hudson on Ubuntu

1. Install key for the hudson repository:
```bash
   wget -O - http://hudson-ci.org/debian/hudson-ci.org.key | sudo apt-key add -
```

2. Add Hudson as source to /etc/apt/sources.list:
```bash
   deb http://hudson-ci.org/debian binary/
```

3. Install Hudson:
```bash
   sudo apt-get update
   sudo apt-get install hudson
```

4. Install ruby1.9-dev to enable native extension building on Rubinius:
```bash
   sudo apt-get install ruby1.9-dev
```

5. Install RVM for the user hudson with rubies 1.8.7, 1.9.2, jruby, rbx-1.2.3 and ree. Also install bundler gem for each ruby.

6. Start Hudson:
```bash
   sudo /etc/init.d/hudson start
```

7. Hudson should be now accessible with a web browser at:
```bash
   http://YOUR_SERVER_IP:8080/
```

### Secure Hudson

1. Go to `Manage Hudson > Configure system`

2. Check `Enable security`

3. Select `Disable` for `TCP port for JNLP slave agents`

3. Select `Hudson's own user database`

4. Select `Matrix-based security`

5. Create user `Neo` ;)

6. Check all ACL rules in the table for user `Neo`

7. Select only `Overall > Read` and `Job > Read` for system user `Anonymous`

8. Check `Prevent Cross Site Request Forgery exploits`

9. Save (Button is in the very bottom of the screen)

9. Go to Manage `Hudson > Manage Users`

10. Create user with username `Neo`


### Configure Hudson:

1. Install following plugins via `Manage Hudson > Manage plugins`
```bash
    Hudson CVS Plug-in
    Git Plugin
    Github plugin
    Locale plugin
    Maven Integration plugin
    Hudson Rake plugin
    Hudson Ruby Plugin
    Hudson ruby metrics plugin
    Hudson SSH Slaves plugin
    Subversion Plugin
```

2. Go to `Manage Hudson > Configure system`

3. Type `1` in to `# of executors` to lower CPU usage.

4. Type `1800` in to `Quiet period` which will make Hudson wait half an hour before starting builds. This will conserve CPU and disk usage a lot during times when commits get pushed at high rate as each new build request during the quiet period will reset the build stack and restart quiet period.

5. Type `en` in to `Locale => Default Language` and check `Ignore browser preference and force this language to all users`. Note: At the time of writing Finnish translation was incomplete and confusing so I wanted to disable translations completely.

6. Save (Button is in the very bottom of the screen)


### Create a job for RailsAdmin:

1. Click `New Job` link on Hudson frontpage

2. Type `RailsAdmin` as the `Job name`, select `Build free-style software project` and click `Ok`

3. Fill in settings:
```bash
    Github project [ https://github.com/sferik/rails_admin/ ]


    [*] Discard Old Builds
    Max number of builds to keep [ 10 ]


    Source Code Management

    [*] Git
    Repositories        URL of repository [ git://github.com/sferik/rails_admin.git ]
    Branches to build   Branch Specifier (blank for default) [ master ]
    Repository browser  (githubweb)
                        URL [ https://github.com/sferik/rails_admin/ ]


    Build Triggers

    [*] Trigger builds remotely (e.g., from scripts)
    Authentication Token [ INSERT A RANDOM TOKEN HERE ]


    Configuration Matrix

    User-defined Axis
    Name   [ CI_RUBY_VERSION ]
    Values [ 1.9.2 1.8.7 ree jruby rbx-1.2.3 ]

    User-defined Axis
    Name   [ CI_DB_ADAPTER ]
    Values [ sqlite3 postgresql mysql ]

    [*] Run each configuration sequentially


    Build

    Execute shell
    Command [ bash -l -c "rvm use $CI_RUBY_VERSION && export CI_DB_ADAPTER=$CI_DB_ADAPTER && rm -f Gemfile.lock && bundle install && cd spec/dummy_app && rm -f Gemfile.lock && bundle install && bundle exec rake rails_admin:prepare_ci_env --trace && cd ../../ && bundle exec rake spec --trace" ]
```

4. Save the job


### Automate _continuous_ integration with a GitHub post-receive hook:

1. Goto RailsAdmin repository's administrative view in GitHub

2. Select `Service Hooks` and add a `Post-Receive URLs` type service hook from `Available Service Hooks`

3. Type http://YOUR_SERVER_IP:8080/job/RailsAdmin/build?token=YOUR_TOKEN to URL

### Additional tasks not covered in this document

* Install Postgres 9.0, create user `rails_admin` and database `ci_rails_admin`
* Install MySQL 5.1 (+ dev package for the mysql gem), create user `rails_admin` and database `ci_rails_admin`
* Configure Nginx as proxy for Hudson accessible at `http://ci.railsadmin.org`

### Links
* [Hudson wiki: Installing Hudson on Ubuntu](http://wiki.hudson-ci.org/display/HUDSON/Installing+Hudson+on+Ubuntu)
* [Install CI Hudson for Ruby on Ubuntu](http://www.allenwei.cn/install-ci-hudson-for-ruby-on-ubuntu/)
* [Setting up Hudson behind Nginx](http://www.elfsternberg.com/2009/11/11/continual-integration-testing-for-web-applications-setting-up-hudson-behind-nginx/)
* [Setting up Hudson on port 80 on a Debian or Ubuntu machine](http://www.zzorn.net/2009/11/setting-up-hudson-on-port-80-on-debian.html)

### Postscript

*The first part of this documentation was written after the actual installation, so there may be factual errors. The most important part though is the job settings, and that has been copied directly from working Hudson
installation and is correct.*