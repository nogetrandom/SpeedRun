-----------------
---- Globals ----
-----------------
Speedrun = Speedrun or {}
local Speedrun = Speedrun
Speedrun.name 							= "Speedrun"
Speedrun.version 						= "0.1.8.3"
Speedrun.segments 					= {}
Speedrun.segmentTimer 			= {}
Speedrun.currentRaidTimer 	= {}
Speedrun.displayVitality 		= ""
Speedrun.lastBossName 			= ""
Speedrun.currentBossName		= ""
Speedrun.raidID 						= 0
Speedrun.isBossDead 				= true
Speedrun.Step 							= 1
Speedrun.slain							= {}
Speedrun.totalTime					= 0
Speedrun.isComplete					= false
Speedrun.isUIDrawn					= false
Speedrun.isScoreSet					= false
Speedrun.activeProfile			= ""
Speedrun.profileToImportTo 	= ""
-------------------
---- Functions ----
-------------------
function Speedrun.GetSavedTimer(raidID,step)

		--for MA and VH
		local formatID = raidID
		if raidID == 677 or raidID == 1227 then
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
						raidDurationSec = math.floor(timer / 1000)
				end

		else
				if timer == 0 then
						raidDurationSec = timer
				else
						raidDurationSec = timer --	- 1000
				end
    end

		if raidDurationSec then

				local returnedString = ""
			  if raidDurationSec < 0 then
						returnedString = "-"
				end

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

		-- for MA and VH
		if type(raidID) == "string" then

				if GetZoneId(GetUnitZoneIndex("player")) == 677 then
						raidID = tonumber(string.sub(raidID,1,3))

				elseif GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						raidID = tonumber(string.sub(raidID,1,4))
				end
		end

		--AA
		if raidID == 638 then
				return (124300 + (1000 * vitality)) * (1 + (900 - timer) / 10000)

		--HRC
		elseif raidID == 636 then
				return (133100 + (1000 * vitality)) * (1 + (900 - timer) / 10000)

		--SO
		elseif raidID == 639 then
				return (142700 + (1000 * vitality)) * (1 + (1500 - timer) / 10000)

		--MoL
		elseif raidID == 725 then
				return (108150 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)

		--HoF
		elseif raidID == 975 then
				return (160100 + (1000 * vitality)) * (1 + (2700 - timer) / 10000)

		--AS
		elseif raidID == 1000 then
				return (70000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)


		--CR
		elseif raidID == 1051 then
			  if Speedrun.addsOnCR == false then
            return (85750 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)

				else
				    return (88000 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)
        end

		--BRP
		elseif raidID == 1082 then
				return (75000 + (1000 * vitality)) * (1 + (2400 - timer) / 10000)

		--MA
		elseif raidID == 677 then
				return (426000 + (1000 * vitality)) * (1 + (5400 - timer) / 10000)

		--DSA
		elseif raidID == 635 then
				return (20000 + (1000 * vitality)) * (1 + (3600 - timer) / 10000)

		--SS
		elseif raidID == 1121 then
			  if Speedrun.hmOnSS == 1 then
					  return (87250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)

				elseif Speedrun.hmOnSS == 2 then
					  return (127250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)

				elseif Speedrun.hmOnSS == 3 then
					  return (167250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)

				elseif Speedrun.hmOnSS == 4 then
				    return (207250 + (1000 * vitality)) * (1 + (1800 - timer) / 10000)
        end

		--KA
		elseif raidID == 1196 then
			  return (205950 + (1000 * vitality)) * (1 + (1200 - timer) / 10000)

		--VH
		elseif raidID == 1227 then
				return (205450 + (1000 * vitality)) * (1 + (5400 - timer) / 10000)

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
						Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList = Speedrun.raidList
        end

				Speedrun.Step = Speedrun.Step + 1
        Speedrun.savedVariables.Step = Speedrun.Step
				local sT = Speedrun.FormatRaidTimer(GetRaidDuration(), true)
				local trial = GetUnitZone('player')
				Speedrun:dbg(1, '[|ce6b800<<1>>|r] |ce6b800Step <<2>>|r at |cffffff<<3>>|r.', trial, waypoint, sT)
        return
    end
end

