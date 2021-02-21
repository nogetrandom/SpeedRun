Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.slash      					= "/speed" or "/SPEED"
Speedrun.prefix     					= "|cffffffSpeed|r|cdf4242Run|r: "
Speedrun.debugMode 						= 0
-- Speedrun.mapName 							= ""
-------------------------
---- Functions    -------
-------------------------
function Speedrun.SlashCommand(command)
		local value
	  -- Debug Options ----------------------------------------------------------
    if command == "track 0" or command == "TRACK 0" then
			  d(Speedrun.prefix .. "Tracking: Off")
        Speedrun.debugMode = 0
        Speedrun.savedSettings.debugMode = 0

	  elseif command == "track 1" or command == "TRACK 1" then
			  d(Speedrun.prefix .. "Tracking: low (only checkpoints)")
        Speedrun.debugMode = 1
        Speedrun.savedSettings.debugMode = 1

		elseif command == "track 2" or command == "TRACK 2" then
			   d(Speedrun.prefix .. "Tracking: medium (checkpoints and some function updates)")
	       Speedrun.debugMode = 2
	       Speedrun.savedSettings.debugMode = 2

	 elseif command == "track 3" or command == "TRACK 3" then
				 d(Speedrun.prefix .. "Tracking: high (everything. can be a lot of spam.)")
				 Speedrun.debugMode = 3
				 Speedrun.savedSettings.debugMode = 3

		-- UI Options -------------------------------------------------------------
		elseif command == "move" or command == "lock" or command == "MOVE" or command == "LOCK" then
				Speedrun.isMoveable = not Speedrun.isMoveable
				Speedrun.savedVariables.isMoveable = Speedrun.isMoveable
				Speedrun.ToggleMovable()

		elseif command == "hide" or command == "HIDE" then
				value =	true
				Speedrun.uiIsHidden = value
				Speedrun.savedVariables.uiIsHidden = value
				Speedrun.SetUIHidden(value)

				if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						Speedrun.HideAdds(value)
				end

		elseif command == "show" or command == "SHOW" then
				value =	false
				Speedrun.uiIsHidden = value
				Speedrun.savedVariables.uiIsHidden = value
				Speedrun.SetUIHidden(value)

				if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						Speedrun.HideAdds(Speedrun.savedVariables.addsAreHidden)
				end

		-- Hide Group -------------------------------------------------------------
		elseif command == "hg" or command == "HG" or command == "hidegroup" then
				Speedrun.HideGroupToggle()

	  -- Adds -------------------------------------------------------------------
		elseif command == "score" or command == "SCORE" then
				Speedrun.PrintScoreReasons()

		elseif command == "lastscore" or command == "LASTSCORE" then
				Speedrun.PrintLastScoreReasons()

		-- elseif command == "sharescore" or command == "SHARESCORE" then
		-- 		Speedrun.ShareScoreReasons()

		-- Default ----------------------------------------------------------------
    else
        d(Speedrun.prefix .. " Command not recognized!\n[ |cffffff/speed|r (|cffffffcommand|r) ] options are:\n[ |cfffffftrack|r |cffffff0|r - |cffffff2|r ] To post selection in chat.\n    [ |cffffff0|r ]: Only settings changes.\n    [ |cffffff1|r ]: Trial Checkpoint Updates.\n    [ |cffffff2|r ]: Checkpoint and internal function updates.\n    [ |cffffff3|r ]: Every score update (adds included).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat")
    end
end

function Speedrun:dbg(debugLevel, ...)
    if debugLevel <= Speedrun.debugMode then
        local message = zo_strformat(...)
        d(Speedrun.prefix .. message)
    end
end

function Speedrun:post( ... )
    local message = zo_strformat(...)
    d( message )
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
		Speedrun.HideGroup(not Speedrun.savedSettings.groupHidden)
end

function Speedrun.HideGroup(hide) --copied from HideGroup by Wheels - thanks!
		if hide == true then
				SetCrownCrateNPCVisible(true)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Hiding Group Members")
						Speedrun.savedVariables.nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
						Speedrun.savedVariables.healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
				end
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
		else
				SetCrownCrateNPCVisible(false)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Showing Group Members")
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(Speedrun.savedVariables.nameplates))
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(Speedrun.savedVariables.healthBars))
				end
		end
		Speedrun.savedSettings.groupHidden = hide
end

function Speedrun.PrintScoreReasons()
		Speedrun:dbg(0, "[|cffffffCurrent Trial|r |cdf4242Score|r |cffffffFactors|r]")
		for k, v in pairs(Speedrun.scores) do

				local score = Speedrun.scores[k]
				if score.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if score.times > 0 then
								Speedrun:post('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:post('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
						end, 100)
				end
		end
end

