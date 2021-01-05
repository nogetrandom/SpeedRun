-----------------
---- Globals ----
-----------------
Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.name 						= "Speedrun"
Speedrun.version 					= "0.1.8.2"

Speedrun.segments 				= {}
Speedrun.segmentTimer 		= {}

Speedrun.currentRaidTimer = {}
Speedrun.finalScore 			= 0
Speedrun.displayVitality 	= ""
Speedrun.lastBossName 		= ""
Speedrun.currentBossName	= ""
Speedrun.raidID 					= 0
Speedrun.isBossDead 			= true
Speedrun.Step 						= 1
Speedrun.stage 						= 0
---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default.customTimerSteps = Speedrun.customTimerSteps
Speedrun.Default.raidList = Speedrun.raidList
-------------------
---- Functions ----
-------------------
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
        Speedrun.Step = Speedrun.Step + 1
        Speedrun.savedVariables.Step = Speedrun.Step
				local sT = Speedrun.FormatRaidTimer(GetRaidDuration(), true)
				local trial = GetUnitZone('player')
				Speedrun:dbg(1, '[<<1>>] Step <<2>> at <<3>>.', trial, waypoint, sT)
        return
    end
end

Speedrun.ScoreUpdate = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		local scoreTimer = GetRaidDuration()
		local sT = Speedrun.FormatRaidTimer(scoreTimer, true)
		if scoreUpdateReason ~= 9 then
				Speedrun:dbg(2, 'Score Updated at <<5>>\nReason: <<2>>. Amount: <<3>>. Total: <<4>>.', eventCode, scoreUpdateReason, scoreAmount, totalScore, sT)
		end
		for k, v in pairs(Speedrun.scores) do
        if Speedrun.scores[k] == scoreUpdateReason or Speedrun.scores[k].id == scoreUpdateReason then
						Speedrun.scores[k].times = Speedrun.scores[k].times + 1
						Speedrun.savedVariables.scores[k].times = Speedrun.scores[k].times
				end
						if Speedrun.raidID == 1227 or GetUnitZone('player') == 'Vateshran Hollows' then
						Speedrun.UpdateAdds()
				end
		end
end

function Speedrun.UpdateAdds()
		for k, v in pairs(Speedrun.scores) do
				local score = Speedrun.scores[k]
				if score == 1 or score.id == RAID_POINT_REASON_KILL_NORMAL_MONSTER then
						SpeedRun_Adds_SA:SetText(score.name)
						SpeedRun_Adds_SA_Counter:SetText(score.times .. " / 68")
				elseif score == 2 or score.id == RAID_POINT_REASON_KILL_BANNERMEN then
						SpeedRun_Adds_LA:SetText(score.name)
						SpeedRun_Adds_LA_Counter:SetText(score.times .. " / 33")
				elseif score == 3 or score.id == RAID_POINT_REASON_KILL_CHAMPION then
						SpeedRun_Adds_EA:SetText(score.name)
						SpeedRun_Adds_EA_Counter:SetText(score.times .. " / 15")
				end
		end
end
----------------
---- Arenas ----
----------------
Speedrun.MainArena = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if Speedrun.raidID == 677 then --MA
			 	if Speedrun.Step <= 8 and scoreUpdateReason == 17 then
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
		--arena last boss
		-- if scoreUpdateReason == RAID_POINT_REASON_SOLO_ARENA_COMPLETE then
		-- 		Speedrun.UpdateWaypointNew(GetRaidDuration())
		-- 		Speedrun.isBossDead = true
		-- 		Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
		-- end
