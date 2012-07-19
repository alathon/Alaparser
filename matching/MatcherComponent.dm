MatcherComponent
	var
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

		_isRequired() {
			return _required;
		}

		getName() {
			if(!_name) return src.type;
			else return _name;
		}

		setCommandOptions() { }

		clone() {
			var/p = src.type;
			var/MatcherComponent/other = new p();
			. = other;
		}

		match(ParserInput/inp) {
		}

