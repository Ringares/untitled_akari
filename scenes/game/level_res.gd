extends Resource
class_name LevelRes

const w1_levels = [
	# SHFT+Command+O/L
	
	"4x1:c1", # tut d1-0-0
	"5x1:aBb1", # tut d1-0-0
	"3x3:b2cBb", # tut d1-0-0
	"3x3:b12e", # tut edge 2 d1-0-0
	"3x3:1f0a", # tut block 0 d1-0-0
	
	"4x4:b2bBe20c", # tut block 0 + edge 2 d1-0-0
	"4x5:B1eBBb1Be1B", # tut edge 1 d1-0-0
	"6x6:b1m1g2c1c2c", # tut edge 2 d1-0-0
	"6x6:cBaBBg4gBBBh1b", # tut block 4 d1-0-0
	"7x7:Bb1d4bBh1aBcBa2hBb0d2bB", # tut only option d1-0-0
	
	"7x7:g1aBe1b3c1c3g3j0c", # tut edge 3 + only d1-0-0
	"6x6:e0a1f2g2c2c1d1", # tut edge2 d1-0-0
	"8x6:h2i2i2i3i", # tut edge2 trans d1-0-0
	"8x8:l3e1c3r3cBe0l", # tut edge3 trans d1-0-0
	
	"7x7:dBaB1g3b2jBb0b0j0a1",  # 2m 1+3 comb d1-0-0
	"7x7:cBe0f0aB2a0eBaB0a2f2eBc", # 4r edge2 + only d1-0-0
	"7x7:bBaBb2h11m12hBb2aBb", # 2r only d1-0-0
	"7x7:cBg2c2a3cBa4a3aBc2a1cBg0c", # 4r only d1-0-0
	"7x7:d2Bb2BiBBgB1i02b2Bd", # 2r d2-1-1
	"7x7:1Bd1fBcBe2BBe1c1fBd0B", # 4r d1-0-0
	"7x7:0d0j2b11i2b01g0d0a",  # 2m d1-0-0
	"7x7:e1a0hBa3k0a2hBa3e", # 4r d1-0-0
	"7x7:aB1b1fBd1mBd1f1b2Ba", # 2r d1-0-0
	
	"6x6:1aEBa1fBaBbFbBa1f1aBEa0", # spec d1-0-0
]

const w2_levels = [
	"7x7:a1h1b3h1c1hBb0hBa", # 4r d1-0-0
	"7x7:aBc2a3eBjBjBe2a2c1a", # 4r d1-0-0
	"7x7:a2g3c0e1i0e1cBg2a", # 4r d1-0-0
	"7x7:BaBc2cBiBa0c1a1i1cBc0aB", # 4r d1-0-0
	"7x7:BaBcBd1c3d1gBd1c2d0c2aB", # 2r d1-0-0
	"7x7:c1lBa3b2bBb0b3a3l0c", # 4r d1-0-0
	
	"7x7:bBBBb0d0n1g2dBcB10b", # 2m d2-1-1
	"7x7:a0g0a1a2a0c1i2c0a2a2a0g0a", # 3r d2-1-1
	"7x7:0d01a0g1g3a1c3e3e1d00", # 2m d2-1-1
	"7x7:c1b1h1c3c10gBg1b2e", # o d2-1-1
	"7x7:BeBb1f0a11i02a1f0bBe0", # 4r d2-1-1

	"10x10:m1c3p1c3v0c2p0c2m", # 2r d1-0-0
	"10x10:l3aBBaBBbBBa0c0l1BaBcBbBc1aB2lBcBaBBbB2aB1aBl", # 2r d1-0-0
	"10x10:e1p4c1w1f3p2c1g1m", # o d1-0-0
	"10x10:2hBf1f1g2b1bBh1f2hBb2b1g2f2fBh1", # 4r d1-0-0
	"10x10:2vBhB2b0z0bB2h0v1", # 2r d1-0-0
	"10x10:e1e2Ba1BaB1bBcBbBf1eB1BdB1BBdB1BeBf1bBcBb11a01a01eBe", # 2r d1-0-0
	"10x10:k1eB2b2lBh1B2hBB1h1lBbBBe3k", # 2r d1-0-0
	"10x10:cBg2a1aBb1dBj3bB2BaBd0f2dBaB1Bb1jBd3bBa1a4gBc", # 4r d1-0-0
	"10x10:1lBb1BBbBBBa3h4b1eBd1bBd1e1b0h2aBBBbBBBbBl1", # 2r d1-0-0
	"10x10:o4fBaBb1f2fBdB1d0BdBf1f3bBaBf2o", # 4m d1-0-0

	"11x5:eEfBa3aEaBaBaBi1a3a0aEa0a2fEe", # spec yaling d1-0-0
	"10x10:GdIb00bGaBd3aEdFe2aHa1bBaHaBeFdEa4d2aGb11bIdG", # spec circle d1-0-0
	"10x6:IBcBHb3bHBdHd1Hb1bH0c0I", # spec stair d3-2-1
]


