json.array!(@subtreddits) do |subtreddit|
  json.extract! subtreddit, :id, :name, :description
  json.url subtreddit_url(subtreddit, format: :json)
end
