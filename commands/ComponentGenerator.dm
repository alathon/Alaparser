var/ComponentGenerator/__componentGenerator;

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
			if(type_path in src._componentTypes) {
				var/path = src._componentTypes[type_path];
				var/MatcherComponent/out = new path();
				if(opts != null) out.setCommandOptions(opts);
				return out;
			} else {
				var/MatcherComponent/out = new /MatcherComponent/literal();
				out.setCommandOptions(type_path);
				return out;
			}
		}