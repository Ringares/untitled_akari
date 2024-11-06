extends Node


func _init():
	SteamUtils.init()

func _ready():
	SteamUtils.check_steam_status()
	AppSettings.set_from_config_and_window(get_window())
	
	var saved_locale = GameLog.get_locale()
	if saved_locale != "":
		TranslationServer.set_locale(saved_locale)
