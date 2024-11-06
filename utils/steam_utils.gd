extends RefCounted
class_name SteamUtils

const STEAM_APP_ID = "3257340"


enum ACHIEVEMENT_ENUM {
	W0_COMPLETE,
	W1_COMPLETE,
	W2_COMPLETE,
	W3_COMPLETE,
	W4_COMPLETE,
	W5_COMPLETE,
	INFINITE_UNLOCK
}
const ACHIEVEMENTS = {
	ACHIEVEMENT_ENUM.W0_COMPLETE:"NEW_ACHIEVEMENT_W0",
	ACHIEVEMENT_ENUM.W1_COMPLETE:"NEW_ACHIEVEMENT_W2",
	ACHIEVEMENT_ENUM.W2_COMPLETE:"NEW_ACHIEVEMENT_W2",
	ACHIEVEMENT_ENUM.W3_COMPLETE:"NEW_ACHIEVEMENT_W3",
	ACHIEVEMENT_ENUM.W4_COMPLETE:"NEW_ACHIEVEMENT_W4",
	ACHIEVEMENT_ENUM.W5_COMPLETE:"NEW_ACHIEVEMENT_W5",
	ACHIEVEMENT_ENUM.INFINITE_UNLOCK:"NEW_ACHIEVEMENT_W8",
	
}

static func init():
	OS.set_environment("SteamAppId", STEAM_APP_ID)
	OS.set_environment("SteamGameId", STEAM_APP_ID)
	

static func check_steam_status():
	var initialize_response = Steam.steamInitEx()
	print("Did steam initialize?: %s" % initialize_response)
	print("Steam.loggedOn", Steam.loggedOn())
	print("Steam.isSubscribed", Steam.isSubscribed())
	print("Steam.getSteamID", Steam.getSteamID())
	print("Steam.getPersonaName", Steam.getPersonaName())
	

static func set_achievement(ach_enum:ACHIEVEMENT_ENUM):
	var steam_achi_id = ACHIEVEMENTS.get(ach_enum, "")
	var status = Steam.getAchievement(steam_achi_id)

	if not status.has('achieved'):
		print("steam", 'Achievement status invalid ', ach_enum)
		return

	if status['achieved']:
		print("steam", 'Already achieved', ach_enum)
		return
	
	#Steam.setAchievement(ACHIEVEMENTS.get(ach_enum, ""))
	print("steam", ACHIEVEMENTS.get(ach_enum, ""), 'Achieved', status)
		
	
	
static func add_wishlist():
	var res: int = OS.shell_open("steam://advertise/" + STEAM_APP_ID)
	if res != OK:
		OS.shell_open("https://store.steampowered.com/app/" + STEAM_APP_ID + "/Fishards/")
		
