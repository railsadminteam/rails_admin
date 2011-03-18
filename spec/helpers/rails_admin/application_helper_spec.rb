require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the GenresHelper. For example:
#
# describe GenresHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe RailsAdmin::ApplicationHelper do
  describe "javascript_fallback" do
    it "should description" do
      helper_html = helper.javascript_fallback "http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js", "/javascripts/jquery-1.4.3.min.js", "typeof jQuery == 'undefined'"
      helper_html.should == <<-HTML.strip_heredoc
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js" type="text/javascript"></script>
        <script type="text/javascript">
          if (typeof jQuery == 'undefined') {
            document.write(unescape("%3Cscript src='/javascripts/jquery-1.4.3.min.js' type='text/javascript'%3E%3C/script%3E"));
          }
        </script>
      HTML
    end
  end
end
