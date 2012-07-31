var/const/PARSE_SUCCESS = -1;

Parser
	var
		list/commands = new /list();

	proc
		_tokenize(str) {
			return __textToList(str, " ");
		}

		addCommand(Command/C) {
			commands += C;
		}

		preprocess(client/c, str) {
		}

		postprocess(client/c, str, Matcher/match) {
		}

		process(client/c, str) {
			src.preprocess(c,str);
			var/list/tokens = src._tokenize(str);
			var/Matcher/leadingMatcher;
			var/list/winners = new /list();

			for(var/Command/cmd in commands) {
				var/ParserInput/clientInput = new /ParserInput(str, tokens.Copy(), c);
				var/Matcher/matcher = new /Matcher(cmd, clientInput);
				if(matcher._match()) {
					winners += matcher;
				} else {
					if(leadingMatcher == null || matcher._getTokensMatched() > leadingMatcher._getTokensMatched()) {
						leadingMatcher = matcher;
					}
				}
			}

			var/Matcher/bestMatcher = src._selectWinner(winners);
			if(!bestMatcher) bestMatcher = leadingMatcher;

			var/ParserOutput/out = new();
			if(bestMatcher._isSuccessful()) {
				bestMatcher._parent._go(c, bestMatcher);
				out.setSuccess(TRUE);
			} else {
				out.setSuccess(FALSE);
			}
			out.setMatcher(bestMatcher);
			postprocess(c, str, bestMatcher);
			return out;
		}

		_selectWinner(list/winners) {
			var/Matcher/strongest;
			for(var/Matcher/matcher in winners) {
				if(!strongest || matcher._getFirstMatchStrength() > strongest._getFirstMatchStrength()) {
					strongest = matcher;
				}
			}
			return strongest;
		}