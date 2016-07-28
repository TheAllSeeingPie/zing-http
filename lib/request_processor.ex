alias Experimental.GenStage

defmodule RequestProcessor do
	use GenStage

	def init(_) do
		{:consumer, :ok}
	end

	def handle_events(events, _from, number) do
		IO.puts "RequestProcessor handle_events"
		Enum.each events, fn message -> message |> consume_message end
		{:noreply, [], number}
	end

	def consume_message(message) do
		IO.puts message.path
	end
end