defmodule AlisinabhBlog.FeedView do
  use AlisinabhBlog.Web, :view
  use Timex

  def parse_markdown(markdown), do: Earmark.to_html(markdown)

  def date_format(edate) do
   {:ok, date} = Timex.Format.DateTime.Formatter.format(edate, "%a, %d %b %Y %H:%M:%S %z", :strftime)
   date
  end
end
