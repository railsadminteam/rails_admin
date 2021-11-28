# Excluding RailsAdmin from NewRelic

You may want to ignore RailsAdmin controllers and actions from metrics gathering in NewRelic by default. There are a couple ways to do so.

1. Monkey patch RailsAdmin to call `newrelic_ignore`:

```ruby
# in an initializer
module RailsAdmin
  class ApplicationController
    newrelic_ignore if defined?(NewRelic)
  end
end
```

2. Ignore your RailsAdmin endpoints via url blacklist. NewRelic has some information on the topic here: https://docs.newrelic.com/docs/agents/ruby-agent/installation-configuration/ignoring-specific-transactions#config-ignoring. Essentially, you just need to add a rule to your newrelic.yml like (assuming you've mounted RailsAdmin under `/admin`):

```
rules:
  ignore_url_regexes: ["^/admin"]
```
