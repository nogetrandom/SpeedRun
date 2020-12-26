-----------------
---- Globals ----
-----------------

Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.name = "Speedrun"
Speedrun.version = "0.1.8.1"

Speedrun.segments = {}
Speedrun.segmentTimer = {}

Speedrun.currentRaidTimer = {}
Speedrun.displayVitality = ""
Speedrun.lastBossName = ""
Speedrun.raidID = 0
Speedrun.isBossDead = true
Speedrun.Step = 1
Speedrun.stage = 0

Speedrun.scoreUpdateReasons = {}

-- Speedrun.Portal = {}

Speedrun.slash      = "/speed"
Speedrun.prefix     = "[Speedrun] "
Speedrun.debugMode = 0

---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
    --table
    customTimerSteps = {},
    raidList = {},

    --UI
    segmentTimer = {},
    speedrun_container_OffsetX = 500,
    speedrun_container_OffsetY = 500,
    isMovable = true,
    uiIsHidden = true,

    --variables
    currentRaidTimer = {},
    lastBossName = "",
    raidID = 0,
    isBossDead = true,
    Step = 1,
    stage = 0,

		scoreUpdateReasons = {},

    --settings
    addsOnCR = true,
    hmOnSS = 4,
		debugMode = 0,

		nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
		GroupHidden = false,
}
Speedrun.Default.customTimerSteps = Speedrun.customTimerSteps
Speedrun.Default.raidList = Speedrun.raidList
-------------------
---- Functions ----
-------------------
--[[function Speedrun.Test()
    --Insert test here
end]]

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
		Speedrun.HideGroup(not Speedrun.savedVariables.GroupHidden)
end

function Speedrun.HideGroup(hide) -- from HideGroup by Wheels - thanks!
		if hide == true then
				SetCrownCrateNPCVisible(true)
				if Speedrun.savedVariables.GroupHidden ~= hide then
						Speedrun:dbg(0, "Hiding group members")
						Speedrun.savedVariables.nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
						Speedrun.savedVariables.healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
				end
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
		else
				SetCrownCrateNPCVisible(false)
				if Speedrun.savedVariables.GroupHidden ~= hide then
						Speedrun:dbg(0, "Showing group members")
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(Speedrun.savedVariables.nameplates))
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(Speedrun.savedVariables.healthBars))
				end
		end
		Speedrun.savedVariables.GroupHidden = hide
end

function Speedrun.GetSavedTimer(raidID,step)
    local formatID = raidID
    if raidID == 677 then --for vMA
        formatID = raidID .. GetUnitName("player")
        if (Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {}) then
            formatID = raidID
        end
    end

    if tonumber(Speedrun.customTimerSteps[raidID][step]) then
        return tonumber(Speedrun.customTimerSteps[raidID][step])*1000
    else
        return Speedrun.raidList[formatID].timerSteps[step]
    end
end

function Speedrun.FormatRaidTimer(timer, ms)
    ms = ms or true

    local raidDurationSec
    if ms then
				if timer == 0 then
        		raidDurationSec = math.floor(timer / 1000)
				else
						raidDurationSec = math.floor(timer / 1000) - 1
				end
    else
				if timer == 0 then
						raidDurationSec = timer
				else
        		raidDurationSec = timer - 1000
				end
    end
    if raidDurationSec then
        local returnedString = ""
        if raidDurationSec < 0 then returnedString = "-" end
        if raidDurationSec < 3600 and raidDurationSec > -3600 then
            return returnedString .. string.format("%02d:%02d",
                math.floor((math.abs(raidDurationSec) / 60) % 60),
                math.abs(raidDurationSec) % 60)
        else
            return returnedString .. string.format("%02d:%02d:%02d",
                math.floor(math.abs(raidDurationSec) / 3600),
                math.floor((math.abs(raidDurationSec) / 60) % 60),
                math.abs(raidDurationSec) % 60)
        end
    end
end

function Speedrun.FormatRaidScore(score)
    score = tostring(score)
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    return dScore .. "'" .. fScore
end

