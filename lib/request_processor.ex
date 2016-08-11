alias Experimental.GenStage

defmodule RequestProcessor do
	use GenStage

	def init(_) do
		{:consumer, :ok}
	end

	def handle_events(events, _from, number) do
		Enum.each events, fn message -> message |> consume_message end
		{:noreply, [], number}
	end

	def consume_message(message) do
		case message do
			{:ok, message, socket} ->
				IO.puts "Message received for #{message.path}"
				:gen_tcp.send socket, "Hello world!"
		end
	end
end