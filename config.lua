Config = {}

Config.Locale = 'en'

Config.Delays = {
	SewingClothes = 1000 * 2
}

Config.Pricesell = 750

Config.MinPiecesCot = 1

Config.TextileOwnerItems = {
	fabricroll = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	CottonField = {coords = vector3(2072.76, 4917.4, 41.04), name = 'blip_CottonField', color = 25, sprite = 496, radius = 100.0},
	SewingClothes = {coords = vector3(718.94, -960.07, 30.4), name = 'blip_SewingClothes', color = 25, sprite = 496, radius = 100.0},
	MakeFabricroll = {coords = vector3(711.2, -971.54, 30.4), name = 'blip_SewingClothes', color = 25, sprite = 496, radius = 100.0},
	TextileOwner = {coords = vector3(429.23, -808.3, 29.49), name = 'blip_Textileowner', color = 6, sprite = 378, radius = 25.0},
}
