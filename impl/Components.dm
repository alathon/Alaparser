MatcherComponent
	any
		_name = "any";
		match(ParserInput/inp) {
			return _success(length(inp.getTokens()), inp.getText());
		}

	word
		_name = "word";
		match(ParserInput/inp) {
			var/list/tokens = inp.getTokens();
			var/str = tokens[1]
			if(length("[text2num(str)]") == length(str)) {
				return _failure();
			} else {
				return _success(1, str);
			}
		}

	num
		_name = "num";
		match(ParserInput/inp) {
			var/list/tokens = inp.getTokens();
			var/str = tokens[1]
			var/numstr = text2num(str);
			if(length("[numstr]") != length(str)) {
				return _failure();
			} else {
				return _success(1, numstr);
			}
		}

	literal
		_name = "literal";
		var
			word

		setCommandOptions(opts) {
			src.word = opts;
		}

		clone() {
			var/MatcherComponent/other = ..();
			other.setCommandOptions(src.word);
			return other;
		}

		match(ParserInput/inp) {
			var/list/tokens = inp.getTokens();
			if(tokens[1] == word) {
				return _success(1, src.word);
			} else {
				return _failure();
			}
		}

	search
		mob
		obj