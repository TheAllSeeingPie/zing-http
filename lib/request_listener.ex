alias Experimental.GenStage

defmodule RequestListener do
	use GenStage

	def init(port) do
		case :gen_tcp.listen(port, [:binary, active: false]) do
			{:ok, server} ->
				{:producer, server}
			{:error, reason} ->
				IO.puts "Start failed: #{reason}"
		end
	end

	def handle_demand(demand, server) when demand > 0 do
		IO.puts "RequestListener handle_demand"
		events = accept_connections(demand, server)
		{:noreply, events, server}
	end

	def accept_connections(demand, server) do
		IO.puts "RequestListener accept_connections"
		case server |> :gen_tcp.accept do
			{:ok, client} ->
				[client]
			{:error, reason} ->
				IO.puts "Server faulted: #{reason}"
		end
	end
end