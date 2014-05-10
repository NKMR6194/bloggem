require 'minitest/autorun'
require './main.rb'
require 'rack/test'

class BlogGemTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  ActiveRecord::Base.establish_connection(
    "adapter" => "sqlite3",
    "database" => "./page.db"
    )

  def app
    BlogGem
  end

  def test_escape_comment
    comment = Comment.new

    comment.body = "\ntest\ntest\n"
    assert_equal '<br />test<br />test<br />', comment.text

    comment.body = "<script>alert('Denger!');</script>"
    assert_equal(
      '&lt;script&gt;alert(&#x27;Denger!&#x27;);&lt;&#x2F;script&gt;',
      comment.text
      )
  end
end
