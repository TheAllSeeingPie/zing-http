defmodule Message do
	defstruct verb: "", path: "", headers: {}, payload: ""

	def parse(message) do
		[verb, path, rawheaders, payload] = Regex.run ~r/^([A-Z]+) (.+) HTTP\/1.[01]\r{0,1}\n((?:[A-z]+:.+\r{0,1}\n)+)(?:\r{0,1}\n){0,1}([\s\S]+)/, message, capture: :all_but_first
		headers = Regex.scan(~r/([A-z]+): (.+)/, rawheaders, capture: :all_but_first)
	    headers = Enum.map(headers, fn header -> { String.to_atom(hd(header)), hd(tl(header))} end)
	    headers = Enum.into(headers, %{})
		%Message{verb: verb, path: path, headers: headers, payload: payload}
	end
end