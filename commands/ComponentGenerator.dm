ComponentGenerator
	proc
		_fromCommand(Command/cmd) {
			var/list/tokens = __textToList(cmd.format, ";");
			. = new /list();

			for(var/entry in tokens) {
				var/MatcherComponent/comp = _createMatcherComponent(entry);
				if(comp != null) . += comp;
			}
		}

		_getMatcherFromEntry(entry) {
			if(entry == "" || entry == null) return null;
			var/type_path = _getTypePath(entry);
			var/opts = _getEntryOptions(entry);
			return getMatcher(type_path, opts);
		}

		_createMatcherComponent(str) {
			var/MatcherComponent/comp = _getMatcherFromEntry(str);
			return comp;
		}

		_getTypePath(entry) {
			var/left_brace = findtext(entry, "(");
			if(left_brace == 0) {
				return entry;
			} else {
				return copytext(entry,1,left_brace);
			}
		}

		_getEntryOptions(entry) {
			var/left_brace = findtext(entry, "(");
			var/right_brace = findtext(entry, ")");
			if(left_brace > 0 && right_brace > 0) {
				return copytext(entry,left_brace+1,right_brace);
			} else {
				return null;
			}
		}

		getMatcher(type_path, opts) {
			switch(type_path) {
				if("mob","obj") {
					var/path = text2path("/MatcherComponent/search/[type_path]");
					var/MatcherComponent/out = new path();
					if(opts != null) out.setCommandOptions(opts);
					return out;
				}
				if("word") {
					var/MatcherComponent/out = new /MatcherComponent/word();
					if(opts != null) out.setCommandOptions(opts);
					return out;
				}
				if("any") {
					var/MatcherComponent/out = new /MatcherComponent/any();
					return out;
				}
				if("num") {
					var/MatcherComponent/out = new /MatcherComponent/num();
					if(opts != null) out.setCommandOptions(opts);
					return out;
				}
				// Consider it a literal.
				else {
					var/MatcherComponent/out = new /MatcherComponent/literal();
					out.setCommandOptions(type_path);
					return out;
				}
			}
		}