end
--[[	GetMapName
local mapN = GetMapName()
if mapN ~= nil then
		SR.mapName = mapN
		SpeedRun_Zone_5:SetText("Map Name: |ce6b800" .. SR.mapName .. "|r")
		sV.mapName = SR.mapName
else
		SpeedRun_Zone_5:SetText("mapN: nil")
end
]]
function Speedrun.MainVH()
		-- Speedrun.currentBossName = ""
		for i = 1, MAX_BOSSES do
				if DoesUnitExist("boss" .. i) then -- and IsUnitInCombat("player") then
						--local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
								--currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
								--if (currentTargetHP >= 0 and
						Speedrun.currentBossName = GetUnitName("boss" .. i)
						-- SpeedRun_Adds_Boss1:SetText("|cffcc00" .. Speedrun.currentBossName .. "|r")
						local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
						currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
						if Speedrun.Step <= 6 then
								if Speedrun.currentBossName == Speedrun.lastBossName then
										return
								end
								-- if IsUnitInCombat("player") then

								if currentTargetHP <= 0 and (boss == "Leptfire Keeper" or boss == "Xobutar of His Deep Graces" or boss == "Mynar Metron") then
										local sT = Speedrun.FormatRaidTimer(GetRaidDuration(), true)
										Speedrun.dbg(1, "<<1>> killed at <<2>>", boss, sT)
										return
								end

								-- if boss == "Rahdgarak" then
										-- 		if currentTargetHP > 0 then
										-- 				return
										-- 		end
										-- 		if currentTargetHP <= 0 then
										-- 				Speedrun.lastBossName = Speedrun.currentBossName
										-- 				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
										-- 				Speedrun.UpdateWaypointNew(GetRaidDuration())
										-- 				return
										-- 		end
										-- end
										--
										-- if boss == "The Pyrelord" then
										-- 		if currentTargetHP >= 1 then
										-- 				return
										-- 		end
										-- 		if currentTargetHP <= 0 then
										-- 				Speedrun.lastBossName = Speedrun.currentBossName
										-- 				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
										-- 				Speedrun.UpdateWaypointNew(GetRaidDuration())
										-- 				return
										-- 		end
										-- end
								if IsUnitInCombat("player") then
										if Speedrun.lastBossName ~= Speedrun.currentBossName then
												-- EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
												EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.arenaBoss)
										else
												return
										end
								end
								-- if boss == "Maebroogha the Void Lich" then
										-- 		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainArena)
										-- 		return
										-- end
										-- if lastBoss ~= boss then
										-- 		Speedrun.UpdateWaypointNew(GetRaidDuration())
										-- 		Speedrun.lastBossName = boss
										-- 		Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
										-- 		if Speedrun.Step == 6 then
										-- 				EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
										-- 		end
										-- end
								-- if Speedrun.Step == 6 then
								-- 		zo_callLater(function()
								-- 				EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
								-- 		end, 5000)
						end
				else
						Speedrun.currentBossName = ""
				end
		end
end

Speedrun.arenaBoss = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		 if scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE then
			 	Speedrun.lastBossName = Speedrun.currentBossName
			 	Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
				-- SpeedRun_Adds_Boss2:SetText("|c00ff00" .. Speedrun.lastBossName .. "|r")
				Speedrun.UpdateWaypointNew(GetRaidDuration())
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE)

				zo_callLater(function()
						EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
						EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "VHBoss", 333, Speedrun.MainVH)
				end, 2000)
		end
end

function Speedrun.BossFightVH()

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
		if GetRaidDuration() > 0 then return end
		Speedrun.finalScore = 0
		Speedrun.savedVariables.finalScore = Speedrun.finalScore
    Speedrun.currentRaidTimer = {}
    Speedrun.savedVariables.currentRaidTimer = Speedrun.currentRaidTimer
    Speedrun.displayVitality = ""
    Speedrun.lastBossName = ""
    Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
		Speedrun.currentBossName = ""
		Speedrun.savedVariables.currentBossName = Speedrun.currentBossName
    Speedrun.isBossDead = true
    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
    Speedrun.Step = 1
    Speedrun.savedVariables.Step = Speedrun.Step
    Speedrun.stage = 0
    Speedrun.savedVariables.stage = Speedrun.stage
		Speedrun.scores = Speedrun.GetDefaultScores()
		Speedrun.savedVariables.scores = Speedrun.scores
		Speedrun.raidID = 0
    Speedrun.savedVariables.raidID = Speedrun.raidID
end

function Speedrun.UnregisterTrialsEvents()
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE)
    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "MainArena", EVENT_RAID_TRIAL_SCORE_UPDATE)
		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE)
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

		elseif Speedrun.raidID == 1227 then --VH
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "VHBoss", 333, Speedrun.MainVH)
				Speedrun.HideAdds(false)
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleVH", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds((not Speedrun.IsInTrialZone()) or IsReticleHidden()) end)

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
    if Speedrun.raidID == 636 or Speedrun.raidID == 1000 or Speedrun.raidID == 1051 or Speedrun.raidID == 1082 or Speedrun.raidID == 1227 then
				zo_callLater(function()
						Speedrun.UpdateWaypointNew(GetRaidDuration())
				end, 1000)
    end
		Speedrun.finalScore = Speedrun.FormatRaidScore(score)
    SpeedRun_Score_Label:SetText(Speedrun.finalScore)
    SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration() +1000, true))

    Speedrun.UnregisterTrialsEvents()
    -- Speedrun.raidID = 0
    -- Speedrun.savedVariables.raidID = Speedrun.raidID
		local trial = GetUnitZone('player')
		Speedrun:dbg(1, "|c00ff00<<3>>|r Complete!\n[Time: |c00ff00<<1>>|r]  [Score: |c00ff00<<2>>|r]", Speedrun.FormatRaidTimer(GetRaidDuration() +1000, true), Speedrun.finalScore, trial)
end

