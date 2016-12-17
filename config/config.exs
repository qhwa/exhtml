use Mix.Config

# `content_fetcher` can either be a module or a function.
# `MyContentFetcher.fetch` accepts a key and returns content for the key.
config :exhtml,

  # use a function in named module as a fetcher:
  # content_fetcher: &MyContentFetcher.fetch/1,

  # or use an anonymous function:
  # content_fetcher: fn slug -> "#{slug} content on remote" end,
  content_fetcher: nil,

  # where to store contents on disk:
  data_dir: "./exhtml_contents"