function Speedrun.GetScore(timer, vitality, raidID)
    if type(raidID) == "string" then --for vMA
        raidID = tonumber(string.sub(raidID,1,3))
    end

    if raidID == 638 then --AA
        return (124300 + (1000 * vitality)) * (1 + (900 - timer) / 10000)
    elseif raidID == 636 then --HRC
        return (133100 + (1000 * vitality)) * (1 + (900 - timer) / 10000)
    elseif raidID == 639 then --SO
        return (142700 + (1000 * vitality)) * (1 + (1500 - timer) / 10000)
    elseif raidID == 725 then --MoL
        return (108150 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)
    elseif raidID == 975 then --HoF
        return (160100 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)
    elseif raidID == 1000 then --AS
        return (70000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
    elseif raidID == 1051 then --CR
        if Speedrun.addsOnCR == false then
            return (85750 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
        else
            return (88000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
        end
    elseif raidID == 1082 then --BRP
        return (75000 + (1000 * vitality)) * (1 + (2400 - timer) / 10000)
    elseif raidID == 677 then --MA
        return (426000 + (1000 * vitality)) * (1 + (5400 - timer) / 10000)
    elseif raidID == 635 then --DSA
        return (20000 + (1000 * vitality)) * (1 + (3600 - timer) / 10000)
    elseif raidID == 1121 then --SS
        if Speedrun.hmOnSS == 1 then
            return (87250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)
        elseif Speedrun.hmOnSS == 2 then
            return (127250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)
        elseif Speedrun.hmOnSS == 3 then
            return (167250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)
        elseif Speedrun.hmOnSS == 4 then
            return (207250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)
        end
    elseif raidID == 1196 then --KA
        return (205950 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
		elseif raidID == 1227 then -- VH
				return (205450+ (1000 * vitality)) * (1 + (5400 - timer) / 10000)
    else
        return 0
    end
end

function Speedrun.UpdateWaypointNew(raidDuration)
    local raid = Speedrun.raidList[Speedrun.raidID]
    local waypoint = Speedrun.Step
    if raid then
        Speedrun.currentRaidTimer[waypoint] = math.floor(raidDuration)
        Speedrun.savedVariables.currentRaidTimer[waypoint] = Speedrun.currentRaidTimer[waypoint]

        Speedrun.UpdateWindowPanel(waypoint, raid)
        local timerWaypoint = 0
        if Speedrun.currentRaidTimer[waypoint - 1] then
            timerWaypoint = Speedrun.currentRaidTimer[waypoint] - Speedrun.currentRaidTimer[waypoint - 1]
        else
            timerWaypoint = Speedrun.currentRaidTimer[waypoint]
        end

        if (raid.timerSteps[waypoint] == nil or raid.timerSteps[waypoint] <= 0 or raid.timerSteps[waypoint] > timerWaypoint) then
            raid.timerSteps[waypoint] = timerWaypoint
            Speedrun.savedVariables.raidList = Speedrun.raidList
        end
        --d("SR:WayPoint = " .. waypoint)
        Speedrun.Step = Speedrun.Step + 1
        Speedrun.savedVariables.Step = Speedrun.Step
				local sT = Speedrun.FormatRaidTimer(GetRaidDuration(), true)
				Speedrun:dbg(1, '<<1>>: Step <<2>> at <<3>>.', raid, waypoint, sT)
        return
    end
end

function Speedrun.ScoreUpdate(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		local scoreTimer = GetRaidDuration()
		local sT = Speedrun.FormatRaidTimer(scoreTimer, true)
		for scoreUpdateReason in pairs(Speedrun.scoreReasons) do
				if scoreUpdateReason == Speedrun.scoreReasons[scoreUpdateReason] and scoreUpdateReason == Speedrun.scoreReasons[scoreUpdateReason].id then
						Speedrun.UpdateScoreReason(scoreUpdateReason, scoreAmount)
				end
		end
		if scoreUpdateReason ~= RAID_POINT_REASON_LIFE_REMAINING then
				Speedrun:dbg(2, 'Score Updated at <<5>>\nReason: <<2>>. Amount: <<3>>. Total: <<4>>.', eventCode, scoreUpdateReason, scoreAmount, totalScore, sT)
		end
end

function Speedrun.UpdateScoreReason(k, v)
		local sR = Speedrun.scoreReasons[k]
		if not sR then return end
		sR.times = sR.times + 1
		sR.total = sR.total + v
						-- if k > 0 and k < 6 then
						-- 		Speedrun.UpdateScoreReasonDisplay(k)
						-- elseif k == 17 then
						-- 		for Speedrun.scoreReasons do
						-- 				if sR.times ~= 0 then
												Speedrun:dbg(1, ' |cdf4242Reason <<1>>|r x<<2>> = <<3>> total', sR, sR.times, sR.total)
						-- 				end
						-- 		end
						-- end
end

function Speedrun.onScoreChanged(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		local scoreKey = Speedrun.scoreReasons[scoreUpdateReason].id
		local times = Speedrun.scoreUpdateReasons[scoreKey].times
		local total = Speedrun.scoreUpdateReasons[scoreKey].total
		if scoreKey == scoreUpdateReason then
				times[scoreKey] = times[scoreKey] + 1
				total[scoreKey] = total[scoreKey] + scoreAmount
		end
end

Speedrun.ZoneChange(_, zoneName, subZoneName, newSubzone, zoneId, subZoneId)
		if Speedrun.IsInTrialZone() then
				Speedrun:dbg(1, "Subzone Changed: <<2>>\nSubzone name / id: <<1>> / <<3>>", subZoneName, newSubzone, subZoneId)
		end
end
----------------
---- Arenas ----
----------------
Speedrun.MainBRP = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if Speedrun.Step <= 24 then
				if scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
						-- SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(totalScore))
				end
		end
end

Speedrun.MainMA = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if Speedrun.Step < 9 and scoreUpdateReason == 17 then
				Speedrun.UpdateWaypointNew(GetRaidDuration())
		end
end

Speedrun.MainVH = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if Speedrun.Step <= 7 then
				if scoreUpdateReason == 5 then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
				end
		end
end
----------------
---- Trials ----
----------------
function Speedrun.MainCloudrest()
    for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then
            --Zmaja got more than 64Million HP
            local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
            if Speedrun.Step == 1 then
                currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
            else
                currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
            end

            local percentageHP = currentTargetHP / maxTargetHP
            if IsUnitInCombat("player") and  Speedrun.isBossDead == true then
                if (Speedrun.Step == 1 and maxTargetHP >= 64000000) then --start fight with boss
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                    Speedrun.lastBossName = GetUnitName("boss" .. i)
                    Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
                end
                if (percentageHP <= 0.75 and Speedrun.Step == 2) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.5 and Speedrun.Step == 3) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.25 and Speedrun.Step == 4) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (GetUnitName("boss" .. i) ~= Speedrun.lastBossName and Speedrun.Step == 5) then
                    --ZMaja Shadow
                    Speedrun.UpdateWaypointNew(GetRaidDuration())
                end
            else
                currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
                if (currentTargetHP > 0 and Speedrun.Step <= 6) then
                    Speedrun.currentRaidTimer = {}
                    Speedrun.savedVariables.currentRaidTimer = Speedrun.currentRaidTimer
                    Speedrun.lastBossName = ""
                    Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
                    Speedrun.Step = 1
                    Speedrun.savedVariables.Step = Speedrun.Step
                elseif (currentTargetHP <= 0 and Speedrun.Step < 5) then
                    Speedrun.isBossDead = false -- not in HM
                    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                end
            end
        end
    end
end

function Speedrun.MainAsylum()
    for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then
            --Olms got more than 99Million HP
            local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
            local percentageHP = currentTargetHP / maxTargetHP

            if IsUnitInCombat("player") and Speedrun.isBossDead == true then
                if (Speedrun.Step == 1 and maxTargetHP >= 99000000) then --start fight with boss
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.9 and Speedrun.Step == 2) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.75 and Speedrun.Step == 3) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.5 and Speedrun.Step == 4) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())

                end
                if (percentageHP <= 0.25 and Speedrun.Step == 5) then
                    Speedrun.UpdateWaypointNew(GetRaidDuration())
                end
            else
                if (currentTargetHP > 0 and Speedrun.Step <= 6) then
                    Speedrun.currentRaidTimer = {}
                    Speedrun.savedVariables.currentRaidTimer = Speedrun.currentRaidTimer
                    Speedrun.Step = 1
                    Speedrun.savedVariables.Step = Speedrun.Step
                elseif currentTargetHP <= 0 then
                    Speedrun.isBossDead = false -- not in HM
                    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                end
            end
        end
    end
