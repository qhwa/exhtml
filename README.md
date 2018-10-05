# Exhtml

![travis-status](https://travis-ci.org/qhwa/exhtml.svg?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/6dbd64f1b04149eda13f555ebc343543)](https://www.codacy.com/app/qhwa/exhtml?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=qhwa/exhtml&amp;utm_campaign=Badge_Grade)
[![Inline docs](http://inch-ci.org/github/qhwa/exhtml.svg)](http://inch-ci.org/github/qhwa/exhtml)

Exhtml is a library that handles HTML page serving.
There are some benifts to have a dynamic HTML page host rather than static server:

1.it's easy to deploy a small number of pages.
2.it's safer to make the HTML server pull content from backend storage than push contents to it.
3.you can add middlewares as you wish, such as performance monitoring, server-side procsessing, etc..

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

1.Add `exhtml` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:exhtml, "~> 0.1.0"}]
  end
  ```

2.Ensure `exhtml` is started before your application:

  ```elixir
  def application do
    [applications: [:exhtml]]
  end
  ```

3.(optional) Add configuration into your project:

  ```elixir
  use Mix.Config

  # `content_fetcher` can either be a module or a function
  # `MyContentFetcher.fetch` accepts a key and returns content for the key.
  config :exhtml,
  
  # use a function in named module as a fetcher:
  # content_fetcher: &MyContentFetcher.fetch/1,

  # or use an anonymous function:
  content_fetcher: fn slug -> "#{slug} content on remote" end,

  # where to store contents on disk:
  data_dir: "/home/data/exhtml_contents"
  ```

## Usage

```elixir
# update content.
# Notice: contents live in memory and automaticly persisted in disk.
Exhtml.update_content :my_page

# later, get content:
Exhtml.get_content :my_page
#=> "my_page content on remote"
```

[Online documents](https://hexdocs.pm/exhtml/Exhtml.html)

## License

MIT liccense

## Contributions

*[Pull requests](https://github.com/qhwa/exhtml/pulls) are welcome.
*[Issues here](https://github.com/qhwa/exhtml/issues)