Speedrun.ScoreUpdate = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		local scoreTimer = GetRaidDuration()
		local sT = Speedrun.FormatRaidTimer(scoreTimer, true)

		for k, v in pairs(Speedrun.scores) do

				if Speedrun.scores[k] == scoreUpdateReason or Speedrun.scores[k].id == scoreUpdateReason then
						Speedrun.scores[k].times = Speedrun.scores[k].times + 1
						Speedrun.scores[k].total = Speedrun.scores[k].total + scoreAmount
						Speedrun.savedVariables.scores[k].times = Speedrun.scores[k].times
						Speedrun.savedVariables.scores[k].total = Speedrun.scores[k].total

						if scoreUpdateReason ~= 9 then
								Speedrun:dbg(3, 'Score Updated at |cffffff<<5>>|r.\nType: |cffffff<<2>>|r. Amount: |cffffff<<3>>|r. Total: |cffffff<<4>>|r.', eventCode, Speedrun.scores[k].name, scoreAmount, totalScore, sT)
						end
				end

				if GetUnitZone('player') == 'Vateshran Hollows' then
						Speedrun.UpdateAdds()
				end
		end
end

function Speedrun.UpdateAdds()
		if not GetUnitZone('player') == 'Vateshran Hollows' then return end

		for k, v in pairs(Speedrun.scores) do
				local score = Speedrun.scores[k]

				if score == 1 or score.id == RAID_POINT_REASON_KILL_NORMAL_MONSTER then
						SpeedRun_Adds_SA:SetText(score.name)
						SpeedRun_Adds_SA_Counter:SetText(score.times .. " / 68")

						if score.times == 68 then
								SpeedRun_Adds_SA_Counter:SetColor(0, 1, 0, 1)
						else
								SpeedRun_Adds_SA_Counter:SetColor(1, 1, 1, 1)
						end

				elseif score == 2 or score.id == RAID_POINT_REASON_KILL_BANNERMEN then
						SpeedRun_Adds_LA:SetText(score.name)
						SpeedRun_Adds_LA_Counter:SetText(score.times .. " / 33")

						if score.times == 33 then
								SpeedRun_Adds_LA_Counter:SetColor(0, 1, 0, 1)
						else
								SpeedRun_Adds_LA_Counter:SetColor(1, 1, 1, 1)
						end

				elseif score == 3 or score.id == RAID_POINT_REASON_KILL_CHAMPION then
						SpeedRun_Adds_EA:SetText(score.name)
						SpeedRun_Adds_EA_Counter:SetText(score.times .. " / 15")

						if score.times == 15 then
								SpeedRun_Adds_EA_Counter:SetColor(0, 1, 0, 1)
						else
								SpeedRun_Adds_EA_Counter:SetColor(1, 1, 1, 1)
						end
				end
		end
end
----------------
---- Arenas ----
----------------
Speedrun.MainArena = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)

		if GetZoneId(GetUnitZoneIndex("player")) == 677 --[[Speedrun.raidID == 677]] then --MA
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
		for i = 1, MAX_BOSSES do
				if DoesUnitExist("boss" .. i) then

						Speedrun.currentBossName = GetUnitName("boss" .. i)
						local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
						currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)

						if Speedrun.Step <= 6 then

								if Speedrun.currentBossName == Speedrun.lastBossName then	return end

								local boss = Speedrun.currentBossName
								if boss == "Leptfire Keeper" or boss == "Xobutar of His Deep Graces" or boss == "Mynar Metron" then

										if currentTargetHP <= 0 then
												if not IsUnitInCombat("player") then
														local sT = Speedrun.FormatRaidTimer(GetRaidDuration(), true)
														Speedrun:dbg(1, "|cdf4242<<1>>|r killed at |cffff00<<2>>|r", boss, sT)
												end
										end
										return
								end

								if IsUnitInCombat("player") then
										if Speedrun.lastBossName ~= boss then
												EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.arenaBoss)

										else
												return
										end
								end
						end
				end
		end
end

Speedrun.arenaBoss = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		 if scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE then

				Speedrun.lastBossName = Speedrun.currentBossName
				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
				Speedrun.currentBossName = ""
				Speedrun.UpdateWaypointNew(GetRaidDuration())
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ArenaBoss", EVENT_RAID_TRIAL_SCORE_UPDATE)

				zo_callLater(function()
						EVENT_MANAGER:UnregisterForUpdate(Speedrun.name .. "VHBoss")
						EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "VHBoss", 1000, Speedrun.MainVH)
				end, 2000)
		end