end

function Speedrun.LastArchive()
	 if IsUnitInCombat("player") and Speedrun.Step == 6 then
		  for i = 1, MAX_BOSSES do
          if DoesUnitExist("boss" .. i) then
              local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
              if currentTargetHP > 0 then
                  Speedrun.UpdateWaypointNew(GetRaidDuration())
                  --Unregister for update then register again on update for UI panel
                  EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "LastAA")
              end
					end
			end
	 end
end

Speedrun.BossDead = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
    if Speedrun.raidID == 635 then
        if scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM then
            Speedrun.UpdateWaypointNew(GetRaidDuration())
        elseif scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_LOW  then
            d("Need To Trigger on Low: " .. scoreUpdateReason)
        elseif scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_HIGH  then
            d("Need To Trigger on High: " .. scoreUpdateReason)
        end
        return
    end
		if scoreUpdateReason == RAID_POINT_REASON_SOLO_ARENA_COMPLETE then
			 	if type(Speedrun.raidID) == "string" then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
						Speedrun.isBossDead = true
						Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
				end
				return
		end
		if Speedrun.raidID == 1082 or Speedrun.raidID == 635 then
				if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
    		--finish arena
       	Speedrun.UpdateWaypointNew(GetRaidDuration())
       	Speedrun.isBossDead = true
       	Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
    end
