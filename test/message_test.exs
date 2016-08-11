defmodule MessageTest do
  use ExUnit.Case
  doctest Message

  test "Can parse verb from GET request" do
  	rawmessage = "GET / HTTP/1.1\nHost: localhost\n\n"
  	message = rawmessage |> Message.parse
  	assert message.verb == "GET"
  end

  setup do
    message = """
    POST / HTTP/1.1
    Host: localhost
    Test: value

    test
    """
    |> Message.parse
    [post: message]
  end

  test "Can parse verb from POST request", context do
  	message = context[:post]
  	assert message.verb == "POST"
  end

  test "Headers contains two items", context do
    message = context[:post]
    assert message.headers |> Enum.count == 2
  end

  test "'Test' header contains 'value'", context do
    message = context[:post]
    assert message.headers[:Test] == "value"
  end

  test "'Host' header contains 'localhost'", context do
    message = context[:post]
    assert message.headers[:Host] == "localhost"
  end
end