end
----------------
---- Trials ----
----------------
function Speedrun.MainCloudrest()
	  for i = 1, MAX_BOSSES do
				if DoesUnitExist("boss" .. i) then

						local currentTargetHP, maxTargetHP, effmaxTargetHP = 1, 1, 1
						Speedrun.currentBossName = GetUnitName("boss" .. i)

						if Speedrun.Step == 1 then
                currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("reticleover", POWERTYPE_HEALTH)
					  else
							  currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
            end

						if IsUnitInCombat("player") and Speedrun.isBossDead == true then

								local percentageHP = currentTargetHP / maxTargetHP

								--Zmaja got more than 64Million HP
								if (Speedrun.Step == 1 and maxTargetHP >= 64000000) then

										--start fight with boss
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

								if (Speedrun.currentBossName) ~= Speedrun.lastBossName and Speedrun.Step == 5 then

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

										-- not in HM
										Speedrun.isBossDead = false
                    Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                end
            end
        end
    end
end

function Speedrun.MainAsylum()
	  for i = 1, MAX_BOSSES do
				if DoesUnitExist("boss" .. i) then

            local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
            local percentageHP = currentTargetHP / maxTargetHP
						--start fight with boss
					  if IsUnitInCombat("player") then -- and Speedrun.isBossDead == true then

								--Olms got more than 99Million HP
								if (Speedrun.Step == 1 and maxTargetHP >= 99000000) then
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

										-- not in HM
										Speedrun.isBossDead = false
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
						Speedrun.currentBossName = GetUnitName("boss" .. i)
						if Speedrun.currentBossName == Speedrun.lastBossName then
								return
						end

						local currentTargetHP, maxTargetHP, effmaxTargetHP = GetUnitPower("boss" .. i, POWERTYPE_HEALTH)
						if IsUnitInCombat("player") then

								-- boss encounter begins
                if Speedrun.isBossDead == true and currentTargetHP > 0 then
                    Speedrun.isBossDead = false
										Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
										if Speedrun.lastBossName ~= Speedrun.currentBossName then
												Speedrun.UpdateWaypointNew(GetRaidDuration())
												Speedrun.lastBossName = Speedrun.currentBossName
												return
                		end
								end

						elseif Speedrun.raidID == 636 then

								--for HRC second boss
								if currentTargetHP <= 0 and Speedrun.isBossDead == false then

										--boss dead
                    Speedrun.isBossDead = true
										Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
                    SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(score))
                    Speedrun.UpdateWaypointNew(GetRaidDuration())
								    return
                end
            end

				else
						Speedrun.currentBossName = ""
        end
    end
end

Speedrun.BossDead = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
		if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
				Speedrun.lastBossName = Speedrun.currentBossName
				Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
				Speedrun.isBossDead = true
				Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
				Speedrun.UpdateWaypointNew(GetRaidDuration())
    end
end

function Speedrun.OnTrialStarted()
	-- Speedrun.Reset()
	Speedrun.RegisterTrialsEvents()
	-- Speedrun.UpdateCurrentScore()
	Speedrun.UpdateCurrentVitality()

	EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete)

	if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
		Speedrun.ResetAddsUI()
		Speedrun.UpdateAdds()
		Speedrun.HideAdds(false)
	end
	Speedrun:dbg(1, "Trial: |ce6b800<<1>>|r Started!", GetUnitZone('player'))
end

