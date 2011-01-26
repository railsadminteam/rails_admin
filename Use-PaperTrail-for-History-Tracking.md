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

[Gist 797219](https://gist.github.com/797219)

The last step is to patch PaperTrail so that its `Version` objects quack like RA's `History` objects.  In an initializer called `config/initializers/paper_tail.rb` add the following code:

[Gist 797212](https://gist.github.com/797212)
