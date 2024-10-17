extends Resource
class_name LevelRes

const w1_levels = [
	"4x1:c1",
	"5x1:aBb1",
	"3x3:b2cBb",
	"3x3:b12e",
	"3x3:1f0a",
	"4x4:b2bBe20c",
	"4x5:B1eBBb1Be1B",
	"6x6:b1m1g2c1c2c",
	"6x6:cBaBBg4gBBBh1b",
	"7x7:Bb1d4bBh1aBcBa2hBb0d2bB",
	"7x7:g1aBe1b3c1c3g3j0c",
	"8x8:BBBBa0BBf1b3aBdBBaB1aBaBcBaBg1BaBBa2d0BaBBBa",
	"8x6:h2i2i2i3i",
	"8x8:l3e1c3r3cBe0l",
]

const w2_levels = [

]


const w3_levels = [

]





static var levels:Dictionary


static func get_levels():
	var world_id = 0
	var level_id = 0
	if LevelRes.levels.size() == 0:
		for w in [w1_levels, w2_levels, w3_levels]:
			for l in w:
				LevelRes.levels[l] = "%s-%s" % [world_id, level_id]
				level_id += 1
			world_id += 1

	return LevelRes.levels

static func get_level_size():
	return LevelRes.get_levels().size()
			