Speedrun.OnTrialComplete = function(eventCode, trialName, score, totalTime)

	-- for arenas and mini-trials (not CR)
	if Speedrun.raidID == 636 or Speedrun.raidID == 1000 or Speedrun.raidID == 1082 or GetZoneId(GetUnitZoneIndex("player")) == 677 or GetZoneId(GetUnitZoneIndex("player")) == 1227 then
			Speedrun.UpdateWaypointNew(totalTime)
	end

	-- for CR
	if Speedrun.raidID == 1051 then
			Speedrun.Step = 6
			Speedrun.UpdateWaypointNew(totalTime)
	end

	-- save data before resetting in case we need it
	Speedrun.finalScore = score
	Speedrun.savedVariables.finalScore = Speedrun.finalScore
	Speedrun.totalTime = totalTime
	Speedrun.savedVariables.totalTime = Speedrun.totalTime

	Speedrun.UpdateScoreFactors()
	Speedrun.SetLastTrial()

	SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(Speedrun.finalScore))
	SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(Speedrun.totalTime, true))

	Speedrun.isComplete = true
	Speedrun.savedVariables.isComplete = Speedrun.isComplete

	Speedrun.UnregisterTrialsEvents()

	-- reset raidID to force variables to reset when porting
	Speedrun.raidID = 0
	Speedrun.savedVariables.raidID = Speedrun.raidID

	Speedrun:dbg(1, "|ce6b800<<3>>|r |c00ff00Complete|r!\n[Time: |cffffff<<1>>|r]  [Score: |cffffff<<2>>|r]", Speedrun.FormatRaidTimer(GetRaidDuration(), true), 	Speedrun.finalScore, trialName)
end
-----------------------
---- Base & Events ----
-----------------------
function Speedrun.Reset()
		Speedrun.isComplete = false
		Speedrun.savedVariables.isComplete = Speedrun.isComplete
		Speedrun.scores = Speedrun.GetDefaultScores()
		Speedrun.savedVariables.scores = Speedrun.scores
    Speedrun.displayVitality = ""
		Speedrun.currentRaidTimer = {}
		Speedrun.savedVariables.currentRaidTimer = Speedrun.currentRaidTimer
		Speedrun.Step = 1
		Speedrun.savedVariables.Step = Speedrun.Step
		Speedrun.raidID = 0
		Speedrun.savedVariables.raidID = Speedrun.raidID
		Speedrun.isBossDead = true
		Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
		Speedrun.lastBossName = ""
		Speedrun.savedVariables.lastBossName = Speedrun.lastBossName
		Speedrun.currentBossName = ""
		Speedrun.savedVariables.currentBossName = Speedrun.currentBossName
		Speedrun.isUIDrawn = false
		Speedrun.savedVariables.isUIDrawn = Speedrun.isUIDrawn
		Speedrun.isScoreSet = false
		Speedrun.savedVariables.isScoreSet = Speedrun.isScoreSet

		Speedrun:dbg(2, "Resetting Variables.")
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
		--AS
		if Speedrun.raidID == 1000 then
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainAsylum)

		--CR
		elseif Speedrun.raidID == 1051 then
        EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "MiniTrial", 333, Speedrun.MainCloudrest)

		--BRP, MA, DSA
		elseif Speedrun.raidID == 1082 or GetZoneId(GetUnitZoneIndex("player")) == 677 --[[and type(Speedrun.raidID) == "string")]] or Speedrun.raidID == 635 then
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.MainArena)

		--VH
		elseif --[[Speedrun.raidID == 1227 and]] GetZoneId(GetUnitZoneIndex("player")) == 1227 then
				EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "VHBoss", 333, Speedrun.MainVH)
				Speedrun.HideAdds(Speedrun.savedVariables.addsAreHidden)
				-- EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleAdds", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds(Speedrun.savedVariables.uiIsHidden) end)

		-- other raids
		else
       EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Combat", EVENT_PLAYER_COMBAT_STATE, Speedrun.MainBoss)
       EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossChange", EVENT_BOSSES_CHANGED, Speedrun.MainBoss)

				--not for HRC
				if Speedrun.raidID ~= 636 then
            EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "BossDead", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.BossDead)
        end
    end

		EVENT_MANAGER:RegisterForUpdate(Speedrun.name .. "Update", 900, Speedrun.UpdateWindowPanel)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "DeathScore", EVENT_RAID_REVIVE_COUNTER_UPDATE, Speedrun.UpdateCurrentScore)
    EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "VitalityLost", EVENT_RAID_REVIVE_COUNTER_UPDATE, Speedrun.UpdateCurrentVitality)
		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ScoreUpdate", EVENT_RAID_TRIAL_SCORE_UPDATE, Speedrun.ScoreUpdate)
end

function Speedrun.OnTrialFailed(eventCode, trialName, score)
		-- Speedrun.SetLastTrial()
    Speedrun.Reset()
    Speedrun.ResetUI()
    Speedrun.UnregisterTrialsEvents()
		Speedrun:dbg(1, '|ce6b800<<1>>|r |cff0000Failed|r. Resetting', trialName)
