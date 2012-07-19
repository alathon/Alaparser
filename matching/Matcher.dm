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
			if(comp.type in getIgnoredValueTypes()) return FALSE;
			return TRUE;
		}

		match(ParserInput/inp) {
			for(var/i = 1; i <= length(_matchers); i++) {
				var/MatcherComponent/comp = _matchers[i];
				if(!inp.getTokens() || !length(inp.getTokens())) {
					return i;
				}

				var/MatchResult/result = comp.match(inp);
				if(!result.isSuccessful()) {
					if(comp._isRequired()) {
						return i;
					}
				} else {
					if(_includeValue(comp)) _addValue(result.getValue());
					_consumeTokens(inp.getTokens(), result.getTokenCount());
				}
			}
			if(length(inp.getTokens())) return length(_matchers);
			else return PARSE_SUCCESS;
		}

		matchersToText() {
			for(var/MatcherComponent/comp in _matchers) {
				. += "[comp.getName()]";
			}
		}

		getIgnoredValueTypes() {
			. = new /list();
			. += /MatcherComponent/literal;
		}