---Credit https://github.com/andristum/dpscenes

Fonts = {
	{label = "Chalet Comprimé", value = "4", group = "Normal"},
	{label = "Chalet", value = "0", group = "Normal"},
	{label = "Sign Painter", value = "1", group = "Handwritten"},
	{label = "Pricedown", value = "7", group = "Misc"},
}

local AddonFonts = {
	--Normal
	{"ArialNarrow", "Arial Narrow", "Normal"},
	{"Lato", "Lato", "Normal"}, 
	-- Handwritten
	{"Inkfree", "Inkfree", "Handwritten"},
	{"Kid", "Kid", "Handwritten"},
	{"Strawberry", "Strawberry", "Handwritten"},
	{"PaperDaisy", "Paper Daisy", "Handwritten"},
	{"ALittleSunshine", "A Little Sunshine", "Handwritten"},
	{"WriteMeASong", "Write Me A Song", "Handwritten"},
	-- Graffiti
	{"BeatStreet", "Beat Street", "Graffiti"},
	{"DirtyLizard", "Dirty Lizard", "Graffiti"},
	{"Maren", "Maren", "Graffiti"},
	-- Misc
	{"HappyDay", "Happy Day", "Misc"},
	{"ImpactLabel", "Impact Label", "Misc"},
	{"Easter", "Easter", "Misc"},
}


for i = 1, #AddonFonts do
	RegisterFontFile(AddonFonts[i][1])
	local Id = RegisterFontId(AddonFonts[i][2])
	Fonts[#Fonts+1] = {label = AddonFonts[i][2], value = tostring(Id), group = AddonFonts[i][3]}
end