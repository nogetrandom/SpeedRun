--[[
Author: Ayantir
Filename: LibCustomTitles.lua
Version: 10
]]--

--[[

This software is under : CreativeCommons CC BY-NC-SA 4.0
Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material
    The licensor cannot revoke these freedoms as long as you follow the license terms.


Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
    NonCommercial — You may not use the material for commercial purposes.
    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


Please read full licence at :
http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

]]--


--[[

Author: Kyoma
Version 20
Changes: Rewrote how custom titles are added and stored to help reduce conflict between authors
	- Moved table with custom titles into seperate section with register function
	- Use achievementId instead of raw title name to make it work with all languages
	- Make it default to english custom title if nothing is specified for the user's language
	- Support for LibTitleLocale to fix issues with title differences for males and females

	(Added the option to make a title hidden from the user itself) *mhuahahahaha*

	(v18)
	- Added support for colors and even a simple gradient
	- Moved language check to title registration

	(v19)
	- Fixed problems with UTF8 characters and color gradients

	(v20)
	- Added option to replace a title globally.
]]--

--[[

 Author: nogetrandom
 version 22
 Changes: Deleted a few letters and added a couple of new ones, and this is now independant from
 LibCustomTitles and LibStub.

]]--

HowToCustomTitle = HowToCustomTitle or {}
local HowToCustomTitle = HowToCustomTitle

local libName = "HowToCustomTitle"
EVENT_MANAGER:UnregisterForEvent(libName, EVENT_ADD_ON_LOADED)

local HTCT = HowToCustomTitle
HTCT.name = "HowToCustomTitle"
HTCT.version = 22
-- local LibCustomTitles, oldminor = LibStub:NewLibrary(LIB_NAME, VERSION)
if not HTCT then return end
--
local titles = {}

HowToCustomTitleModules = HowToCustomTitleModules or {}
function HowToCustomTitle:RegisterModule(name, version)

	local module = HowToCustomTitleModules[name]
	if (module and module.version and module.version > version) then
		return nil
	end

	module = {}
	module.version = version
	module.titles = {}
	module.RegisterTitle = RegisterTitle

	--override any previous titles from an older version
	HowToCustomTitleModules[name] = module
	return module
end

function HowToCustomTitle:InitTitles()
	for name, module in pairs(HowToCustomTitleModules) do
		for _, title in ipairs(module.titles) do
			self:RegisterTitle(unpack(title))
		end
	end
	HowToCustomTitleModules = nil --remove from global
end

local lang = GetCVar("Language.2")

local customTitles = {}
function HowToCustomTitle:RegisterTitle(displayName, charName, override, title, extra)

	if type(title) == "table" then
		title = title[lang] or title["en"]
	end

	local hidden = (extra == true) --support old format
	if type(extra) == "table" then
		hidden = extra["hidden"]
		if extra["color"] then
			title = self:ApplyColor(title, extra["color"], extra["hidden"])
		end
	end

	if hidden and (displayName == GetUnitDisplayName("player") or charName == GetUnitName("player")) then
		return
	end

	local playerGender = GetUnitGender("player")
	local genderTitle

	if type(override) == "boolean" then --override all titles
		override = override and "-ALL-" or "-NONE-"
	elseif type(override) == "number" then --get override title from achievementId
		local hasRewardOfType, titleName = GetAchievementRewardTitle(override, playerGender) --gender is 1 or 2
		if hasRewardOfType and titleName then
			genderTitle = select(2, GetAchievementRewardTitle(override, 3 - playerGender))  -- cuz 3-2=1 and 3-1=2
			override = titleName
		end
	elseif type(override) == "table" then --use language table with strings
		override = override[lang] or override["en"]
	end

	if type(override) == "string" then
		if not customTitles[displayName] then
			customTitles[displayName] = {}
		end
		local charOrAccount = customTitles[displayName]
		if charName then
			if not customTitles[displayName][charName]  then
				customTitles[displayName][charName] = {}
			end
			charOrAccount = customTitles[displayName][charName]
		end
		charOrAccount[override] = title
		if genderTitle and genderTitle ~= override then
			charOrAccount[genderTitle] = title
		end
	end
end

local MAX_GRADIENT_STEPS = 10 --after that text just starts to disappear
function HTCT:ApplyColor(text, color, dbg)

	if type(color) == "string" then 	-- just a simple color
		return "|c"..color:gsub("#","")..text.."|r"
	elseif type(color) ~= "table" then --wrong format??
		return text
	end

	local function hex2rgb(hex)
		hex = hex:gsub("#","")
		return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	end

	local gStart = {hex2rgb(color[1])}
	local gEnd   = {hex2rgb(color[2])}

	local splittedText, len = self:SplitText(text, 1) -- 1 = ignore space for length but still include them
	if dbg then d(splittedText) end

	local numSteps = zo_min(len, MAX_GRADIENT_STEPS)
	local stepSize = len / numSteps --we dont round this down directly

	local gSteps = {
		(gEnd[1]-gStart[1])/numSteps,
		(gEnd[2]-gStart[2])/numSteps,
		(gEnd[3]-gStart[3])/numSteps
	}

	local function FormatGradient(step)
		return ("|c%02X%02X%02X"):format(zo_floor(gStart[1] + gSteps[1] * step), zo_floor(gStart[2] + gSteps[2] * step), zo_floor(gStart[3] + gSteps[3] * step))
	end

	local step = 0
	local substep = math.min(stepSize - 1.01, 0) -- make sure we always use a char for the first color
	local gradientText = FormatGradient(step)
	for _, char in ipairs(splittedText) do
		if char ~= " " then
			substep = substep + 1
			if substep >= stepSize then
				substep = substep - stepSize
				step = step + 1
				gradientText = gradientText..FormatGradient(step)
			end
		end
		gradientText = gradientText..char
	end
	gradientText = gradientText.."|r"
	if dbg then d(gradientText) end

	return gradientText