end

function Speedrun.MainBoss()
	if Speedrun.Step == 6 and Speedrun.raidID == 638 then
		--to trigger the mage
		EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "LastAA", 333, Speedrun.LastArchive)
	end
    for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then
            local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
            if IsUnitInCombat("player") then
                -- boss encounter begins
                if Speedrun.isBossDead == true and currentTargetHP > 0 then
                    Speedrun.isBossDead = false
                    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                    Speedrun.UpdateWaypointNew(GetRaidDuration())
                    return
                end
            elseif Speedrun.raidID == 636 then --for HRC second boss
                if currentTargetHP <= 0 and Speedrun.isBossDead == false then
                    --boss dead
                    Speedrun.isBossDead = true
                    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                    SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(score))
                    Speedrun.UpdateWaypointNew(GetRaidDuration())
                    return
                end
            end
        end
    end
end

function Speedrun.CombatState()
		if IsUnitInCombat("player") then
				return true
		end
		return false
end
-----------------------
---- Base & Events ----
-----------------------
function Speedrun.Reset()
    Speedrun.currentRaidTimer = {}
    Speedrun.savedVariables.currentRaidTimer = Speedrun.currentRaidTimer
    Speedrun.displayVitality = ""
    Speedrun.lastBossName = ""
    Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
    Speedrun.isBossDead = true
    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
    Speedrun.Step = 1
    Speedrun.savedVariables.Step = Speedrun.Step
    Speedrun.stage = 0
    Speedrun.savedVariables.stage = Speedrun.stage

		Speedrun.scoreUpdateReasons = {}
		Speedrun.savedVariables.scoreUpdateReasons = Speedrun.scoreUpdateReasons
		-- Speedrun.Portal = {}
end

function Speedrun.UnregisterTrialsEvents()
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "RaidComplete", EVENT_RAID_TRIAL_SCORE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ArenaComplete", EVENT_RAID_TRIAL_SCORE_UPDATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "DeathScore", EVENT_RAID_REVIVE_COUNTER_UPDATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "VitalityLost", EVENT_RAID_REVIVE_COUNTER_UPDATE)
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "Update")
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "MiniTrial")
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "LastAA")
end

