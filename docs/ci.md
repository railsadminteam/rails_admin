# Continuous integration

RailsAdmin uses [Hudson](http://hudson-ci.org/) as its continuous integration server. Test builds are available for public browsing at [178.79.146.205:8080](http://178.79.146.205:8080/).

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

4. Install RVM for the user hudson with rubies ruby 1.8.7, 1.9.2, ree and jruby.

5. Start Hudson:
```bash
   sudo /etc/init.d/hudson start
```

6. Hudson should be now accessible with a web browser at:
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

3. Type `en` in to `Locale => Default Language` and check `Ignore browser preference and force this language to all users`. Note: At the time of writing Finnish translation was incomplete and confusing so I wanted to disable translations completely.

4. Save (Button is in the very bottom of the screen)


### Create a job for RailsAdmin:

1. Click `New Job` link on Hudson frontpage

2. Type `RailsAdmin` as the `Job name`, select `Build free-style software project` and click `Ok`

3. Fill in settings:
```bash
    Github project [ https://github.com/sferik/rails_admin/ ]


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
    Name   [ RUBY_VERSION ]
    Values [ 1.9.2 1.8.7 ree jruby ]

    [*] Run each configuration sequentially


    Build

    Execute shell
    Command [ bash -l -c "rvm use $RUBY_VERSION && bundle install && bundle exec rake" ]
```

4. Save the job


### Automate _continuous_ integration with a GitHub post-receive hook:

1. Goto RailsAdmin repository's administrative view in GitHub

2. Select `Service Hooks` and add a `Post-Receive URLs` type service hook from `Available Service Hooks`

3. Type http://YOUR_SERVER_IP:8080/job/RailsAdmin/build?token=YOUR_TOKEN to URL


### Postscript

*The first part of this documentation was written after the actual installation, so there may be factual errors. The most important part though is the job settings, and that has been copied directly from working Hudson
installation and is correct.*