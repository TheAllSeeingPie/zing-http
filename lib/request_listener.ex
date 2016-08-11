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
		{:noreply, accept_connections(demand, server), server}
	end

	def accept_connections(demand, server) do
		case server |> :gen_tcp.accept do
			{:ok, client} ->
				[client]
			{:error, reason} ->
				IO.puts "Server faulted: #{reason}"
		end
	end
end