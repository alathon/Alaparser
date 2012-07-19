ParserOutput
	var
		client/client;
		inputText;
		list/tokens;
		Command/command;
		tokenCount;
		success;

	proc
		setSuccess(b) { src.success = b; }
		setClient(c) { src.client = c; }
		setInputText(t) { src.inputText = t; }
		setTokens(t) { src.tokens = t; }
		setCommand(c) { src.command = c; }
		setTokenCount(c) { src.tokenCount = c; }

		getSuccess() { return src.success; }
		getCommand() { return src.command; }
		getTokenCount() { return src.tokenCount; }
		getInputText() { return src.inputText; }
		getClient() { return src.client; }