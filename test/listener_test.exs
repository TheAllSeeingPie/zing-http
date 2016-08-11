alias Experimental.GenStage

defmodule ListenerTest do
  use ExUnit.Case
  doctest RequestListener

  test "Dispatcher chain allows stuff to run" do
    {:ok, request_listener} = GenStage.start_link(RequestListener, 8000)
    {:ok, request_dispatcher} = GenStage.start_link(RequestDispatcher, :ok)
    {:ok, request_processor} = GenStage.start_link(RequestProcessor, :ok)

    GenStage.sync_subscribe(request_processor, to: request_dispatcher)
    GenStage.sync_subscribe(request_dispatcher, to: request_listener)
    
    {:ok, socket} = :gen_tcp.connect('localhost', 8000, [:binary, active: false])
    :gen_tcp.send(socket, "GET / HTTP/1.1\nHost: localhost\n\n")
    1000 |> :timer.sleep
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
          IO.puts data
          assert data == "Hello world!"
        {:error, reason} ->
          IO.puts "Client faulted/closed: #{reason}"
    end
    socket |> :gen_tcp.close
    1000 |> :timer.sleep
  end

  #test "Run a little hello world type thing ..." do
  	#task = fn -> Listener.start end |> Task.async
  	#{:ok, socket} = :gen_tcp.connect('localhost', 8000, [:binary, active: false])
  	#:gen_tcp.send(socket, "Hello, world!")
  	#socket |> :gen_tcp.close
  	#1000 |> :timer.sleep
  	#Task.shutdown(task, :brutal_kill)
  #end
end
