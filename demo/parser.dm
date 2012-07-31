client/Command(T) {
	var/ParserOutput/out = alaparser.parser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
	}
}