end

function Speedrun.OnPlayerActivated()
		local zoneID = GetZoneId(GetUnitZoneIndex("player"))
		--for MA and VH to save timers for each character individualy.
		if zoneID == 677 or zoneID == 1227 then
				zoneID = zoneID .. GetUnitName("player")
		end

		if Speedrun.IsInTrialZone() then

				-- In trial but it's completed.
				if (zoneID == Speedrun.lastRaidID and GetRaidDuration() == Speedrun.totalTime) then
						Speedrun.isComplete = true
						SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(Speedrun.finalScore))
						Speedrun.CreateRaidSegment(zoneID)
						-- Don't reset before leaving instance
						Speedrun:dbg(2, "Trial is Complete. Returning.")
						return
				end

				-- if Speedrun.isComplete == true then
				--
				-- 		-- In case addon is loaded while inside a completed trial
				-- 		if (Speedrun.isScoreSet == false and Speedrun.raidID == zoneID) then
				-- 		end
				-- 		if (Speedrun.isUIDrawn == false and Speedrun.raidID == zoneID) then
				-- 		end
				--
				-- end

				-- New instance. Reset variables from last trial
				-- TODO If player entered a trial in progress. Think of ways to best handle it.
				if Speedrun.raidID ~= zoneID then
            Speedrun.Reset()
						Speedrun.ResetUI()

						-- If in VH; Refresh variables and UI for adds.
						if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
								Speedrun:dbg(1, "In New VH.")
								Speedrun.scores = Speedrun.GetDefaultScores()
								Speedrun.savedVariables.scores = Speedrun.scores
								Speedrun.ResetAddsUI()
								Speedrun.UpdateAdds()
						end

						-- Make sure not to reset if player is still in the same trial.
						Speedrun.raidID = zoneID
            Speedrun.savedVariables.raidID = Speedrun.raidID
					end

				-- In trial but not started yet. Display score calculated from best recorded timers instead of nothing.
				if GetRaidDuration() <= 0 and not IsRaidInProgress() then
						SpeedRun_Score_Label:SetText(Speedrun.BestPossible(Speedrun.raidID))
				end

				-- Create UI display if player loaded addon while inside a trial.
				if Speedrun.isUIDrawn == false then
						Speedrun.CreateRaidSegment(zoneID)
				end

				if Speedrun.isScoreSet == false then
						Speedrun.UpdateCurrentScore()
				end

				-- Display UI.
        Speedrun.SetUIHidden(false)

				-- Configure VH adds display visibility.
				if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleAdds", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds((not Speedrun.IsInTrialZone()) or IsReticleHidden()) end)
				else
						EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ReticleAdds", EVENT_RETICLE_HIDDEN_UPDATE)
						Speedrun.HideAdds(true)
				end

				-- Less than one day.
				if GetRaidDuration() < 86400000 then
            Speedrun.RegisterTrialsEvents()
						SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration() --[[+1000]], true))
				end

		else
				-- Player is not in a trial. Disable UI and tracking and make sure to reset in next trial.
        Speedrun.raidID = zoneID
        Speedrun.savedVariables.raidID = Speedrun.raidID
				Speedrun.UnregisterTrialsEvents()
				Speedrun.SetUIHidden(true)
				Speedrun.HideAdds(true)
    end
end

function Speedrun.IsInTrialZone()
		for k, v in pairs(Speedrun.raidList) do
				if Speedrun.raidList[k].id == GetZoneId(GetUnitZoneIndex("player")) then

						local vet = IsUnitUsingVeteranDifficulty("player")
						if not vet then
								Speedrun.SetUIHidden(true)
								Speedrun.HideAdds(true)
								Speedrun:dbg(2, "Difficulty: Normal. Hiding UI")
								return false
						end
						Speedrun.UpdateCurrentVitality()
						return true
        end
    end
		return false
end

