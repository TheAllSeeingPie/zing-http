alias Experimental.GenStage

defmodule RequestDispatcher do
	use GenStage

	def init(_) do
		{:producer_consumer, :ok}
	end

	def handle_events(events, _from, number) do
		IO.puts "RequestDispatcher handle_events"
		events = Enum.map(events, fn client -> client |> process_client end)
		{:noreply, events, number}
	end

	def process_client(client) do	
		case :gen_tcp.recv(client, 0) do
			{:ok, data} ->
		   		data |> Message.parse
		   	{:error, reason} ->
		   		IO.puts "Client faulted/closed: #{reason}"
		end
	end
end