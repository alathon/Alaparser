ParserOutput
	var
		_success = FALSE;
		Matcher/_matcher;

	proc
		setSuccess(v) { src._success = v; }
		setMatcher(m) { src._matcher = m; }
		getSuccess() { return src._success; }
		getMatcher() { return src._matcher; }