function Speedrun.RegisterTrialsEvents()
    if Speedrun.raidID == 1000 then --AS
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainAsylum)

    elseif Speedrun.raidID == 1051 then --CR
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainCloudrest)

    elseif Speedrun.raidID == 1082 then --BRP
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainBRP)
        -- EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBRP)

    elseif type(Speedrun.raidID) == "string" then
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainMA)

		 elseif Speedrun.raidID == 635 then --DSA
        EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.BossDead)

		elseif Speedrun.raidID == 1227 then --VH
        EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainVH)

    else -- other raids
       EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBoss)
       EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED, Speedrun.MainBoss)
        if Speedrun.raidID ~= 636 then --not for HRC
            EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.BossDead)
        end

    end
    EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "Update", 900, Speedrun.UpdateWindowPanel)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "DeathScore", EVENT_RAID_REVIVE_COUNTER_UPDATE, Speedrun.UpdateCurrentScore)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "VitalityLost", EVENT_RAID_REVIVE_COUNTER_UPDATE, Speedrun.UpdateCurrentVitality)
		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ScoreUpdate", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.ScoreUpdate)
end

function Speedrun.OnTrialFailed(eventCode, trialName, score)
    Speedrun.Reset()
    Speedrun.ResetUI()
    Speedrun.UnregisterTrialsEvents()
		Speedrun:dbg(1, '<<1>> Resetting', trialName)
end

Speedrun.OnTrialComplete = function(eventCode, trialName, score, totalTime)
    if Speedrun.raidID == 636 or Speedrun.raidID == 1000 or Speedrun.raidID == 1051 then
        Speedrun.UpdateWaypointNew(totalTime)
    end
    SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(score))
    SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration() +1000, true))

    Speedrun.UnregisterTrialsEvents()
    Speedrun.raidID = 0
    Speedrun.savedVariables.raidID = Speedrun.raidID
		Speedrun:dbg(1, " Trial Complete")

		local sR = Speedrun.scoreUpdateReasons[k]
		for k, v in pairs(Speedrun.scoreReasons) do
				if sR.times >= 1 then
						Speedrun:dbg(1, '|cdf4242Reason <<1>>|r x<<2>> = <<3>> total', sR, sR.times, sR.total)
				end
		end
end

function Speedrun.OnTrialStarted()
		-- Speedrun.ResetScoreReasons()
    Speedrun.Reset()
    Speedrun.RegisterTrialsEvents()
    Speedrun.UpdateCurrentScore()
    Speedrun.UpdateCurrentVitality()
		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "RaidComplete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete)
		Speedrun:dbg(1, "Trial Started")
end

function Speedrun.OnPlayerActivated()
		local zoneID = GetZoneId(GetUnitZoneIndex("player"))
    if zoneID == 677 then --for vMA
        zoneID = zoneID .. GetUnitName("player")
    end
    if Speedrun.IsInTrialZone() then
        if Speedrun.raidID ~= zoneID then
            Speedrun.Reset()
            Speedrun.ResetUI()
            Speedrun.raidID = zoneID
            Speedrun.savedVariables.raidID = Speedrun.raidID
        end
        Speedrun.CreateRaidSegment(zoneID)
        Speedrun.SetUIHidden(false)

        if GetRaidDuration() < 86400000 then --less than one day
            Speedrun.RegisterTrialsEvents()
						SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration() +1000, true))
        end
    else
        Speedrun.raidID = zoneID
        Speedrun.savedVariables.raidID = Speedrun.raidID
        Speedrun.SetUIHidden(true)
        Speedrun.UnregisterTrialsEvents()
				-- Speedrun:dbg(2, " Player is outside Trial Zone")
    end
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Activated")
end