const w3_levels = [
	
	"7x7:a3gBc2e2i2eBc2gBa", # 4r d2-1-1
	"7x7:aBc1a2e2u2e2a2cBa", # 4r d2-1-1
	"7x7:b1eBc3g3g2g2cBe2b", # 4r d2-1-1
	"7x7:Be0dBcBa3e2a3eBa1c1d2eB", # 4r d2-1-1
	"7x7:e2aB0aBaBi1cBi1a1a01aBe", # 4r d2-1-1
	"7x7:Bd11Bh1a0k1aBh1B0dB", # 4r d2-1-1
	"7x7:1eBj4eBa2e3jBe0", # 4r d2-1-1
	"7x7:a0k2b0a1kBa0bBk2a", # 4r d2-1-1
	"7x7:k2c3a3e3a4e3a3c3k", # 4r d2-1-1

	"10x10:q4f2f2n1f1n0f2f1q", # 2r d1-0-0
	
	"10x10:b0lB2h1Bb2b1BhB1l0BhBBb2b1BhB1l1b", # 4r d1-0-0n
	"10x10:d2bBcBfBb1B2aB1dBdBb2a1a1l0a1a1bBdBdBBa10Bb1f1cBb1d", # 2r d1-0-0
	"10x10:1dBBbBb1c1BcBBBcBa1b2l1BbBBb21l2b1aBcBB1cB1c1bBbB1dB", # 2r d1-0-0
	"10x10:h1a1o3e3zhBe2o2a1h", # 4r d2-1-1
	"10x10:c11cBb2e0BBh2d0f1b0aBBaBBBb1a1BaBBc0n3b2e2BBcB1cBa", # 2m d2-1-1
	"10x10:e0h1aBe3d2cBb1e0e1aBbBa1e0e2b2c1d3e1a2hBe", # 4r d2-1-1
	"10x10:bBdBd0g0eBa2BbB20aBi2fBi1a01BbB1aBe2g0d0d0b", # 4r d2-1-1
	"10x10:eBe4c1b1cBdBbBb3c1BbBBhB1g1bBcB2c0dBc1c0b1fBd", # 2m d2-1-1
	"10x10:c2aBe0cBb0e0hBb1b2BBe0d0e1BBb2bBh2e3bBc2eBaBc", # 4r d3-2-1
	"10x10:BhBaBb0aBB0b1dBdB1oBb3o11dBdBb1B1a0bBa0hB", # 4r d2-1-1
	"10x10:a2aB1aBdBf12b1d1b1hBiBBiBh1b2d0b02fBd0aB1a2a", # 4r d2-1-1

	"15x10:KBQcJBfBfBEa2a0e1a1aGcBa0aBcHc0aBa2cGa1a1eBa4aEBfBfBJcQBK", # spec star d2-1-1
	
	"12x9:cBH0cE1cFc0GcBBcI2d1KdKBd0IcB1cG1cFc0Ec0H1c", # spec x d2-1-1
	"10x10:1bBFBb0b2aFhFb1a1hBGaBBaJa0BaGBhBa4bFhFaBbBbBF0b1", # spec 4wing d2-1-1
	
]

