Matcher
	New(Command/cmd) {
		src._matchers = cmd._getComponents();
		src._values = new /list();
		src._parent = cmd;
	}

	var
		list/_matchers;
		list/_values;
		Command/_parent;

	proc
		_consumeTokens(list/tokens, n) {
			tokens.Cut(1,1+n);
		}

		_addValue(val) {
			_values += val;
		}

		_getValues() {
			return _values;
		}

		_includeValue(MatcherComponent/comp) {
			if(comp._isForcedValue()) return TRUE;
			if(comp.type in getIgnoredValueTypes()) return FALSE;
			return TRUE;
		}

		_debug(ParserInput/inp) {
			world << "Trying to match command [_parent] with format [_parent.format]";
			world << "# of Components: [length(_matchers)]";
			for(var/MatcherComponent/comp in _matchers) {
				_debugComp(comp);
			}
			world << "Client input: [inp.getText()]";
		}

		_debugComp(MatcherComponent/comp) {
			world << "\tComponent type: [comp.type]";
			if(length(comp._options)) {
				world << "\tComponent options: [__listToText(comp._options)]";
			} else {
				world << "\tComponent has no options.";
			}
		}

		match(ParserInput/inp) {
			var/origLength = length(inp.getTokens());
			for(var/i = 1; i <= length(_matchers); i++) {
				var/MatcherComponent/comp = _matchers[i];
				if(!inp.getTokens() || !length(inp.getTokens())) {
					if(!comp._isOptional()) {
						return i;
					} else {
						continue;
					}
				}

				var/MatchResult/result = comp.match(inp);
				if(!result.isSuccessful()) {
					if(!comp._isOptional()) {
						return i;
					} else {
						continue;
					}
				} else {
					if(_includeValue(comp)) _addValue(result.getValue());
					_consumeTokens(inp.getTokens(), result.getTokenCount());
				}
			}

			if(length(inp.getTokens())) return origLength - length(inp.getTokens());
			else return PARSE_SUCCESS;
		}

		getIgnoredValueTypes() {
			. = new /list();
			. += /MatcherComponent/literal;
		}