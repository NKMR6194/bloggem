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

  def test_escape_entry
    entry = Entry.new
    entry.body = "<p>hello\ngem\n</p><pre class='format'>hello\ngem\n</pre>aaa"
    assert_equal(
      "<p>hello<br />gem<br /></p><pre class='format'>hello\ngem\n</pre>aaa",
      entry.text
      )

    entry = Entry.new
    entry.body = "<pre>a\nb</pre><pre>a\nb</pre><pre>a\nb</pre>"
    assert_equal(
      "<pre>a\nb</pre><pre>a\nb</pre><pre>a\nb</pre>",
      entry.text
      )

    entry = Entry.new
    entry.body = "<pre>a\nb</pre>d[read_more]\ne<pre>a\nb</pre><pre>a\nb</pre>"
    assert_equal(
      "<pre>a\nb</pre>d",
      entry.text
      )

    entry = Entry.new
    entry.body = "<pre>a\nb</pre>d[read_more]\ne<pre>a\nb</pre><pre>a\nb</pre>"
    assert_equal(
      "<pre>a\nb</pre>d<br />e<pre>a\nb</pre><pre>a\nb</pre>",
      entry.text(false)
      )
  end
end
