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

		preprocess(mob/user, str) {
			return TRUE;
		}

		postprocess(mob/user, str, Matcher/match) {
		}

		process(mob/user, str, list/commands) {
			if(!src.preprocess(user,str)) {
				return null;
			}

			var/list/tokens = src._tokenize(str);
			var/Matcher/leadingMatcher;
			var/list/winners = new /list();

			for(var/entry in commands) {
				var/Command/cmd = commands[entry];
				var/ParserInput/userInput = new /ParserInput(str, tokens.Copy(), user);
				var/Matcher/matcher = new /Matcher(cmd, userInput);
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
				if(cmd.preprocess(user)) {
					bestMatcher._parent._go(user, bestMatcher);
					cmd.postprocess(user);
					src.postprocess(user, str, bestMatcher);
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
