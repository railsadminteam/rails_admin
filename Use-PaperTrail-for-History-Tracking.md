RailsAdmin has a nice history tracking mechanism built-in so it "just works" and you don't need to do anything to enable it.  Because it's built into RA, though, it only tracks changes that were made using RA.  Sometimes this isn't good enough - some applications need to track **all** changes made to the database.  In those cases you'll probably want to use a Rails plugin to enable change tracking.  There are many of them, you can see a few at [http://www.ruby-toolbox.com/categories/activerecord_versioning.html](http://www.ruby-toolbox.com/categories/activerecord_versioning.html), although this page assumes that you're using [airblade's PaperTrail gem](https://github.com/airblade/paper_trail).  RA works well with PaperTrail, although not quite perfectly.

At a high level there are two issues to consider: writing history and displaying history.  If you're using a third-party gem to track history you probably want to disable RA's history mechanism entirely.  You can do this with a patch (let's say in an initializer called `config/initializers/rails_admin.rb`):

<pre>
require "rails_admin/abstract_history"
module RailsAdmin
  class AbstractHistory
    def self.create_history_item(message, object, abstract_model, user) ; end
  end
end
</pre>

All we're doing here is stubbing out the method that writes history entries to the database.  This code doesn't make any assumptions about which history gem you're using.

You'll also want to have RA display history from PaperTrail's `Version` model instead of RA's `History` model.  This is a little complicated - what you'll end up doing is patching RA's history interface code to use PaperTrail.  All of this code is in the RailsAdmin::AbstractHistory class that we patched above, so we'll be patching more methods for history display.  You'll need to patch 5 methods: `history_for_model`, `history_for_object`, `history_for_month`, `history_summaries`, and `most_recent_history`.  Add this code to the initializer you created above:

<pre>
    # Fetch the history items for a model.  Returns an array containing
    # the page count and an AR query result containing the history
    # items.
    def self.history_for_model(model, query, sort, sort_reverse, all, page = 1, per_page = 10 || RailsAdmin::Config::Sections::List.default_items_per_page)
      versions = Version.where :item_type => model.pretty_name

      if sort
        versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort)
      end

      if all
        [1, versions]
      else
        page_count = (versions.count.to_f / per_page).ceil
        [page_count, versions.limit(per_page).offset((page.to_i - 1) * per_page)]
      end
    end

    # Fetch the history items for a specific object instance.
    def self.history_for_object(model, object, query, sort, sort_reverse)
      versions = Version.where :item_type => model.pretty_name, :item_id => object.id

      if sort
        versions = versions.order(sort_reverse == "true" ? "#{sort} DESC" : sort)
      end

      versions
    end

    # Fetch the history item counts for a 5-month period.  Ref=0 ends at
    # the present month, ref=-1 is the block before that, etc.
    def self.history_for_month(ref, section)
      current_ref = -5 * ref.to_i
      current_diff = current_ref + 5 - (section.to_i + 1)
      roughly = current_diff.month.ago
      start = Date.new(roughly.year, roughly.month)

      return Version.find(:all, :conditions => ["created_at >= ? AND created_at &lt; ?", start, start.advance(:months=>1)]), roughly
    end

    # Fetch the history item counts for a 5-month period.  Ref=0 ends at
    # the present month, ref=-1 is the block before that, etc.
    def self.history_summaries(ref)
      current_ref = -5 * ref
      current_diff = current_ref + 5 - 1
      roughly = current_diff.month.ago
      start = Date.new(roughly.year, roughly.month)

      months = []
      5.times do
        stop = start.advance(:months=>1)
        months += Version.find_by_sql(["select count(*) as number, ? as year, ? as month from versions where created_at >= ? AND created_at &lt; ?", start.year, start.month, start, stop])
        start = stop
      end
      p months
      months
    end

    # Fetch the most recent history item for a model.
    def self.most_recent_history(name)
      Version.where(:item_type => name).order(:id).limit(1)
    end
</pre>

The last step is to patch PaperTrail so that its `Version` objects quack like RA's `History` objects.  In an initializer called `config/initializers/paper_tail.rb` add the following code:

[Gist 79212](https://gist.github.com/797212)