const w4_levels = [
	"7x7:d1e0c1bBd02a3BdBb0c0eBd", # 4r d3-2-1
	"7x7:0cBa2g0aBaBe3e1aBaBg0a1cB", # 4r d3-2-1
	"7x7:Bd11BbBk1a1a1k1b101dB", # 4r d2-1-1
	"7x7:i1a1cBc1d3d2c0c2a1i", # 4r d3-2-1
	"7x7:aBc2a1a1cBe1i2e2cBa3aBcBa", # 4r d3-2-1
	"7x7:1cBaBg2a3a1eBeBa2a0gBaBcB", # 4r d4-3-2
	"7x7:c1b0d2d1d1d1c3h2e1b0", # 2m d4-3-2

	"10x10:bB1bB0m2a1b1a3k1a1d0aB0a1d0aBk1a0b2aBmBBb01b", # d5-4-2
	"10x10:BhBcBi2a2i0a01c21lB1c02a0i0a2i0cBh0", # d8-5-4
	"10x10:a0aBb1gBaBb2jB1gBd00bBbBbBBd2g1BjBb2aBgBb0a1a", # d3-2-1
	"10x10:Bh0b02h2a3bBBiBh2dBhBi20b2aBhB2bBhB", # d2-1-1

	"10x10:bBdBd10f1b2a1b12g1Bc0n3cBBg01b1aBb1fBBd1d1b", # 4r d3-2-1
	"10x10:1c1c1B0m0a0eBn1aBBaBn1e2a0mB1Bc0cB", # 4r d3-2-1
	"10x10:aBk1aBc3o2b1b0a0BBhBB0aBb1bBoBc2a1k0a", # 4r d3-2-1
	"10x10:k111b002eBBg1bBc0BfB0BBf1BcBb1g10e0BBb10Bk", # 4m tricker d2-1-1
	"10x10:aBbB1b2b01dBBbBf0b2fBe11h1Be0f1bBf0bB2dBBbBbBBbBa", # 4m tricker d2-1-1
	"10x10:a0fBb21dBBcB1bBBcBaBbBa1e11hB0e3aBbBa2cB1bB2cBBd1BbBf0a", # 4m d2-1-1
	"10x10:B1fBB1b2b0c1gBcBbBb1d0BBhBBBdBb0bBc0g1c2bBbBBBf2B", # 2r d3-2-1
	"10x10:cBa0f3jBBBBBbBc1d2BBBfBBf0BB0d0cBb1BBB2j3f2aBc", # 2r d4-3-2
	"10x10:hBa1kBa11a3f0g0cB1d12c1g0fBaBBa1k1a1h", # d4-3-2
	"10x10:01b1bBa1iBBc0i1k0Ba02a01k1iBcB1iBa1bBb0B", # 4r d3-2-1

	
	"11x11:aBBjBa1b2b0iBBa1a1cBgGbBeGe3bGg1c0a0aBBi0b1b1aBj1Ba", # spec well d5-3-2
	"10x10:Gb00IfGhE1b03a1c0e0f1e1c0a00b0EhGfI00bG", # spec hex d4-2-2
	"10x7:FfGbBb0bEbBBb01n2Bb01bEb3bBbGfF", # spec fat hex d3-2-1
	
]

