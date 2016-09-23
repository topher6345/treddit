class Foo
  CACHE_FOR = 1.minute
  URI = URI.parse('http://httpbin.org/post')

  def self.find(key)
    Rails.cache.fetch(key, expires_in: CACHE_FOR) do
      JSON.parse(post)
    end
  end

  def self.post
    Net::HTTP.post_form(
      URI, {"q" => "My query", "per_page" => "50", "last_updated" => DateTime.now}).body
  end
end
