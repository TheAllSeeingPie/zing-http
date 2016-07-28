defmodule MessageTest do
  use ExUnit.Case
  doctest Message

  test "Can parse verb from GET request" do
  	rawmessage = "GET / HTTP/1.1\nHost: localhost\n\n"
  	message = rawmessage |> Message.parse
  	assert message.verb == "GET"
  end

  test "Can parse verb from POST request" do
  	rawmessage = """
  	POST / HTTP/1.1
  	Host: localhost
  	Test: value

  	test
  	"""
  	message = rawmessage |> Message.parse
  	assert message.verb == "POST"
  	assert message.headers |> Enum.count == 2
  end
end