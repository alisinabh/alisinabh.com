defmodule AlisinabhBlog.PostTests do
  use AlisinabhBlog.ConnCase

  test "Check if inserting new post is ok" do
    require AlisinabhBlog.Database

    :ok = AlisinabhBlog.Database.upsert_post("1234123412", "This is the test post", "This is the test ``post_body``")
  end
end