const w5_levels = [
	"7x7:c2m1c0a1aBa2c3m2c", # 4r d1-0-0
	"7x7:dB0a1b0c0g1c1gBc1b1a10d", # 4r d1-0-0
	"7x7:dBd4dBd2i0d1dBdBd", # 4r d2-1-1
	"7x7:d1a01g1b2j2b1b3jBaB", # 2m d3-2-1
	"7x7:c1b1d1d2d1d2c1h2e3b0", # 2m d4-3-2
	
	"7x7:h2a2h0d1d2c1l0b", # o d5-4-2
	"7x7:0eBb0Bh2b2c0b1h11b0e0", # 4r d4-2-2
	"7x7:b0h0c3dBg1d1c2h1b", # 4r d7-4-3
	"7x7:c1e1Bh1aB0c00a1h00eBc", # 4r d8-7-4
	"7x7:i01hBb1a3a1b2hB1i", # 4r d9-6-4

	"10x10:dBg0d2c12a3bBBr0aBBa0rBBb1aB3c1d2gBd", # 4r d6-3-2
	"10x10:d2b1eBf1c0m2eB1a2a21a1aB0e0mBcBfBe0b3d", # 4r d4-3-2
	"10x10:a2fBaBhBcBb3d1BdB0cBa1BaBdBa2Ba1c2Bd01d1bBc1hBa2fBa", # 4m d4-2-2
	"10x10:0h0c1b0nBa1a12a1dBlBd1a10aBa0n0b0cBhB", # 4r d4-2-2
	"10x10:b0aBBaBmBfBa11b00bB2dBBhB1d00b1BbBBaBfBm2aBBa1b", # 4m d6-5-3
	
	"10x10:b0d1f01d0h2b10B010fBBhBBfBBBBB2b2h1dBBfBd1b", # 4m d6-5-3
	"10x10:bBe1a2b0jBd1d2cBg1BdB0g2c2d2dBjBb2a1e0b", # 4r d7-5-3
	"10x10:aBBc1l1d2dB1b2a11f0c1d1cBf01aBb10d2dBl2cBBa", # d8-5-3
	"10x10:1b0eBe1g1aB0e2dBa2aBBn02a2a1dBe10a2g1eBe1bB", # d9-6-3
	"10x10:aBe1dBf22b2d1e1b1hBfBh1b0e0dBb20f2dBe2a", # 4r d10-7-4
	
	"14x13:GBBBBBBBBHB0hBBEBd1b0d11d1b1dBBlBGBBd11MbKBBBFbFBBBEBcBEbEBcBBdBb1dBE1cBbBc2H1fBJBBa1Ba1BG", # spec flower d3-2-1
	"8x11:a1BcBd1dEa21a2aFd1aGdIbIdGa2dFaBaB1aEdBd1c11a", # spec timer d4-3-2
	"13x11:Fa3aGaBaGeEeEcBbBb1c3bBeBb2dBc3dEb1a0a2a3bGdBdIc0cKeMBa1OBJ", # spec heart d4-3-2
	"11x11:fIaBb2aIb21bIa2b2aIgHe2eHgIaBb1aIbB1bIa0b1aIf", # spec 2wing d4-3-2
	
	
]

const w6_levels = [
	"10x10:c0iBbB2c11b2b1fBb1g1f0gBbBf2b1bBBcBBb0iBc", # 2r d17-11-7
	"10x10:m2b1eBaBb1c3b1c1gBBdBBgBc1b2c0b2a4eBb2m", # 4r d4-3-2
	"10x10:lBd1c3aBb2aBbBfBc1dBdBd2c0f1bBaBb0a0c2d1l", # d27-9-6
	"10x10:l2c0k0b2zj3b1k1c3l", # 4r d3-2-1
	"10x10:l0b3l3l0p2l1l1b2l", # 4r d3-2-1
	
	"10x10:a1b1bBu1d1fBfBp2d2uBb2b2a", # 2r d4-3-2
	"10x10:m2a2f20cBfBb20bBd2f1d1b3Bb1f1cBBfBa0m", # 4r d3-2-1
	"10x10:n12bBb1b2bBBBa1Be1gBf1g1e1BaBB1b1b2bBb21n", # 2r d5-4-2
	"10x10:c1b1aBaBd2f12bBaBiBb1a1dBbBdBa2bBiBa1bB2f1dBa1a1bBc", # 2r d6-3-2
	"10x10:aBaBk2aB1b1a11c1aBBd1hBBa2b0a1Bh2d1BaBc10aBbB1a1k1a1a", # 2r d7-6-3
	
	"10x10:BhBBa1aB0aBaBb2d0fBfBb1c2b1c1b2fBf1d0bBa2aB0aBaBBhB", # 2r d8-5-3
	"10x10:b2n1fBf1g2f2f2f2g1f1fBn2b", # 2r d9-4-3
	"10x10:c2bBeBk1a1aBa1a1f2g2dBgBf0a1a1a2aBk1e0b2c", # 4r d9-4-3
	"10x10:Bf1Ba1b1i1bBi1b1iB1i1b1i1b1iBb1aB1fB", # 4r d10-5-3
	"10x10:1c1d1bBBbBBcB0d0BbBaB1aBaBa1b0lBb2aBa0aBBaBbBBd1BcBBbBBb1d2c1", # 2r d12-6-4

	"14x14:BjBBBBhBa1bBBaBaB1a0BhBc1Ba2c100Bd22eBBa0b2bBm1d0m2bBb0aB0eB1dBBBBc1aB2cBhBBaB2aBa0BbBa0hBB0Bj1", # d3-2-1
	"14x14:Bc2dBc1BlBbBBaBb3aBBb1bBB0bBBBb2b20aBbBa1BgBBBBf1cBb2cBb0cBbBcBfBB1BgB1a0bBaB3b2bB1BbB1BbBb0Ba1bBaB1bBlBBc1d2cB", # d3-2-1
	"14x14:fBBfBaBBb1Bb10a0Bd2b1dBBeBBe1cBfBd02aB1bBBaB2fBb0j2bBf20aBBb02aBBd2f2cBeBBeBBdBb1dBBa10bBBb00aBf00f", # 2m d4-3-2
	"14x14:kB2cBBBb3aBg1c0BBBaBaB0gBbBeBbBf0B1aBd0a3aBBf1dBb3dBfBBa2a0d0a00BfBbBe1bBgB0a2a1BB1cBgBa2b2B0cBBk", # d6-5-3
	"14x14:d1Bb1Be0Bg1BBb11d1cB2b0dBgBdBgB0f2aBcBb1bBBBb3f1bBBBb2bBcBa0fBBg1dBg0d0b10c1dB0bB1BgB0eBBb00d", # d7-4-3
	
	"14x14:Bc0aBaBbBBBB0iBBaBBBBd1b2jBBaBe1b11e11a1BcBjB1cBc21c0c0BjBc0BaB1eB0b0e0aB1j1bBd10BBa0BiBBBBBb2a1a0c1", # 4r d11-6-4
	"14x14:BeBeBBB1cBdBa2dB1aB0a1e1dBd2d3dBBbBfBgBc2aBaB1bB1aBBaBBb2Ba1aBc1g1fBbBBd0d2dBdBeBa20aB2dBaBd2cBBB1eBeB", # d12-6-4
	"14x14:fBBBg2b01d1c2B1aBc0BB2c1d0cBd1b1h0h1a1BaBb1hB0BBhBbBa01a1h1h1b2dBc2dBc0B01cBaBB0cBd0BbBgBBBf", # d14-11-7
	#"11x11:fIa2bBaIb2BbIa1b2aIb2dHeBeHd2bIa1bBaIbB3bIa0b4aIf", # d17-7-4
	 #9x13:BgBbBc3bE3aBaBa1FgEBc2c1BEeEB1gBFbBbHBc0IcJcIa2a3aGc1cE
	"9x13:jBaBaBa4aEa1cBaFgEd1dBEbBbE0d1dFeHB1a1BIcJ1a0I1cBGgE", # spec final
]

