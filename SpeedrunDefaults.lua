Speedrun = Speedrun or {}
local Speedrun = Speedrun
---------------------------
---- Variables Default ----
---------------------------
--account wide
Speedrun.Default_Account = {
    --table
		scores 											= {},
		lastScores 									= {},
		profiles										= {},

		--UI
    speedrun_container_OffsetX 	= 500,
    speedrun_container_OffsetY 	= 500,
		isUIDrawn										= false,
		isScoreSet									= false,
		segmentTimer 								= {},
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

		nameplates 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		healthBars 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
}
-- Character
Speedrun.Default_Character = {
		--settings
		activeProfile								= "",
		debugMode 									= 0,
		isTracking 									= true,
		--hide group
		groupHidden 								= false,
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
---------------------------
---- Default Tables -------
---------------------------
local defaultScoreFactors = {
		vitality = 0,
		bestTime = nil,
		bestScore = 0,
		scoreReasons = {},
}

local defaultRaidList = {
    [638] = {
        name = "AA",
        id = 638,
        timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [636] = {
        name = "HRC",
        id = 636,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [639] = {
        name = "SO",
        id = 639,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [725] = {
        name = "MoL",
        id = 725,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [975] = {
        name = "HoF",
        id = 975,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [1000] = {
        name = "AS",
        id = 1000,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [1051] = {
        name = "CR",
        id = 1051,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [1121] = {
        name = "SS",
        id = 1121,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [1196] = {
        name = "KA",
        id = 1196,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [1082] = {
        name = "BRP",
        id = 1082,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
    [635] = {
        name = "DSA",
        id = 635,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
    },
		[677] = {
				name = "MA",
				id = 677,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
		},
		[1227] = {
				name = "VH",
				id = 1227,
				timerSteps = {},
				scoreFactors = {
						vitality = 0,
						bestTime = nil,
						bestScore = 0,
						scoreReasons = {},
				},
		},
}

local defaultCustomTimerSteps = {
    [638] = { --AA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = ""
    },
    [636] = { --HRC
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [639] = { --SO
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = ""
    },
    [725] = { --MoL
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [975] = { --HoF
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = ""
    },
    [1000] = { --AS
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1051] = { --CR
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1121] = { --SS
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1196] = { --KA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = ""
    },
    [1082] = { --BRP
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
				[7] = "",
        [8] = "",
        [9] = "",
        [10] = "",
        [11] = "",
        [12] = "",
				[13] = "",
        [14] = "",
        [15] = "",
        [16] = "",
        [17] = "",
        [18] = "",
				[19] = "",
        [20] = "",
        [21] = "",
        [22] = "",
        [23] = "",
        [24] = "",
				[25] = ""
    },
    [677] = { --MA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = ""
    },
    [635] = { --DSA
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = ""
    },
		[1227] = { --Vateshran Hollows
				[1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = ""
    },
}

local defaultScores = {
		[0] = {
				name = "No Bonus",
				id = RAID_POINT_REASON_MIN_VALUE,
				times = 0,
				total = 0,
		},
		[1] = {
				name = "Small adds:",
				id = RAID_POINT_REASON_KILL_NORMAL_MONSTER,
				times = 0,
				total = 0,
		},
		[2] = {
				name = "Large adds:",
				id = RAID_POINT_REASON_KILL_BANNERMEN,
				times = 0,
				total = 0,
		},
		[3] = {
				name = "Elite adds:",
				id = RAID_POINT_REASON_KILL_CHAMPION,
				times = 0,
				total = 0,
		},
		[4] = {
				name = "Miniboss",
				id = RAID_POINT_REASON_KILL_MINIBOSS,
				times = 0,
				total = 0,
		},
		[5] = {
				name = "Boss",
				id = RAID_POINT_REASON_KILL_BOSS,
				times = 0,
				total = 0,
		},
		[6] = {
				name = "Bonus Low (increased difficulty)",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_LOW,
				times = 0,
				total = 0,
		},
		[7] = {
				name = "Bonus Medium (increased difficulty)",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM,
				times = 0,
				total = 0,
		},
		[8] = {
				name = "Bonus High (HM)",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_HIGH,
				times = 0,
				total = 0,
		},
		[9] = {
				name = "Revives & Resurrections",
				id = RAID_POINT_REASON_LIFE_REMAINING,
				times = 0,
				total = 0,
		},
		[10] = {
				name = "Bonus Point One",
				id = RAID_POINT_REASON_BONUS_POINT_ONE,
				times = 0,
				total = 0,
		},
		[11] = {
				name = "Bonus Point Two",
				id = RAID_POINT_REASON_BONUS_POINT_TWO,
				times = 0,
				total = 0,
		},
		[12] = {
				name = "Bonus Point Three",
				id = RAID_POINT_REASON_BONUS_POINT_THREE,
				times = 0,
				total = 0,
		},
		[13] = {
				name = "Remaining Sigils Bonus x1",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_ONE,
				times = 0,
				total = 0,
		},
		[14] = {
				name = "Remaining Sigils Bonus x2",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_TWO,
				times = 0,
				total = 0,
		},
		[15] = {
				name = "Remaining Sigils Bonus x3",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_THREE,
				times = 0,
				total = 0,
		},
		[16] = {
				name = "Remaining Sigils Bonus x4",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_FOUR,
				times = 0,
				total = 0,
		},
		[17] = {
				name = "Completion Bonus (Stage / Trial)",
				id = RAID_POINT_REASON_MAX_VALUE,
				times = 0,
				total = 0,
		},
}
-------------------
---- Functions ----
-------------------
function Speedrun:GenerateDefaultScores()
		Speedrun.Default_Account.scores = {}
    for k, v in pairs(defaultScores) do
        -- Populate List
        Speedrun.Default_Account.scores[k] = {
						name = defaultScores[k].name,
						id = defaultScores[k].id,
						times = 0,
						total = 0,
        }
    end
end

function Speedrun.GetDefaultScores()
		Speedrun:GenerateDefaultScores()
		return Speedrun.Default_Account.scores
end

function Speedrun.GetDefaultProfile()
		defaultProfile.raidList = defaultRaidList
		defaultProfile.customTimerSteps = defaultCustomTimerSteps
		return defaultProfile
end

function Speedrun.GetDefaultRaidList()
		return defaultRaidList
end

function Speedrun.GetDefaultCustomTimerSteps()
		return defaultCustomTimerSteps
end

function Speedrun.ImportVariables()
		local profile = Speedrun.profileToImportTo

		if (profile == "" or profile == nil) then return end

		local sV = Speedrun.savedVariables
		if profile == "Default" then
				if (Speedrun.savedVariables.profileVersion < 1 and sV.raidList == nil and sV.customTimerSteps == nil) then
						sV.profiles[Speedrun.profileToImportTo] = Speedrun.GetDefaultProfile()
						return
				end
		else
				if (sV.raidList == nil and sV.customTimerSteps == nil) then
						Speedrun:dbg(0, "No data from old list found! Import aborted.")
						return
				end
		end

		local savedData = defaultProfile

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

		Speedrun.savedVariables.profiles[Speedrun.profileToImportTo].raidList = savedData.raidList
		Speedrun.savedVariables.profiles[Speedrun.profileToImportTo].customTimerSteps = savedData.customTimerSteps
		Speedrun.savedVariables.profiles[Speedrun.profileToImportTo].addsOnCR = savedData.addsOnCR
		Speedrun.savedVariables.profiles[Speedrun.profileToImportTo].hmOnSS = savedData.hmOnSS

		Speedrun.savedVariables.customTimerSteps = nil
		Speedrun.savedVariables.addsOnCR = nil
		Speedrun.savedVariables.hmOnSS = nil

		Speedrun.profileToImportTo = ""

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
