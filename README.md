# Exhtml

> This project is under active developement and is unreliable at this moment. DO NOT use it in your production.

Exhtml is a library that handles HTML page serving.
There are some benifts to have a dynamic HTML page host rather than static server:

1. it's easy to deploy a small number of pages.
2. it's safer to make the HTML server pull content from backend storage than push contents to it.
3. you can add middlewares as you wish, such as performance monitoring, server-side procsessing, etc..

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `exhtml` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exhtml, "~> 0.1.0-beta.1"}]
    end
    ```

  2. Ensure `exhtml` is started before your application:

    ```elixir
    def application do
      [applications: [:exhtml]]
    end
    ```

  3. (optional) Add configuration into your project:

    ```elixir
    use Mix.config

    # `content_fetcher` can either be a module or a function.
    # `MyContentFetcher.fetch` accepts a key and returns content for the key.
    config :exhtml, content_fetcher: &MyContentFetcher.fetch/1
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