-- function Speedrun.LoadTrial()
-- 		local zoneID = GetZoneId(GetUnitZoneIndex("player"))
-- 		--for MA and VH to save timers for each character individualy.
-- 		if zoneID == 677 or zoneID == 1227 then
-- 				zoneID = zoneID .. GetUnitName("player")
-- 		end
--
-- 		-- Speedrun.CreateRaidSegment(zoneID)
--
-- 		if not IsRaidInProgress() then
-- 				if GetRaidDuration() <= 0 then
-- 						SpeedRun_Score_Label:SetText(Speedrun.BestPossible(Speedrun.raidID))
-- 				elseif Speedrun.isComplete == true then
-- 						SpeedRun_Score_Label:SetText(Speedrun.finalScore)
-- 						SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(Speedrun.totalTime, true))
-- 				end
-- 		end
-- end

function Speedrun.ToggleTracking()
		Speedrun.Tracking(not Speedrun.savedSettings.isTracking)
end

function Speedrun.Tracking(track)
		if track ~= true then

				-- take no action if not already registered
				if Speedrun.savedSettings.isTracking == false then return end

				-- shut down everything trial related
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Activated", EVENT_PLAYER_ACTIVATED)
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Reticle", EVENT_RETICLE_HIDDEN_UPDATE)
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Started", EVENT_RAID_TRIAL_STARTED)
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE)
				EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Failed", EVENT_RAID_TRIAL_FAILED)
				Speedrun.UnregisterTrialsEvents()
				Speedrun.SetUIHidden(true)
				Speedrun.Reset()
				Speedrun.HideAdds(true)
				Speedrun:dbg(0, "Score and Time tracking set to: |cffffffOFF|r")
		else
				-- only if tracking was previously off
				if Speedrun.savedSettings.isTracking ~= track then
						Speedrun.Reset()
						Speedrun.ResetUI()
						Speedrun.ResetAnchors()
						Speedrun.OnPlayerActivated()
						Speedrun:dbg(0, "Score and Time tracking set to: |cffffffON|r")
				end

				-- check for changes and react
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Activated", EVENT_PLAYER_ACTIVATED, Speedrun.OnPlayerActivated)

				-- show / hide UI
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Reticle", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.SetUIHidden(Speedrun.isMovable and ((not Speedrun.IsInTrialZone()) or IsReticleHidden())) end)

				-- global trial events
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Started", EVENT_RAID_TRIAL_STARTED, Speedrun.OnTrialStarted)
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Complete", EVENT_RAID_TRIAL_COMPLETE, Speedrun.OnTrialComplete)
				EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Failed", EVENT_RAID_TRIAL_FAILED, Speedrun.OnTrialFailed)

				-- only show inside VH
				if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
						Speedrun.ResetAddsUI()
						Speedrun.UpdateAdds()
						EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "ReticleAdds", EVENT_RETICLE_HIDDEN_UPDATE, function() Speedrun.HideAdds((not Speedrun.IsInTrialZone()) or IsReticleHidden()) end)
				else
						EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "ReticleAdds", EVENT_RETICLE_HIDDEN_UPDATE)
						Speedrun.HideAdds(true)
				end
		end

		-- not sure if this matters, but no need to save it if it's already the same.
		if Speedrun.savedSettings.isTracking ~= track then
				Speedrun.savedSettings.isTracking = track
		end
end

