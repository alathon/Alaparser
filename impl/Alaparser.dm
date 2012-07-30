var/Alaparser/alaparser;

Alaparser
	New() {
		src.generator = new();
		src.optionParser = new();
	}

	var
		ComponentGenerator/generator
		OptionParser/optionParser