function Speedrun.IsInTrialZone()
    local vet = IsUnitUsingVeteranDifficulty("player")
    if not vet then return false end
    for k, v in pairs(Speedrun.raidList) do
        if Speedrun.raidList[k].id == GetZoneId(GetUnitZoneIndex("player")) then
						Speedrun.UpdateCurrentVitality()
						-- Speedrun:dbg(1, " Loading <<1>> timers for <<2>>", Speedrun.raidList[k].name, GetUnitName("player"))
						return true
        end
    end
    return false
end

function Speedrun:Initialize()
    --Saved Variables
    Speedrun.savedVariables = ZO_SavedVars:NewAccountWide("SpeedrunVariables", 2, nil, Speedrun.Default)

		if GetDisplayName() == "@nogetrandom" then
				ZO_CreateStringId("SI_BINDING_NAME_SR_TOGGLE_AUDIO", "Toggle Audio")
		end

		ZO_CreateStringId("SI_BINDING_NAME_SR_TOGGLE_HIDEGROUP", "Toggle Hide Group")

    -- UI
    Speedrun.ResetUI()
    Speedrun.ResetAnchors()

    --Init Variables
    Speedrun.customTimerSteps = Speedrun.savedVariables.customTimerSteps
    Speedrun.raidList = Speedrun.savedVariables.raidList

    Speedrun.segmentTimer = Speedrun.savedVariables.segmentTimer

    Speedrun.currentRaidTimer = Speedrun.savedVariables.currentRaidTimer
    Speedrun.lastBossName = Speedrun.savedVariables.lastBossName
    Speedrun.raidID = Speedrun.savedVariables.raidID
    Speedrun.isBossDead = Speedrun.savedVariables.isBossDead
    Speedrun.Step = Speedrun.savedVariables.Step
    Speedrun.stage = Speedrun.savedVariables.stage

    Speedrun.addsOnCR = Speedrun.savedVariables.addsOnCR
    Speedrun.hmOnSS = Speedrun.savedVariables.hmOnSS
    Speedrun.isMovable = Speedrun.Default.isMovable
    Speedrun.uiIsHidden = Speedrun.savedVariables.uiIsHidden
    -- Speedrun.uiSimple = Speedrun.savedVariables.uiSimple
		Speedrun.debugMode = Speedrun.savedVariables.debugMode
		-- Speedrun.Portal = Speedrun.savedVariables.Portal
		Speedrun.scoreUpdateReasons = Speedrun.savedVariables.scoreUpdateReasons

    --Settings
    Speedrun.CreateSettingsWindow()

    --EVENT_MANAGER
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Activated", EVENT_PLAYER_ACTIVATED, Speedrun.OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Reticle", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.SetUIHidden(Speedrun.isMovable and ((not Speedrun.IsInTrialZone()) or IsReticleHidden())) end)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Started", EVENT_RAID_TRIAL_STARTED, Speedrun.OnTrialStarted) --start vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete) --finish vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Failed", EVENT_RAID_TRIAL_FAILED, Speedrun.OnTrialFailed) --reset vet trial

		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "GroupHidden", EVENT_PLAYER_ACTIVATED, function()
				if Speedrun.savedVariables.GroupHidden then
						Speedrun.HideGroup(Speedrun.savedVariables.GroupHidden)
				end
		end) -- For after porting

		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Zone", EVENT_ZONE_CHANGED, Speedrun.ZoneChange)

    --EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_TARGET_CHANGED, Speedrun.Test)

		SLASH_COMMANDS[Speedrun.slash] = Speedrun.SlashCommand

		for scoreUpdateReason in pairs(Speedrun.scoreReasons) do
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. Speedrun.scoreReasons[scoreUpdateReason].name, EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.onScoreChanged)
				EVENT_MANAGER:AddFilterForEvent(Speedrun.name .. Speedrun.scoreReasons[scoreUpdateReason].name, EVENT_RAID_TRIAL_SCORE_UPDATE, REGISTER_FILTER_RAID_POINT_REASON, Speedrun.scoreReasons[scoreUpdateReason].id)
		end

    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED)
end

function Speedrun.OnAddOnLoaded(event, addonName)
    if addonName ~= Speedrun.name then return end
    Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