end

function HowToCustomTitle:SplitText(text)

	-- Thank you @Ayantir!
	local splittedText = {}
	local textLen = string.len(text)
	local lenOffset = 0

	local splittedString
	local UTFAditionalBytes = 0

	local lastByte, byte = 0
	local splittedStart, splittedEnd = 1, 1
	while splittedStart <= textLen do
		splittedString = text:sub(splittedStart, splittedEnd) -- always one byte here

		byte = string.byte(splittedString)
		if (byte > 0 and byte < 128) then -- any ansi character (ex : a	97	LATIN SMALL LETTER A)
			if byte == 32 then -- space, add length offset
				lenOffset = lenOffset + 1
			end
		elseif byte >= 128 and byte < 192 then -- any non ansi character ends with last byte = 128-191 or 2nd byte of a 3 Byte character. We take 1 byte more.
			if lastByte >= 192 and lastByte < 224 then -- "2 latin characters" ex: 195 169	LATIN SMALL LETTER E WITH ACUTE ; е	208 181	CYRILLIC SMALL LETTER IE
				--
			elseif lastByte >= 128 and lastByte < 192 then -- "3 Bytes Cyrillic & Japaneese" ex U+3057	し	227 129 151	HIRAGANA LETTER SI
				--
			elseif lastByte >= 224 and lastByte < 240 then -- 2nd byte of a 3 Byte character. We take 1 byte more.
				UTFAditionalBytes = 1
			end
			splittedEnd = splittedEnd + UTFAditionalBytes
			splittedString = text:sub(splittedStart, splittedEnd)
		elseif byte >= 192 and byte < 224 then -- last byte = 1st byte of a 2 Byte character. We take 1 byte more.
			UTFAditionalBytes = 1
			splittedEnd = splittedEnd + UTFAditionalBytes
			splittedString = text:sub(splittedStart, splittedEnd)
		elseif byte >= 224 and byte < 240 then -- last byte = 1st byte of a 3 Byte character. We take 2 byte more.
			UTFAditionalBytes = 2
			splittedEnd = splittedEnd + UTFAditionalBytes
			splittedString = text:sub(splittedStart, splittedEnd)
		end

		table.insert(splittedText, splittedString)

		splittedStart = splittedEnd + 1
		splittedEnd   = splittedStart
		lastByte = byte
	end
	return splittedText, #splittedText - lenOffset
end

function HowToCustomTitle:Init()

	self:InitTitles()

	local CT_NO_TITLE = 0
	local CT_TITLE_ACCOUNT = 1
	local CT_TITLE_CHARACTER = 2

	local function GetCustomTitleType(displayName, unitName)
		if customTitles[displayName] then
			if customTitles[displayName][unitName] then
				return CT_TITLE_CHARACTER
			end
			return CT_TITLE_ACCOUNT
		end
		return CT_NO_TITLE
	end

	local function GetCustomTitle(originalTitle, customTitle)
		if customTitle then
			if customTitle[originalTitle] then
				return customTitle[originalTitle]
			elseif originalTitle == "" and customTitle["-NONE-"] then
				return customTitle["-NONE-"]
			elseif customTitle["-ALL-"] then
				return customTitle["-ALL-"]
			end
		end
	end

	local function GetModifiedTitle(originalTitle, displayName, charName)
		-- check for global override
		local returnTitle = GetCustomTitle(originalTitle, customTitles["-GLOBAL-"]) or originalTitle
		-- check for player override
		local registerType = GetCustomTitleType(displayName, charName)
		if registerType == CT_TITLE_CHARACTER then
			return GetCustomTitle(originalTitle, customTitles[displayName][unitName]) or returnTitle
		elseif registerType == CT_TITLE_ACCOUNT then
			return GetCustomTitle(originalTitle, customTitles[displayName]) or returnTitle
		end
		return returnTitle
	end

	local GetUnitTitle_original = GetUnitTitle
	GetUnitTitle = function(unitTag)
		local unitTitleOriginal = GetUnitTitle_original(unitTag)
		local unitDisplayName = GetUnitDisplayName(unitTag)
		local unitCharacterName = GetUnitName(unitTag)

		return GetModifiedTitle(unitTitleOriginal, unitDisplayName, unitCharacterName)
	end

	local GetTitle_original = GetTitle
	GetTitle = function(index)
		local titleOriginal = GetTitle_original(index)
		local displayName = GetDisplayName()
		local characterName = GetUnitName("player")

		return GetModifiedTitle(titleOriginal, displayName, characterName)
	end

end

local function OnAddonLoaded()
	if not libLoaded then
		libLoaded = true
		-- local HTCTI = HTCT.name
		HowToCustomTitle:Init()
		EVENT_MANAGER:UnregisterForEvent(HTCT.name, EVENT_ADD_ON_LOADED)
	end
end

EVENT_MANAGER:RegisterForEvent(HTCT.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)