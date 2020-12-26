LibCombat.lua

line 988

local function onBossesChanged(_) -- Detect Bosses

	data.bossInfo = {}
	local bossdata = data.bossInfo

	for i = 1, 12 do

		local unitTag = ZO_CachedStrFormat("boss<<1>>", i)

		if DoesUnitExist(unitTag) then

			local name = GetUnitName(unitTag)

			bossdata[name] = i
			currentfight.bossfight = true
			if currentfight.bossname == nil and name ~= nil and name ~= "" then currentfight.bossname = name end

		elseif i >= 2 then

			return

		end
	end
end

line 2237

local function CheckUnit(unitName, unitId, unitType, timems)

	if unitId == nil then return end

	local currentunits = currentfight.units

	if currentunits[unitId] == nil then currentunits[unitId] = UnitHandler:New(unitName, unitId, unitType) end
	local unit = currentunits[unitId]

	if unit.name == "Offline" or unit.name == "" then unit.name = ZO_CachedStrFormat(SI_UNIT_NAME, unitName) end

	if unit.unitType ~= COMBAT_UNIT_TYPE_GROUP and unitType==COMBAT_UNIT_TYPE_GROUP then

		unit.unitType = COMBAT_UNIT_TYPE_GROUP
		unit.isFriendly = true

	end

	if unit.isFriendly == false then

		local bossId = data.bossInfo[unit.name]		-- if this is a boss, add the id (e.g. 1 for unitTag == "boss1")

		if bossId then

			unit.bossId = bossId
			currentfight.bosses[bossId] = unitId

			unit.unitTag = ZO_CachedStrFormat("boss<<1>>", bossId)

		end

	end

	unit.dpsstart = unit.dpsstart or timems
	unit.dpsend = timems

	unit.starttime = unit.starttime or timems
	unit.endtime = timems
end

line 2577

local tagToBossId = {} -- avoid string ops

for i = 1, 12 do

	local unitTag = ZO_CachedStrFormat("boss<<1>>", i)

	tagToBossId[unitTag] = i

end

line 2780

function lib:GetCurrentFight()

	local copy = {}

	if currentfight.dpsstart ~= nil then

		ZO_DeepTableCopy(currentfight, copy)

	else

		copy = nil

	end

	return copy
end

line 3262

Events.BossHP = EventHandler:New(
	{LIBCOMBAT_EVENT_BOSSHP},
	function (self)
		self:RegisterEvent(EVENT_POWER_UPDATE, onBossHealthChanged, REGISTER_FILTER_UNIT_TAG, "boss1", REGISTER_FILTER_POWER_TYPE, POWERTYPE_HEALTH)
		self.active = true
	end
)
