Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.slash      					= "/speed"
Speedrun.prefix     					= "|cffffffSpeed|r|cdf4242Run|r: "
Speedrun.debugMode 						= 0
-- Speedrun.mapName 							= ""
-------------------------
---- Functions    -------
-------------------------
function Speedrun.SlashCommand(command)
    -- Debug Options ----------------------------------------------------------
    if command == "track 0" then
        d(Speedrun.prefix .. "Tracking: Off")
        Speedrun.debugMode = 0
        Speedrun.savedVariables.debugMode = 0
    elseif command == "track 1" then
        d(Speedrun.prefix .. "Tracking: low (only checkpoints)")
        Speedrun.debugMode = 1
        Speedrun.savedVariables.debugMode = 1
		elseif command == "track 2" then
	      d(Speedrun.prefix .. "Tracking: high (all score updates)")
	      Speedrun.debugMode = 2
	      Speedrun.savedVariables.debugMode = 2
		-- UI Options -------------------------------------------------------------
		elseif command == "hide" or command == "show" then
				Speedrun.uiIsHidden = not Speedrun.uiIsHidden
				Speedrun.savedVariables.uiIsHidden = Speedrun.uiIsHidden
				Speedrun.SetUIHidden(Speedrun.uiIsHidden)
				if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						Speedrun.addsAreHidden = not Speedrun.addsAreHidden
						Speedrun.savedVariables.addsAreHidden = Speedrun.addsAreHidden
						Speedrun.HideAdds(Speedrun.uiIsHidden)
				end
		elseif command == "lock" or command == "unlock" or command == "move" then
				Speedrun.isMovable = not Speedrun.isMovable
				Speedrun.savedVariables.isMovable =	Speedrun.isMovable
				Speedrun.ToggleMovable()
		-- Hide Group -------------------------------------------------------------
		elseif command == "hg" or command == "hidegroup" then
				Speedrun.HideGroupToggle()
    -- Adds -------------------------------------------------------------------
		elseif command == "score" then
				Speedrun.PrintScoreReasons()
		elseif command == "lastscore" then
				Speedrun.PrintLastScoreReasons()
		-- Default ----------------------------------------------------------------

		elseif command == "layers" then
				d("Listing all action layers:")
				for i = 1, GetNumActionLayers() do
 						local name, categoryCount = GetActionLayerInfo(i)
 						d(name)
				end

	  else
        d(Speedrun.prefix .. " Command not recognized!\n[ |cffffff/speed|r (|cffffffcommand|r) ] options are:\n[ |cfffffftrack|r |cffffff0|r - |cffffff2|r ] To post selection in chat.\n    [ |cffffff0|r ]: Only settings changes.\n    [ |cffffff1|r ]: Trial Checkpoint Updates.\n    [ |cffffff2|r ]: Every score update (adds included).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat")
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
		Speedrun:dbg(0, "Current Trial Score Factors:")
		for k, v in pairs(Speedrun.scores) do
				local score = Speedrun.scores[k]
				if score.id ~= RAID_POINT_REASON_LIFE_REMAINING then
						if score.times > 0 then
								Speedrun:dbg(0,'|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:dbg(0,'|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
						end, 100)
				end
		end
end

function Speedrun.BestPossible(raidID)
		local formatID = raidID
		if raidID == 677 or raidID == 1227 then  --for vMA
				formatID = raidID .. GetUnitName("player")
				if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
						formatID = raidID
				end
		end

		local timer = 0

		do
				if type(raidID) == "string" then --for vMA
						if GetZoneId(GetUnitZoneIndex("player")) == 667 then
								raidID = tonumber(string.sub(raidID,1,3))
						elseif GetZoneId(GetUnitZoneIndex("player")) == 1227 then
								raidID = tonumber(string.sub(raidID,1,4))
						end
				end
				for i, x in pairs(Speedrun.customTimerSteps[raidID]) do
	        	if Speedrun.GetSavedTimer(raidID,i) then
	            	timer = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + timer
	        	end
	    	end
		end

		local vL = GetRaidReviveCountersRemaining()
		local vitality = vL or 0
    local score = tostring(math.floor(Speedrun.GetScore(timer, vitality, formatID)))

		if raidID == 1051 then
				score = score - 2250 + Speedrun.scores[3].total -- adds at side bosses in CR
		end

		local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore
    return score
end

-- functions to use for debugging
function Speedrun.SetLastTrial()
		Speedrun.lastScores = Speedrun.scores
		Speedrun.savedVariables.lastScores = Speedrun.lastScores
		Speedrun.lastRaidID = Speedrun.raidID
		Speedrun.savedVariables.lastRaidID = Speedrun.lastRaidID
		Speedrun.lastRaidTimer = Speedrun.currentRaidTimer
		Speedrun.savedVariables.lastRaidTimer = Speedrun.lastRaidTimer
end

function Speedrun.GetLastTrial(score, id, timer)
		local value
		if score then	value	=	Speedrun.lastScores	end
		if id then value =	Speedrun.lastRaidID	end
		if timer then	value	= Speedrun.lastRaidTimer end
		return value
end

function Speedrun.ResetLastTrial()
		Speedrun.lastScores = {}
		Speedrun.lastRaidID = 0
		Speedrun.lastRaidTimer = {}
end

function Speedrun.PrintLastScoreReasons()
		Speedrun:dbg(0, "Last Trial Score Points:")
		for k, v in pairs(Speedrun.lastScores) do
				local lastScore = Speedrun.lastScores[k]
				if lastScore.id ~= RAID_POINT_REASON_LIFE_REMAINING then
						if lastScore.times > 0 then
								Speedrun:dbg(0,'|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times .. ' = ' .. lastScore.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:dbg(0,'|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times)
						end, 100)
				end
		end
end
