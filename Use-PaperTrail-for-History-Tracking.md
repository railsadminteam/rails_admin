RailsAdmin has a nice history tracking mechanism built-in so it "just works" and you don't need to do anything to enable it.  Because it's built into RA, though, it only tracks changes that were made using RA.  Sometimes this isn't good enough - some applications need to track **all** changes made to the database.  In those cases you'll probably want to use a Rails plugin to enable change tracking.  There are many of them, you can see a few at [http://www.ruby-toolbox.com/categories/activerecord_versioning.html](http://www.ruby-toolbox.com/categories/activerecord_versioning.html) .  It would be nice if RailsAdmin could get its history data from a third-party gem; the good news is that this works pretty well, although not perfectly.

At a high level there are two issues to consider: writing history records and displaying history data.  If you're using a third-party gem to track history you probably want to disable RA's history mechanism entirely.  You can do this with a patch (let's say in an initializer called `config/initializers/rails_admin.rb`):

<pre>
require "rails_admin/abstract_history"
module RailsAdmin
  class AbstractHistory
    def self.create_history_item(message, object, abstract_model, user) ; end
  end
end
</pre>

All we're doing here is stubbing out the method that writes history entries to the database.