# Todo
# "10x10:Gb1BIfGe0bEBa12Ba2cBe1fBe1c0aBBBa0Eb2eGfI11bG", # spec hex d1-0-0
#"11x5:d0Ef10bEaBa0m10bEa2a3e1Ee", # spec d4-2-2
#"10x10:0b1F2b1b2aFa2fFd1h0Gb0aJa1bG0h0dFf1aFa1b1b1F0b2", # spec 4wing d1-0-0

# 12x9:cBH0cE1cFc1Gc00cI0d1KdK0dBIc10cG1cFc1Ec0H1c, # d8-4-3
# 12x9:c1H2cEBcFcBGcB1cI1dBKdK0d0Ic00cG0cFcBEc1H2c, d4-3-2
# 
# 12x9:c0HBcE0cFc1Gc00cI1d0KdK0d0Ic01cG0cFc1Ec1H0c, d4-3-2
# 
# 14x13:GBB0BBBBBHB1h0BEBd1b0dB1dBb1d1BlBGB0d0BMbKBBBFbFBBBEBcBEbEBcBBdBbBdBE1c1bBc0H1f2JBBaBBaBBG, d3-2-1
# 11x11:fIaBb2aIb21bIa2b2aIgHe2eHgIaBb1aIbB1bIa0b1aIf , d-3-2
#"10x10:GdIfGa1b3a1aEcBbBe1aBBhBBa4eBbBcEa0a0b2aGfIdG", # spec d13-6-4


static var levels:Dictionary


static func get_levels():
	"""
	return {"level_code":"1-1"}
	"""
	var world_id = 0
	var level_id = 0
	if LevelRes.levels.size() == 0:
		for w in [w1_levels, w2_levels, w3_levels, w4_levels, w5_levels, w6_levels]:
			for l in w:
				LevelRes.levels[l] = "%s-%s" % [world_id, level_id]
				level_id += 1
			world_id += 1

	return LevelRes.levels

static func get_level_size():
	return LevelRes.get_levels().size()
			
