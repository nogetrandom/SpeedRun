-----------------
---- Globals ----
-----------------

Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.name = "Speedrun"
Speedrun.version = "0.1.8.2"

Speedrun.segments = {}
Speedrun.segmentTimer = {}

-- Speedrun.adds = {
-- 		small = 0,
-- 		large = 0,
-- 		elite = 0,
-- 		total = 0,
-- }

Speedrun.currentRaidTimer = {}
Speedrun.displayVitality = ""
Speedrun.lastBossName = ""
Speedrun.raidID = 0
Speedrun.isBossDead = true
Speedrun.Step = 1
Speedrun.stage = 0
-- Speedrun.subZone = ""

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
		scoreReasons = {},

    --UI
    segmentTimer = {},
    speedrun_container_OffsetX = 500,
    speedrun_container_OffsetY = 500,
    isMovable = true,
    uiIsHidden = true,

    --variables
		-- adds = {
		-- 		small = 0,
		-- 		large = 0,
		-- 		elite = 0,
		-- 		total = 0,
		-- },
    currentRaidTimer = {},
    lastBossName = "",
    raidID = 0,
    isBossDead = true,
    Step = 1,
    stage = 0,
		-- subZone = "",

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
Speedrun.Default.scoreReasons = Speedrun.scoreReasons
-- Speedrun.Default.adds = Speedrun.adds
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
    -- Adds -------------------------------------------------------------------
		elseif command == "adds" then
				Speedrun.PostAdds()
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

function Speedrun.PostAdds()
		Speedrun.scoreReasons = Speedrun.savedVariables.scoreReasons
		for k, v in pairs(Speedrun.scoreReasons) do
				local times = Speedrun.scoreReasons[k].times
				local name = Speedrun.scoreReasons[k].name
				d('|cdf4242' .. name .. ' |r' .. ' x ' .. times)
		end
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

Speedrun.ScoreUpdate = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		local scoreTimer = GetRaidDuration()
		local sT = Speedrun.FormatRaidTimer(scoreTimer, true)
		if scoreUpdateReason ~= 9 then
				Speedrun:dbg(2, 'Score Updated at <<5>>\nReason: <<2>>. Amount: <<3>>. Total: <<4>>.', eventCode, scoreUpdateReason, scoreAmount, totalScore, sT)
		elseif scoreUpdateReason == RAID_POINT_REASON_LIFE_REMAINING and GetRaidReviveCountersRemaining() > 0 then
				Speedrun:dbg(2, 'Vitality Lost')
		end
		for k, v in pairs(Speedrun.scoreReasons) do
        if Speedrun.scoreReasons[k] == scoreUpdateReason or Speedrun.scoreReasons[k].id == scoreUpdateReason then
						Speedrun.scoreReasons[k].times = Speedrun.scoreReasons[k].times + 1
						Speedrun.savedVariables.scoreReasons[k].times = Speedrun.scoreReasons[k].times
						if Speedrun.scoreReasons[k] == 1 or Speedrun.scoreReasons[k].id == RAID_POINT_REASON_KILL_NORMAL_MONSTER then
								SpeedRun_Adds_SA_Counter:SetText(Speedrun.scoreReasons[k].times .. " / 63")
								-- return
						elseif Speedrun.scoreReasons[k] == 2 or Speedrun.scoreReasons[k].id == RAID_POINT_REASON_KILL_BANNERMEN then
								SpeedRun_Adds_LA_Counter:SetText(Speedrun.scoreReasons[k].times .. " / 33")
								-- return
						elseif Speedrun.scoreReasons[k] == 3 or Speedrun.scoreReasons[k].id == RAID_POINT_REASON_KILL_CHAMPION then
								SpeedRun_Adds_EA_Counter:SetText(Speedrun.scoreReasons[k].times .. " / 14")
								-- return
						end
				end
		end
		-- if Speedrun.RaidID == 1227 then
				-- Speedrun.UpdateAdds()
		-- end
end

Speedrun.ZoneChange = function(_, zoneName, subZoneName, newSubzone, zoneId, subZoneId)
		-- for k, v in pairs(Speedrun.raidList) do
		-- 		if Speedrun.raidList[k].id == zoneID then
						local sub = GetPlayerActiveSubzoneName()
						local parent = GetPlayerActiveZoneName()
						local map = GetPlayerLocationName()
						Speedrun:dbg(2, "Location Changed! New Location:\n[Map: <<3>>] [Zone: <<1>>] [Subzone: <<2>>]", parent, sub, map)
				-- end
		-- end
end
----------------
---- Arenas ----
----------------
Speedrun.MainArena = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if Speedrun.raidID == 677 then --MA
			 	if Speedrun.Step <= 9 and scoreUpdateReason == 17 then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
				end
				if scoreUpdateReason == RAID_POINT_REASON_SOLO_ARENA_COMPLETE then
						Speedrun.isBossDead = true
						Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
				end

		elseif Speedrun.raidID == 1082 then --BRP
				if Speedrun.Step <= 24 and (scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE) then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
				end
				if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
						Speedrun.UpdateWaypointNew(GetRaidDuration())
						Speedrun.isBossDead = true
						Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
				end

		elseif Speedrun.raidID == 635 then --DSA
        if scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM then
            Speedrun.UpdateWaypointNew(GetRaidDuration())
				end
				if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
       			Speedrun.UpdateWaypointNew(GetRaidDuration())
       			Speedrun.isBossDead = true
       			Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
				end
		end
