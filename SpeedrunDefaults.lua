Speedrun = Speedrun or {}
local Speedrun = Speedrun
---------------------------
---- Variables Default ----
---------------------------
--account wide
Speedrun.Default = {
		--to check if "Default" profile has been updated
		profileVersion							= 0,
    --table
		scores 											= {},
		lastScores 									= {},
		profiles										= {},

		--UI
    speedrun_container_OffsetX 	= 500,
    speedrun_container_OffsetY 	= 500,
    isMovable 									= true,
    uiIsHidden 									= true,
		addsAreHidden 							= true,

		--trial variables
		currentRaidTimer 						= {},
		lastRaidTimer 							= {},
		lastBossName 								= "",
		currentBossName 						= "",
		raidID 											= 0,
		lastRaidID	 								= 0,
		Step 												= 1,
		isBossDead 									= true,
		isComplete									= false,
		totalTime										= 10,
		finalScore									= 0,

		--UI
		isUIDrawn										= false,
		isScoreSet									= false,
		segmentTimer 								= {},

		--settings
		debugMode 									= 0,
		isTracking 									= true,

		--hide group
		groupHidden 								= false,
		nameplates 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		healthBars 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
}

-- Profile Preset
local defaultProfile = {
		--table
		raidList 										= {},
		customTimerSteps 						= {},
		--settings
		addsOnCR 										= true,
		hmOnSS 											= 4,
}

local defaultScoreFactors = {
		vitality = 0,
		bestTime = nil,
		bestScore = 0,
		scoreReasons = {},
}
-------------------
---- Functions ----
-------------------
function Speedrun:GenerateDefaultScores()
		Speedrun.Default.scores = {}
    for k, v in pairs(Speedrun.scoreReasonList) do
        -- Populate List
        Speedrun.Default.scores[k] = {
						name = Speedrun.scoreReasonList[k].name,
						id = Speedrun.scoreReasonList[k].id,
						times = 0,
						total = 0,
        }
    end
end

function Speedrun.GetDefaultScores()
		Speedrun:GenerateDefaultScores()
		return Speedrun.Default.scores
end

function Speedrun.GetDefaultProfile()
		defaultProfile.raidList = Speedrun.defaultRaidList
		defaultProfile.customTimerSteps = Speedrun.defaultCustomTimerSteps
		return defaultProfile
end

function Speedrun.GetDefaultRaidList()
		return Speedrun.defaultRaidList
end

function Speedrun.GetDefaultCustomTimerSteps()
		return Speedrun.defaultCustomTimerSteps
end

function Speedrun.UpdateVariables()
		local sV = Speedrun.savedVariables
		if (sV.raidList == nil and sV.customTimerSteps == nil) then Speedrun.savedVariables.profiles["Default"] = Speedrun.GetDefaultProfile() return end

		local savedData = {
				raidList 					= {},
				customTimerSteps	= {},
				addsOnCR 					= true,
				hmOnSS 						= 4,
		}
		local raidListData = sV.raidList ~= nil and true or false
		local customTimerStepsData = sV.customTimerSteps ~= nil and true or false
		local addsOnCRData = sV.addsOnCR ~= nil and true or false
		local hmOnSSData = sV.hmOnSS ~= nil and true or false

		if raidListData == true then
				for k, v in pairs(sV.raidList) do
						local trial = sV.raidList[k]

						if trial then
								trial.scoreFactors = defaultScoreFactors
								savedData.raidList[k] = trial
						end
				end
		else
				savedData.raidList = Speedrun.GetDefaultRaidList()
		end

		if customTimerStepsData == true then
				for k, v in pairs(sV.customTimerSteps) do
						local raid = sV.customTimerSteps[k]

						if raid then
								savedData.customTimerSteps[k] = raid
						end
				end
		else
				savedData.customTimerSteps = Speedrun.GetDefaultCustomTimerSteps()
		end

		if addsOnCRData == true then
				savedData.addsOnCR = sV.addsOnCR
		end

		if hmOnSSData == true then
				savedData.hmOnSS = sV.hmOnSS
		end

		Speedrun.savedVariables.profiles["Default"].raidList = savedData.raidList
		Speedrun.savedVariables.profiles["Default"].customTimerSteps = savedData.customTimerSteps
		Speedrun.savedVariables.profiles["Default"].addsOnCR = savedData.addsOnCR
		Speedrun.savedVariables.profiles["Default"].hmOnSS = savedData.hmOnSS

		Speedrun.savedVariables.profileVersion = 1
end

-- -- maybe needed later.
-- function Speedrun.VerifyProfiles()
-- 		local sV = Speedrun.savedVariables
--
-- 		for profile, v in pairs(sV.profiles) do
-- 				if sV.profiles[profile].raidList == nil or sV.profiles[profile].raidList == {} then
-- 						sV.profiles[profile].raidList = defaultProfile.raidList
-- 				end
--
-- 				if sV.profiles[profile].customTimerSteps == nil or sV.profiles[profile].customTimerSteps == {} then
-- 						sV.profiles[profile].customTimerSteps = defaultProfile.customTimerSteps
-- 				end
--
-- 				if sV.profiles[profile].addsOnCR == nil then
-- 						sV.profiles[profile].addsOnCR = true
-- 				end
--
-- 				if sV.profiles[profile].hmOnSS == nil then
-- 						sV.profiles[profile].hmOnSS = 4
-- 				end
-- 		end
-- end