function Speedrun.OnTrialStarted()
    Speedrun.Reset()
    Speedrun.RegisterTrialsEvents()
    Speedrun.UpdateCurrentScore()
    Speedrun.UpdateCurrentVitality()
		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete)
		if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
				Speedrun.ResetAddsUI()
				Speedrun.UpdateAdds()
				Speedrun.HideAdds(false)
		end
		local trial = GetUnitZone('player')
		Speedrun:dbg(1, "Trial: |c00ff00<<1>>|r Started!", trial)
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
						if zoneID ~= 1227 then
							EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ReticleVH", EVENT_RETICLE_HIDDEN_UPDATE)
							Speedrun.HideAdds(true)
						else
							Speedrun.ResetAddsUI()
							Speedrun.UpdateAdds()
							Speedrun.HideAdds(false)
						end
            Speedrun.raidID = zoneID
            Speedrun.savedVariables.raidID = Speedrun.raidID
        end
        Speedrun.CreateRaidSegment(zoneID)
        Speedrun.SetUIHidden(false)

				if zoneID == 1227 then
						Speedrun.HideAdds(false)
						EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleVH", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds((not Speedrun.IsInTrialZone()) or IsReticleHidden()) end)
				end
        if GetRaidDuration() < 86400000 then --less than one day
            Speedrun.RegisterTrialsEvents()
						SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration() +1000, true))
        end
    else
        Speedrun.raidID = zoneID
        Speedrun.savedVariables.raidID = Speedrun.raidID
        Speedrun.SetUIHidden(true)
        Speedrun.UnregisterTrialsEvents()
				Speedrun.HideAdds(true)
    end
end

function Speedrun.IsInTrialZone()
    local vet = IsUnitUsingVeteranDifficulty("player")
    if not vet then
				Speedrun.SetUIHidden(true)
				Speedrun.HideAdds(true)
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
		Speedrun:GenerateDefaultScores()
    --Saved Variables
    Speedrun.savedVariables = ZO_SavedVars:NewAccountWide("SpeedrunVariables", 2, nil, Speedrun.Default)

		ZO_CreateStringId("SI_BINDING_NAME_SR_TOGGLE_HIDEGROUP", "Toggle Hide Group")

    -- UI
    Speedrun.ResetUI()
    Speedrun.ResetAnchors()

    --Init Variables
		Speedrun.finalScore = Speedrun.savedVariables.finalScore
    Speedrun.customTimerSteps = Speedrun.savedVariables.customTimerSteps
    Speedrun.raidList = Speedrun.savedVariables.raidList
		Speedrun.scores = Speedrun.savedVariables.scores

    Speedrun.segmentTimer = Speedrun.savedVariables.segmentTimer

    Speedrun.currentRaidTimer = Speedrun.savedVariables.currentRaidTimer
    Speedrun.lastBossName = Speedrun.savedVariables.lastBossName
		Speedrun.currentBossName = Speedrun.savedVariables.currentBossName
    Speedrun.raidID = Speedrun.savedVariables.raidID
    Speedrun.isBossDead = Speedrun.savedVariables.isBossDead
    Speedrun.Step = Speedrun.savedVariables.Step
    Speedrun.stage = Speedrun.savedVariables.stage

    Speedrun.addsOnCR = Speedrun.savedVariables.addsOnCR
    Speedrun.hmOnSS = Speedrun.savedVariables.hmOnSS
    Speedrun.isMovable = Speedrun.Default.isMovable
    Speedrun.uiIsHidden = Speedrun.savedVariables.uiIsHidden
		Speedrun.addsAreHidden = Speedrun.savedVariables.addsAreHidden
		Speedrun.debugMode = Speedrun.savedVariables.debugMode
		Speedrun.groupHidden = Speedrun.savedVariables.groupHidden

		Speedrun.mapName = Speedrun.savedVariables.mapName

    --Settings
    Speedrun.CreateSettingsWindow()

		--/commands
		SLASH_COMMANDS[Speedrun.slash] = Speedrun.SlashCommand

    --EVENT_MANAGER
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Activated", EVENT_PLAYER_ACTIVATED, Speedrun.OnPlayerActivated)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Reticle", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.SetUIHidden(Speedrun.isMovable and ((not Speedrun.IsInTrialZone()) or IsReticleHidden())) end)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Started", EVENT_RAID_TRIAL_STARTED, Speedrun.OnTrialStarted) --start vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete) --finish vet trial
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Failed", EVENT_RAID_TRIAL_FAILED, Speedrun.OnTrialFailed) --reset vet trial

		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "GroupHidden", EVENT_PLAYER_ACTIVATED, function()
				if Speedrun.savedVariables.groupHidden then
						Speedrun.HideGroup(Speedrun.savedVariables.groupHidden)
				end
		end) -- For after porting

		if GetDisplayName() == "@nogetrandom" or GetDisplayName() == "@Mille_W" then
				ZO_CreateStringId("SI_BINDING_NAME_SR_TOGGLE_AUDIO", "Toggle Audio")
				ZO_CreateStringId("SI_BINDING_NAME_SR_CANCEL_CAST", "Cancel Cast")
		end

    EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED)
end

function Speedrun.OnAddOnLoaded(event, addonName)
    if addonName ~= Speedrun.name then return end
    Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
