# Exhtml

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

## Setup

TODO: allow custom configuration

## Usage

```elixir
# set content fetcher
Exhtml.set_content_fetcher fn slug ->
  # fetch content by slug from remote
  # ...
  "#{slug} content on remote"
end

# update content.
# Notice: contents live in memory and automaticly persisted in disk.
Exhtml.update_content :my_page

# later, get content:
Exhtml.get_content :my_page
#=> "my_page content on remote"
```
