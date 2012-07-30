ComponentGenerator
	New() {
		_populateTypes();
	}

	var
		list/_componentTypes;

	proc
		_populateTypes() {
			_componentTypes = new();

			for(var/t in typesof(/MatcherComponent) - /MatcherComponent) {
				var/MatcherComponent/real = new t();
				if(!real._name) continue;
				_componentTypes += real._name;
				_componentTypes[real._name] = real.type;
			}
		}

		_fromCommand(Command/cmd) {
			var/list/tokens = __textToList(cmd.format, ";");
			. = new /list();

			for(var/entry in tokens) {
				var/MatcherComponent/comp = _getMatcherFromEntry(entry);
				if(comp != null) . += comp;
			}
		}

		_getMatcherFromEntry(entry) {
			if(entry == "" || entry == null) return null;
			var/name = _getEntryName(entry);
			var/list/opts = _getEntryOptions(entry);
			return getMatcher(name, opts);
		}

		_getEntryName(entry) {
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
				var/optsText = copytext(entry, left_brace+1, right_brace);
				return alaparser.optionParser.parse(optsText);
			} else {
				return null;
			}
		}

		getMatcher(name, list/opts) {
			if(name in src._componentTypes) {
				var/path = src._componentTypes[name];
				return new path(opts);
			} else {
				return new /MatcherComponent/literal(name, opts);
			}
		}