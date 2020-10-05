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

    --settings
    addsOnCR = true,
    hmOnSS = 4,
}
Speedrun.Default.customTimerSteps = Speedrun.customTimerSteps
Speedrun.Default.raidList = Speedrun.raidList

-------------------
---- Functions ----
-------------------
--[[function Speedrun.Test()
    --Insert test here
end]]

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
        raidDurationSec = math.floor(timer / 1000)
    else
        raidDurationSec = timer
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
        return
    end
end

----------------
---- Trials ----
----------------

-- function Speedrun.MainBRP(_, title, _)
--     if title == 'Final Round' or title == 'Letzte Runde' or title == 'Dernière manche' or title == 'Последний раунд' or title == '最終ラウンド' then
--       -- EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "CombatEnded", 100, Speedrun.OnCombatEnd)
--       for i = 1, MAX_BOSSES do
--           local unitTag = "boss" .. tostring(i)
--           if DoesUnitExist("unitTag") then
--                 local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
--                 local x, y = GetMapPlayerPosition("player");
--                 local stage
--                 if  (x > 0.54 and x < 0.64 and y > 0.79 and y < 0.89 and GetUnitName(unitTag) == "Battlemage Ennodius") then
--                     if currentTargetHP <= 0 then
--                         stage = 1
--                     end
--
--                 elseif (x > 0.3 and x < 0.4 and y > 0.69 and y < 0.8 and GetUnitName(unitTag) == "Tames-the-Beast") then
--                     if currentTargetHP <= 0 then
--                         stage = 2
--                     end
--
--                 elseif (x > 0.41 and x < 0.52 and y > 0.43 and y < 0.53 and GetUnitName(unitTag) == "Lady Minara") then
--                     if currentTargetHP <= 0 then
--                         stage = 3
--                     end
--
--                 elseif (x > 0.63 and x < 0.73 and y > 0.22 and y < 0.32 and GetUnitName(unitTag) == "Lady Minara") then
--                     if currentTargetHP <= 0 then
--                         stage = 4
--                     end
--
--                 elseif (x > 0.4 and x < 0.5 and y > 0.08 and y < 0.18 and GetUnitName(unitTag) == "Drakeeh the Unchained") then
--                     if currentTargetHP <= 0 then
--                         stage = 5
--                     end
--
--                 else
--                     stage = 0
--                 end
--                 if Speedrun.stage == stage - 1 then
--                   Speedrun.stage = stage
--                   Speedrun.savedVariables.stage = Speedrun.stage
--                   Speedrun.UpdateWaypointNew(GetRaidDuration())
--                 end
--             end
--         end
--     end
-- end

function Speedrun.MainBRP() --copied from BRHelper thx @andy.s
    local x, y = GetMapPlayerPosition("player");
    local stage
    if IsUnitInCombat("player") and x > 0.54 and x < 0.64 and y > 0.79 and y < 0.89 then
        stage = 1
    elseif x > 0.3 and x < 0.4 and y > 0.69 and y < 0.8 then
        stage = 2
    elseif x > 0.41 and x < 0.52 and y > 0.43 and y < 0.53 then
        stage = 3
    elseif x > 0.63 and x < 0.73 and y > 0.22 and y < 0.32 then
        stage = 4
    elseif x > 0.4 and x < 0.5 and y > 0.08 and y < 0.18 then
        stage = 5
    else
        stage = 0
    end
    if Speedrun.stage == stage - 1 then
        Speedrun.stage = stage
        Speedrun.savedVariables.stage = Speedrun.stage
        Speedrun.UpdateWaypointNew(GetRaidDuration())
    end
end

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
        --elseif Speedrun.isBossDead == true then
        --    Speedrun.Reset()
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
        --elseif Speedrun.isBossDead == true then
        --    Speedrun.Reset()
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
        if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS or (scoreUpdateReason == RAID_POINT_REASON_SOLO_ARENA_COMPLETE and type(Speedrun.raidID) == "string") then
        --finish arena
           Speedrun.UpdateWaypointNew(GetRaidDuration())
           Speedrun.isBossDead = true
           Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
        end
    -- end
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
                      if Speedrun.Step > 6 and Speedrun.raidID == 1196 then return end
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
end

function Speedrun.UnregisterTrialsEvents()
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE)
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
    --     -- EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossRound", EVENT_DISPLAY_ANNOUNCEMENT, Speedrun.MainBRP)
        EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBRP)

    elseif type(Speedrun.raidID) == "string" or Speedrun.raidID == 635 then -- or Speedrun.raidID == 1082 then --MA, DSA
        EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.BossDead)

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
end

function Speedrun.OnTrialFailed()
    Speedrun.Reset()
    Speedrun.ResetUI()
    Speedrun.UnregisterTrialsEvents()
end

Speedrun.OnTrialComplete = function(eventCode, trialName, score, totalTime)
    if Speedrun.raidID == 636 or Speedrun.raidID == 1000 or Speedrun.raidID == 1051 or Speedrun.raidID == 1082
      then
        Speedrun.UpdateWaypointNew(totalTime)
    end
    SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(score))
    SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration()+1000, true))

    Speedrun.UnregisterTrialsEvents()
    Speedrun.raidID = 0
    Speedrun.savedVariables.raidID = Speedrun.raidID
end

function Speedrun.OnTrialStarted()
    Speedrun.Reset()
    Speedrun.RegisterTrialsEvents()
    Speedrun.UpdateCurrentScore()
    Speedrun.UpdateCurrentVitality()
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
    if not vet then return false end
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

    --Settings
    Speedrun.CreateSettingsWindow()

    --EVENT_MANAGER
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Activated", EVENT_PLAYER_ACTIVATED, Speedrun.OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Reticle", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.SetUIHidden(Speedrun.isMovable and ((not Speedrun.IsInTrialZone()) or IsReticleHidden())) end)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Started", EVENT_RAID_TRIAL_STARTED, Speedrun.OnTrialStarted) --start vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete) --finish vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Failed", EVENT_RAID_TRIAL_FAILED, Speedrun.OnTrialFailed) --reset vet trial

    --EVENT_MANAGER:RegisterForEvent(Speedrun.name, EVENT_TARGET_CHANGED, Speedrun.Test)

    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED)
    --SLASH_COMMANDS["/speedrun"] = function() Speedrun.UpdateWaypointNew(GetRaidDuration()) end
end

function Speedrun.OnAddOnLoaded(event, addonName)
    if addonName ~= Speedrun.name then return end
    Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
