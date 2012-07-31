ComponentResult
	var
		_success = FALSE;
		_value = null;
		_tokenCount = 0;

	proc
		setTokenCount(n) { src._tokenCount = n; }
		setValue(v) { src._value = v; }
		setSuccess(s) { src._success = s; }
		isSuccessful() { return src._success; }
		getValue() { return src._value; }
		getTokenCount() { return src._tokenCount; }