function Speedrun.UpdateScoreFactors()
		local formatID = Speedrun.raidID

		if type(Speedrun.raidID) == "string" then
				if GetZoneId(GetUnitZoneIndex("player")) == 677 then
						formatID = tonumber(string.sub(Speedrun.raidID,1,3))
				-- VH
				elseif GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						formatID = tonumber(string.sub(Speedrun.raidID,1,4))
				end
		end

		local factor = Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[formatID].scoreFactors
		local vit = GetRaidReviveCountersRemaining()

		if vit > 0 then
				if factor.vitality < vit or factor.vitality == nil then
						factor.vitality = vit
				end
		end

		if factor.bestTime == nil or factor.bestTime > Speedrun.totalTime then
				factor.bestTime = Speedrun.totalTime
		end

		if factor.bestScore == nil or factor.bestScore < Speedrun.finalScore then
				factor.bestScore = Speedrun.finalScore
		end

		for score, v in pairs(factor.scoreReasons) do

				local best = factor.scoreReasons[score]
				local score = Speedrun.scores[score]

				if (score.times > 0 and score.id ~= RAID_POINT_REASON_LIFE_REMAINING) then
						if (best.times < score.times or best.times == nil) then
								best.times = score.times
								Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[Speedrun.raidID].scoreFactors.scoreReasons[score].times = score.times
						end
						if (best.total < score.total or best.total == nil) then
								best.total = score.total
								Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[Speedrun.raidID].scoreFactors.scoreReasons[score].total = score.total
						end
				end
		end
end

function Speedrun.BestPossible(raidID)
		local formatID = raidID
		-- For MA and VH
		if raidID == 677 or raidID == 1227 then
				formatID = raidID .. GetUnitName("player")

				if Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[formatID] == nil or Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[formatID] == {} then
						formatID = raidID
				end
		end

		local timer = 0
		local raid = 0

		-- For MA and VH to get correct timer without changing formatID which is needed after
		if type(raidID) == "string" then
				-- MA
				if GetZoneId(GetUnitZoneIndex("player")) == 677 then
						raid = tonumber(string.sub(raidID,1,3))
				-- VH
				elseif GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						raid = tonumber(string.sub(raidID,1,4))
				end

				for i, x in pairs(Speedrun.savedVariables.profiles[Speedrun.activeProfile].customTimerSteps[raid]) do

						if Speedrun.GetSavedTimer(raid,i) then
	            	timer = math.floor(Speedrun.GetSavedTimer(raid,i) / 1000) + timer
						else
								timer = GetRaidDuration()
	        	end
	    	end

		else

				for i, x in pairs(Speedrun.customTimerSteps[raidID]) do

						if Speedrun.GetSavedTimer(raidID,i) then
          			timer = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + timer
						else
								timer = GetRaidDuration()
						end
  			end
		end

		local vitality = GetRaidReviveCountersRemaining()

    local score = tostring(math.floor(Speedrun.GetScore(timer, vitality, formatID)))	--= 0

		-- CR
		--TODO do this for all trials after getting info
		-- if raidID == 1051 then
		-- 		-- adds at side bosses
		-- 		score = tostring(math.floor(Speedrun.GetScore(timer, vitality, 1051) - 2250 + Speedrun.scores[3].total))
		-- else
		--
		-- 		-- Other trials
		-- 	 	score = tostring(math.floor(Speedrun.GetScore(timer, vitality, formatID)))
		-- end

		local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore
		Speedrun:dbg(2, "Best Possible Score Calculated.")
		Speedrun.isScoreSet = true
		Speedrun.savedVariables.isScoreSet = Speedrun.isScoreSet
    return score
end

-- functions for debugging and maybe useful for new functions
function Speedrun.SetLastTrial()
		Speedrun.ResetLastTrial()
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
		Speedrun:dbg(0, "[|cffffffLast Trial|r |cdf4242Score|r |cffffffFactors|r]")
		for k, v in pairs(Speedrun.lastScores) do

				local lastScore = Speedrun.lastScores[k]
				if lastScore.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if lastScore.times > 0 then
								Speedrun:post('|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times .. ' = ' .. lastScore.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun:post('|cdf4242' .. lastScore.name .. '|r' .. ' x ' .. lastScore.times)
						end, 100)
				end
		end
end

--[[
function Speedrun.ShareScoreReasons()

		Speedrun.Print(Speedrun.prefix .. "Current Trial Score Factors:")
		for k, v in pairs(Speedrun.scores) do

				local score = Speedrun.scores[k]
				if score.id ~= RAID_POINT_REASON_LIFE_REMAINING then

						if score.times > 0 then
								Speedrun.Print('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				else
						zo_callLater(function()
								Speedrun.Print('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
						end, 100)
				end
		end
end

function Speedrun.Print( message )
		local outPut = string.format( message )
		CHAT_SYSTEM.textEntry:SetText( outPut )
		CHAT_SYSTEM:Maximize()
		CHAT_SYSTEM.textEntry:Open()
		CHAT_SYSTEM.textEntry:FadeIn()
end
]]