function Speedrun:Initialize()

		-- Populate table for new savedVariables and for resetting trial score variables
		Speedrun:GenerateDefaultScores()

		-- Update or create Saved Variables:

		-- Save settings for each character individually so players don't have to change constantly, in case they raid with multiple groups on a specific char for each.
		Speedrun.savedSettings = ZO_SavedVars:NewCharacterIdSettings("SpeedrunVariables", 2, nil, Speedrun.Default_Character)

		-- Keep tables and recorded data available accountwide
		Speedrun.savedVariables = ZO_SavedVars:NewAccountWide("SpeedrunVariables", 2, nil, Speedrun.Default_Account)

		-- Create "Default" profile and set it as active if doesn't already exist
		if Speedrun.savedVariables.profiles["Default"] == nil or Speedrun.savedVariables.profiles["Default"] == "" then
				Speedrun.savedVariables.profiles["Default"] = {}
				Speedrun.savedVariables.profileVersion = 0
		end

		if Speedrun.savedSettings.activeProfile == nil or Speedrun.savedSettings.activeProfile == "" then
				Speedrun.savedSettings.activeProfile = "Default"
		end

		-- Check if it's the first time player uses this version.
		if Speedrun.savedVariables.profileVersion <= 0 then
				Speedrun.profileToImportTo = "Default"
				-- add previous data if any exists
				Speedrun.ImportVariables()
		end

		ZO_CreateStringId("SI_BINDING_NAME_SR_TOGGLE_HIDEGROUP", "Toggle Hide Group")
		ZO_CreateStringId("SI_BINDING_NAME_SR_CANCEL_CAST", "Cancel Cast")

		-- UI
		Speedrun.ResetUI()
		Speedrun.ResetAnchors()

		-- Load Variables
		-- Saved Character Settings
		Speedrun.activeProfile 							= Speedrun.savedSettings.activeProfile
		Speedrun.debugMode 									= Speedrun.savedSettings.debugMode

		-- Saved Account Variables
		-- Tables
		Speedrun.raidList 									= Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList
		Speedrun.customTimerSteps 					= Speedrun.savedVariables.profiles[Speedrun.activeProfile].customTimerSteps

		-- Trial Variables
		Speedrun.raidID 										= Speedrun.savedVariables.raidID
		Speedrun.Step 											= Speedrun.savedVariables.Step
		Speedrun.segmentTimer 							= Speedrun.savedVariables.segmentTimer
		Speedrun.currentRaidTimer 					= Speedrun.savedVariables.currentRaidTimer
		Speedrun.currentBossName 						= Speedrun.savedVariables.currentBossName
		Speedrun.lastBossName 							= Speedrun.savedVariables.lastBossName
		Speedrun.isBossDead 								= Speedrun.savedVariables.isBossDead
		Speedrun.isComplete 								= Speedrun.savedVariables.isComplete
		Speedrun.scores 										= Speedrun.savedVariables.scores
		Speedrun.totalTime 									= Speedrun.savedVariables.totalTime
		Speedrun.addsOnCR 									= Speedrun.savedVariables.profiles[Speedrun.activeProfile].addsOnCR
		Speedrun.hmOnSS 										= Speedrun.savedVariables.profiles[Speedrun.activeProfile].hmOnSS

		-- To ensure UI will be created
		Speedrun.isUIDrawn 									= false
		Speedrun.savedVariables.isUIDrawn 	= Speedrun.isUIDrawn
		Speedrun.isScoreSet 								= false
		Speedrun.savedVariables.isScoreSet 	= Speedrun.isScoreSet
		Speedrun.isMovable 									= true
		Speedrun.uiIsHidden 								= Speedrun.savedVariables.uiIsHidden
		Speedrun.addsAreHidden 							= Speedrun.savedVariables.addsAreHidden

		-- Saved Data for later use
		Speedrun.finalScore 								= Speedrun.savedVariables.finalScore
		Speedrun.lastScores 								= Speedrun.savedVariables.lastScores
		Speedrun.lastRaidTimer 							= Speedrun.savedVariables.lastRaidTimer
		Speedrun.lastRaidID 								= Speedrun.savedVariables.lastRaidID

		-- /commands
		SLASH_COMMANDS[Speedrun.slash] 			= Speedrun.SlashCommand

		--[[	Possible filter for "PlayerActivated" ?
		-- In case addon is loaded while inside an active or completed trial
		if Speedrun.IsInTrialZone() and Speedrun.raidID == zoneID then
				Speedrun.LoadTrial()
		end
		]]

		-- Setup Menu
		Speedrun.CreateSettingsWindow()

		-- Check settings for tracking and then react accordingly
		Speedrun.Tracking(Speedrun.savedSettings.isTracking)

		-- Hide Group
		if Speedrun.savedSettings.groupHidden == true then
				Speedrun:dbg(0, "Hide Group Set To: ON.\nHiding Group Members.")
		end

		EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "GroupHidden", EVENT_PLAYER_ACTIVATED,
		function()
				if Speedrun.savedSettings.groupHidden then
						Speedrun.HideGroup(Speedrun.savedSettings.groupHidden)
				end
		end) -- For after porting

		EVENT_MANAGER:UnregisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED)
end

function Speedrun.OnAddOnLoaded(event, addonName)
    if addonName ~= Speedrun.name then return end

    Speedrun:Initialize()
end

EVENT_MANAGER:RegisterForEvent(Speedrun.name .. "Loaded", EVENT_ADD_ON_LOADED, Speedrun.OnAddOnLoaded)
