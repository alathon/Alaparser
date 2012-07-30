MatcherComponent
	New(list/opts) {
		src._options = opts;
	}

	var
		list/_options = new /list();
		_name;
		_required = TRUE;

	proc
		_success(count, value) {
			var/MatchResult/result = new();
			result.setTokenCount(count);
			result.setValue(value);
			result.setSuccess(TRUE);
			return result;
		}

		_failure() {
			var/MatchResult/result = new();
			result.setSuccess(FALSE);
			return result;
		}

		_isCaseSensitive() {
			if(locate(/Option/prefix/caseSensitive) in src._options) return TRUE;
			return FALSE;
		}

		_isPartial() {
			if(locate(/Option/prefix/partial) in src._options) return TRUE;
			return FALSE;
		}

		_isForcedValue() {
			if(locate(/Option/prefix/forceValue) in src._options) return TRUE;
			return FALSE;
		}

		_isOptional() {
			if(locate(/Option/prefix/optional) in src._options) {
				return TRUE;
			}
			return FALSE;
		}

		getName() {
			if(!_name) return src.type;
			else return _name;
		}

		clone() {
			var/p = src.type;
			var/MatcherComponent/other = new p();
			other._options = src._options;
			return other;
		}

		match(ParserInput/inp) {
		}

