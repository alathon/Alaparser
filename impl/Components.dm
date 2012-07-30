MatcherComponent
	any
		_name = "any";
		match(ParserInput/inp) {
			return _success(length(inp.getTokens()), __listToText(inp.getTokens(), " "));
		}

	word
		_name = "word";
		match(ParserInput/inp) {
			var/str = inp.getFirstToken();
			if(length("[text2num(str)]") == length(str)) {
				return _failure();
			} else {
				return _success(1, str);
			}
		}

	num
		_name = "num";
		match(ParserInput/inp) {
			var/str = inp.getFirstToken();
			var/numstr = text2num(str);
			if(length("[numstr]") != length(str)) {
				return _failure();
			} else {
				return _success(1, numstr);
			}
		}

	literal
		New(word, list/opts) {
			src.word = word;
			..(opts);
		}

		_name = "literal";
		var
			word

		clone() {
			var/MatcherComponent/literal/other = ..();
			other.word = src.word;
			return other;
		}

		match(ParserInput/inp) {
			var/text = inp.getFirstToken();
			if(__textMatch(word, text, src._isCaseSensitive(), src._isPartial())) {
				return _success(1, src.word);
			} else {
				return _failure();
			}
		}

	search
		New(list/opts) {
			..(opts);
			src._rangeOption = locate(/Option/postfix/range) in src._options;
		}

		_name = "search";
		clone() {
			var/MatcherComponent/search/other = ..();
			other._rangeOption = src._rangeOption;
			return other;
		}

		match(ParserInput/inp) {
			var/list/possibles = src._rangeOption.getPossibles(inp.getSource());
			return findTarget(inp, possibles);
		}

		var
			Option/postfix/range/_rangeOption;

		proc
			_getEntryKeywords(entry) {
				if(istype(entry, /client)) {
					var/client/E = entry;
					return E.getMatchKeywords();
				} else {
					switch(entry:type) {
						if(/atom, /mob, /obj, /turf, /area) {
							var/atom/E = entry;
							return E.getMatchKeywords();
						}
					}
				}
			}

			isMatch(entry, attempt) {
				var/list/keywords = src._getEntryKeywords(entry);

				for(var/word in keywords) {
					if(__textMatch(word, attempt, src._isCaseSensitive(), src._isPartial())) return TRUE;
				}
				return FALSE;
			}

			chopMatchNumber(text) {

				return 1;
			}

			findTarget(ParserInput/inp, list/possibles) {
				var/attempt = inp.getFirstToken();
				var/match = null;
				var/dot = findtext(attempt, ".");
				var/matchNumber = 1;
				if(dot != 0) {
					var/first = copytext(attempt, 1, dot);
					if(__isTextNum(first)) {
						attempt = copytext(attempt, dot+1);
						matchNumber = text2num(first);
					}
				}

				for(var/entry in possibles) {
					if(isMatch(entry, attempt)) {
						match = entry;
						if(--matchNumber == 0) break;
					}
				}

				if(match != null && matchNumber == 0) {
					return _success(1, match);
				} else {
					return _failure();
				}
			}