end

function Speedrun.MainVH()
		for i = 1, MAX_BOSSES do
				if DoesUnitExist("boss" .. i) then
						local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
						currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
						if (currentTargetHP <= 0 and Speedrun.Step <= 7) then
								local boss = GetUnitName("boss" .. i)
								local lastBoss = Speedrun.lastBossName
								if lastBoss == boss then
										return
								end
								if boss == "Zakuryn the Sculptor" or boss == "Flesh Abomination" then
										EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Zakuryn", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.Zakuryn)
										return
								end
								if lastBoss ~= boss then
										Speedrun.UpdateWaypointNew(GetRaidDuration())
										Speedrun.lastBossName = boss
										Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
								end
								-- Speedrun.BossCheck(boss)
						end
				end
		end
end

-- function Speedrun.BossCheck(boss)
-- 		local lastBoss = Speedrun.lastBossName
-- 		if lastBoss == boss then
-- 				return
-- 		end
-- 		if boss == "Zakuryn the Sculptor" or boss == "Flesh Abomination" then
-- 				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Zakuryn", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.Zakuryn)
-- 				return
-- 		end
-- 		if lastBoss ~= boss then
-- 				Speedrun.UpdateWaypointNew(GetRaidDuration())
-- 				Speedrun.lastBossName = boss
-- 				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
-- 		end
-- end

Speedrun.Zakuryn = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		 if scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE then
				Speedrun.UpdateWaypointNew(GetRaidDuration())
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Zakuryn", EVENT_RAID_TRIAL_SCORE_UPDATE)
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

Speedrun.BossDead = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
 				Speedrun.UpdateWaypointNew(GetRaidDuration())
       	Speedrun.isBossDead = true
       	Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
    end
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
		Speedrun.scoreReasons = {}
		Speedrun.savedVariables.scoreReasons = Speedrun.scoreReasons
		-- Speedrun.Portal = {}
end

function Speedrun.UnregisterTrialsEvents()
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "MainArena", EVENT_RAID_TRIAL_SCORE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Zakuryn", EVENT_RAID_TRIAL_SCORE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_SCORE_UPDATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "DeathScore", EVENT_RAID_REVIVE_COUNTER_UPDATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "VitalityLost", EVENT_RAID_REVIVE_COUNTER_UPDATE)
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "Update")
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "MiniTrial")
    EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "LastAA")
		EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
end

function Speedrun.RegisterTrialsEvents()
    if Speedrun.raidID == 1000 then --AS
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainAsylum)

    elseif Speedrun.raidID == 1051 then --CR
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainCloudrest)

    elseif Speedrun.raidID == 1082 or type(Speedrun.raidID) == "string" or Speedrun.raidID == 635 then --BRP, MA, DSA
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainArena)
        -- EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBRP)

		elseif Speedrun.raidID == 1227 then --VH
        -- EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainVH)
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "VHBoss", 333, Speedrun.MainVH)
				-- Speedrun.HideAdds(false)
				--EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleVH", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds( not IsReticleHidden()) end)

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
end

function Speedrun.OnTrialStarted()
    Speedrun.Reset()
    Speedrun.RegisterTrialsEvents()
    Speedrun.UpdateCurrentScore()
    Speedrun.UpdateCurrentVitality()
		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete)
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
						if Speedrun.raidID ~= 1227 then
								SpeedRun_Adds:SetHidden(true)
						else
								SpeedRun_Adds:SetHidden(false)
						end
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
    end
end

function Speedrun.IsInTrialZone()
    local vet = IsUnitUsingVeteranDifficulty("player")
    if not vet then
				-- Speedrun.Reset()
				-- Speedrun.ResetUI()
				return false
		end
    for k, v in pairs(Speedrun.raidList) do
        if Speedrun.raidList[k].id == GetZoneId(GetUnitZoneIndex("player")) then
						Speedrun.UpdateCurrentVitality()
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
		Speedrun.scoreReasons = Speedrun.savedVariables.scoreReasons

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
		Speedrun.debugMode = Speedrun.savedVariables.debugMode

		-- Speedrun.Portal = Speedrun.savedVariables.Portal
		-- Speedrun.uiSimple = Speedrun.savedVariables.uiSimple

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

    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED)
end

function Speedrun.OnAddOnLoaded(event, addonName)
    if addonName ~= Speedrun.name then return end
    Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)


-- SET SkipPregameVideos "1"
-- SET HasPlayedPregameVideo "1"
-- SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(Speedrun.savedVariables.nameplates))
-- GetSetting(SETTING_TYPE_USERSETTINGS.SkipPregameVideos)
