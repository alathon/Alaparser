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
			return TRUE;
		}

		postprocess(client/c, str, Matcher/match) {
		}

		process(client/c, str, list/commands) {
			if(!src.preprocess(c,str)) {
				return null;
			}

			var/list/tokens = src._tokenize(str);
			var/Matcher/leadingMatcher;
			var/list/winners = new /list();

			for(var/entry in commands) {
				var/Command/cmd = commands[entry];
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

			var/Command/cmd = bestMatcher.getCommand();
			if(bestMatcher._isSuccessful()) {
				out.setMatchSuccess(TRUE);
				if(cmd.preprocess(c)) {
					bestMatcher._parent._go(c, bestMatcher);
					cmd.postprocess(c);
					src.postprocess(c, str, bestMatcher);
					out.setCommandSuccess(TRUE);
				}
			}
			out.setMatcher(bestMatcher);
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