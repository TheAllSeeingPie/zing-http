alias Experimental.GenStage

defmodule RequestDispatcher do
	use GenStage

	def init(_) do
		{:producer_consumer, :ok}
	end

	def handle_events(events, _from, number) do
		{:noreply, Enum.map(events, fn socket -> socket |> process_socket end), number}
	end

	def process_socket(socket) do	
		case :gen_tcp.recv socket, 0 do
			{:ok, data} ->
		   		{:ok, data |> Message.parse, socket}
		   	{:error, reason} ->
		   		IO.puts "Client faulted/closed: #{reason}"
		   		{:error, reason}
		end
	end
end