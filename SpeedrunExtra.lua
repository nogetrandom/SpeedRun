Speedrun = Speedrun or {}
-------------------------
---- Variables    -------
-------------------------
local Speedrun = Speedrun
-------------------------
---- Functions    -------
-------------------------
function Speedrun.SlashCommand(command)
    -- Debug Options ----------------------------------------------------------
    if command == "dbg 0" then
        d(Speedrun.prefix .. "Debug Mode: Off")
        Speedrun.debugMode = 0
        Speedrun.savedVariables.debugMode = 0
    elseif command == "dbg 1" then
        d(Speedrun.prefix .. "Debug Mode: low (only checkpoints)")
        Speedrun.debugMode = 1
        Speedrun.savedVariables.debugMode = 1
		elseif command == "dbg 2" then
	       d(Speedrun.prefix .. "Debug Mode: high (all score updates)")
	       Speedrun.debugMode = 2
	       Speedrun.savedVariables.debugMode = 2
		-- Hide Group -------------------------------------------------------------
		elseif command == "hg" or command == "hidegroup" then
				Speedrun.HideGroupToggle()
    -- Adds -------------------------------------------------------------------
	elseif command == "scores" then
				Speedrun.PrintScoreReasons()
		-- Default ----------------------------------------------------------------
    else
        d(Speedrun.prefix .. " Command not recognized!\nCommand options are:\n--[ /speed dbg 0-2 ]-- To post selection in chat:\n<<	0 >> = Only specific settings confirmations.\n<<	1 >> = Checkpoint Score Updates.\n<< 2 >> = Every score update (adds included).\n--[ /speed hg ]--[ /speed hidegroup ]-- To toggle function on/off.")
    end
end

function Speedrun:dbg(debugLevel, ...)
    if debugLevel <= Speedrun.debugMode then
        local message = zo_strformat(...)
        d(Speedrun.prefix .. message)
    end
end

function Speedrun.AudioToggle( )
		local a = GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_ENABLED)
		if a ~= "1" then
				SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_ENABLED, "1")
				Speedrun:dbg(0, "Audio set to <<1>> (on)", GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_ENABLED))
		else
				SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_ENABLED, "0")
				Speedrun:dbg(0, "Audio set to <<1>> (off)", GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_ENABLED))
		end
end

function Speedrun.HideGroupToggle()
		Speedrun.HideGroup(not Speedrun.savedVariables.groupHidden)
end

function Speedrun.HideGroup(hide) --copied from HideGroup by Wheels - thanks!
		if hide == true then
				SetCrownCrateNPCVisible(true)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Hiding group members")
						Speedrun.savedVariables.nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
						Speedrun.savedVariables.healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
				end
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
		else
				SetCrownCrateNPCVisible(false)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Showing group members")
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(Speedrun.savedVariables.nameplates))
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(Speedrun.savedVariables.healthBars))
				end
		end
		Speedrun.savedVariables.groupHidden = hide
end

function Speedrun.PrintScoreReasons()
		for k, v in pairs(Speedrun.scores) do
				local score = Speedrun.scores[k]
				if score.display == true then
						d('|cdf4242' .. score.name .. ' |r' .. ' x ' .. score.times)
				else
						if score.times > 0 then
								Speedrun:dbg(2, '<<1>> x 0', score.name)
						end
				end
		end
		Speedrun:dbg(2, "Printing Complete")
end

function Speedrun.OnZoneChanged()
		if Speedrun.savedVariables.debugMode ~= 2 then return end
		local zoneName = GetUnitZone('player')
		-- local sub = GetPlayerActiveSubzoneName()
		local map = GetPlayerLocationName()
		-- local parent = GetPlayerActiveZoneName()
		if Speedrun.savedVariables.subZone ~= map then
				Speedrun:dbg(2, "[Zone: <<1>>] [Subzone: <<2>>]", zoneName, map)
				Speedrun.subZone = map
				Speedrun.savedVariables.subZone = Speedrun.subZone
		else
				Speedrun.subZone = map
				Speedrun.savedVariables.subZone = Speedrun.subZone
		end
		if zoneName:find("NOT_A_VALID_ZONE_NAME") then
				Speedrun:dbg(2, 'derp')
  	end
		CALLBACK_MANAGER:UnregisterCallback("OnWorldMapChanged", Speedrun.OnZoneChanged)
		zo_callLater(function()
				EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "zone")
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "zone", 2500, Speedrun.OnZoneChanged)
		end, 1000)
end

function Speedrun.BestPossible(raidID)
    local totalTime = 0
    for i, x in pairs(Speedrun.customTimerSteps[raidID]) do
        if Speedrun.GetSavedTimer(raidID,i) then
            totalTime = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + totalTime
        end
    end
    local vitality
    if raidID == 638 or raidID == 636 or raidID == 639 or raidID == 1082 or raidID == 635 then
        vitality = 24
    elseif raidID == 725 or raidID == 975 or raidID == 1000 or raidID == 1051 or raidID == 1121 or raidID == 1196 then
        vitality = 36
    elseif raidID == 677 or raidID == 1227 then
        vitality = 15
    end
    local score = tostring(math.floor(Speedrun.GetScore(totalTime, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore
    return score
end
