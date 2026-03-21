extends Node

const SAVE_PATH = "user://save_data.cfg"

func save_game():
	var config = ConfigFile.new()
	
	config.set_value("Endings", "bad_ending", GlobalData.bad_ehding)
	config.set_value("Endings", "good_ending", GlobalData.good_ending)
	config.set_value("Endless", "2k score", GlobalData.achievement_2k)
	config.set_value("Endless", "4k score", GlobalData.achievement_4k)
	config.set_value("Endless", "10k score", GlobalData.achievement_10k)
	
	var err = config.save(SAVE_PATH)

func load_game():
	var config = ConfigFile.new()
	
	if config.load(SAVE_PATH) != OK:
		return
		
	GlobalData.bad_ehding = config.get_value("Endings", "bad_ending", false)
	GlobalData.good_ending = config.get_value("Endings", "good_ending", false)
	GlobalData.achievement_2k = config.get_value("Endless", "2k score", false)
	GlobalData.achievement_4k = config.get_value("Endless", "4k score", false)
	GlobalData.achievement_10k = config.get_value("Endless", "10k score", false)

func reset_save_data():
	GlobalData.bad_ehding = false
	GlobalData.good_ending = false
	GlobalData.achievement_2k = false
	GlobalData.achievement_4k = false
	GlobalData.achievement_10k = false
	
	save_game()
	
