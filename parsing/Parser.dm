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
			preprocess(c,str);
			var/list/tokens = _tokenize(str);
			var/ParserInput/clientInput = new /ParserInput(str, tokens.Copy(), c);
			var/Command/bestCmd = null;
			var/tokenCount = 0;
			for(var/Command/cmd in commands) {
				var/Matcher/matcher = new /Matcher(cmd);
				var/tokensParsed = matcher.match(clientInput);
				if(tokensParsed == PARSE_SUCCESS) {
					cmd._go(c, matcher);
					postprocess(c,str,matcher);
					var/ParserOutput/out = new();
					out.setClient(c);
					out.setInputText(str);
					out.setTokens(tokens);
					out.setCommand(cmd);
					out.setTokenCount(length(tokens));
					out.setSuccess(TRUE);
					return out;
				} else {
					if(bestCmd == null || tokensParsed > tokenCount) {
						bestCmd = cmd;
						tokenCount = tokensParsed;
					}
				}
			}

			var/ParserOutput/state = new();
			state.setClient(c);
			state.setInputText(str);
			state.setTokens(tokens);
			state.setCommand(bestCmd);
			state.setTokenCount(tokenCount);
			state.setSuccess(FALSE);
			return state;
		}