defmodule Message do
	defstruct verb: "", path: "", headers: {}, payload: ""

	def parse(message) do
		[verb, path, rawheaders, payload] = Regex.run ~r/^([A-Z]+) (.+) HTTP\/1.[01]\r{0,1}\n((?:[A-z]+:.+\r{0,1}\n)+)(?:\r{0,1}\n){0,1}([\s\S]+)/, message, capture: :all_but_first
		headers = for header <- Regex.scan(~r/([A-z]+): (.+)/, rawheaders, capture: :all_but_first),
			into: Map.new,
			do: { String.to_atom(hd header), hd tl header }
		%Message{verb: verb, path: path, headers: headers, payload: payload}
	end
end