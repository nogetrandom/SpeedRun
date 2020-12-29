Speedrun = Speedrun or { }
local Speedrun = Speedrun

-------------------
---- Raid List ----
-------------------
Speedrun.raidList = {
    [638] = {
        name = "AA",
        id = 638,
        timerSteps = {},
    },
    [636] = {
        name = "HRC",
        id = 636,
        timerSteps = {},
    },
    [639] = {
        name = "SO",
        id = 639,
        timerSteps = {},
    },
    [725] = {
        name = "MoL",
        id = 725,
        timerSteps = {},
    },
    [975] = {
        name = "HoF",
        id = 975,
        timerSteps = {},
    },
    [1000] = {
        name = "AS",
        id = 1000,
        timerSteps = {},
    },
    [1051] = {
        name = "CR",
        id = 1051,
        timerSteps = {},
    },
    [1121] = {
        name = "SS",
        id = 1121,
        timerSteps = {},
    },
    [1196] = {
        name = "KA",
        id = 1196,
        timerSteps = {},
    },
    [1082] = {
        name = "BRP",
        id = 1082,
        timerSteps = {},
    },
    [677] = {
        name = "MA",
        id = 677,
        timerSteps = {},
    },
    [635] = {
        name = "DSA",
        id = 635,
        timerSteps = {},
    },
		[1227] = {
				name = "VH",
				id = 1227,
				timerSteps = {},
		},
}

-----------------------
---- Custom Timers ----
-----------------------
Speedrun.customTimerSteps = {
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
				-- [1] = {
				-- 		["Blue 1"] = "",
				-- 		["Red 1"] = "",
				-- 		["Green 1"] = "",
				-- }, -- "",
        -- [2] = {
				-- 		["Blue 2"] = "",
				-- 		["Red 2"] = "",
				-- 		["Green 2"] = "",
				-- }, -- "",
        -- [3] = {
				-- 		["Blue 3"] = "",
				-- 		["Red 3"] = "",
				-- 		["Green 3"] = "",
				-- }, -- "",
        -- [4] = "",
        -- [5] = "",
        -- [6] = "",
        -- [7] = "",
        -- [8] = "",
    },
}

-- Speedrun.customArenaTimers = {
-- 		stageList = {
--				[1082] = { --BRP
-- 						[1] = "",
-- 						[2] = "",
-- 						[3] = "",
-- 						[4] = "",
-- 						[5] = ""
--				},
--				[677] = { --MA
-- 						[1] = "",
-- 						[2] = "",
-- 						[3] = "",
-- 						[4] = "",
-- 						[5] = "",
-- 						[6] = "",
-- 						[7] = "",
-- 						[8] = "",
-- 						[9] = ""
--				},
-- 		},
-- 		roundList = {
--				[1082] = { --BRP
-- 						[1] = "",
-- 						[2] = "",
-- 						[3] = "",
-- 						[4] = "",
-- 						[5] = "",
-- 						[6] = "",
-- 						[7] = "",
-- 						[8] = "",
-- 						[9] = "",
-- 						[10] = "",
-- 						[11] = "",
-- 						[12] = "",
-- 						[13] = "",
-- 						[14] = "",
-- 						[15] = "",
-- 						[16] = "",
-- 						[17] = "",
-- 						[18] = "",
-- 						[19] = "",
-- 						[20] = "",
-- 						[21] = "",
-- 						[22] = "",
-- 						[23] = "",
-- 						[24] = "",
-- 						[25] = ""
-- 				},
--				[677] = { --MA
-- 						[1] = "",
-- 						[2] = "",
-- 						[3] = "",
-- 						[4] = "",
-- 						[5] = "",
-- 						[6] = "",
-- 						[7] = "",
-- 						[8] = "",
-- 						[9] = "",
-- 						[10] = ""
--				},
-- 		},
-- }

-------------------
---- Step List ----
-------------------
Speedrun.stepList = {
    [638] = { --AA
        [1] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_LIGHTNING),
        [2] = zo_strformat(SI_SPEEDRUN_AA_FINISH_LIGHTNING),
        [3] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_STONE),
        [4] = zo_strformat(SI_SPEEDRUN_AA_FINISH_STONE),
        [5] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_VARLARIEL),
        [6] = zo_strformat(SI_SPEEDRUN_AA_FINISH_VARLARIEL),
        [7] = zo_strformat(SI_SPEEDRUN_AA_BEGIN_MAGE),
        [8] = zo_strformat(SI_SPEEDRUN_AA_FINISH_MAGE),
    },
    [636] = { --HRC
        [1] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_RAKOTU),
        [2] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_RAKOTU),
        [3] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_SECOND),
        [4] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_SECOND),
        [5] = zo_strformat(SI_SPEEDRUN_HRC_BEGIN_WARRIOR),
        [6] = zo_strformat(SI_SPEEDRUN_HRC_FINISH_WARRIOR),
    },
    [639] = { --SO
        [1] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_MANTIKORA),
        [2] = zo_strformat(SI_SPEEDRUN_SO_FINISH_MANTIKORA),
        [3] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_TROLL),
        [4] = zo_strformat(SI_SPEEDRUN_SO_FINISH_TROLL),
        [5] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_OZARA),
        [6] = zo_strformat(SI_SPEEDRUN_SO_FINISH_OZARA),
        [7] = zo_strformat(SI_SPEEDRUN_SO_BEGIN_SERPENT),
        [8] = zo_strformat(SI_SPEEDRUN_SO_FINISH_SERPENT),
    },
    [725] = { --MoL
        [1] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_ZHAJ),
        [2] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_ZHAJ),
        [3] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_TWINS),
        [4] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_TWINS),
        [5] = zo_strformat(SI_SPEEDRUN_MOL_BEGIN_RAKKHAT),
        [6] = zo_strformat(SI_SPEEDRUN_MOL_FINISH_RAKKHAT),
    },
    [975] = { --HoF
        [1] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_DYNO),
        [2] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_DYNO),
        [3] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_FACTOTUM),
        [4] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_FACTOTUM),
        [5] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_SPIDER),
        [6] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_SPIDER),
        [7] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_COMMITEE),
        [8] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_COMMITEE),
        [9] = zo_strformat(SI_SPEEDRUN_HOF_BEGIN_ASSEMBLY),
        [10] = zo_strformat(SI_SPEEDRUN_HOF_FINISH_ASSEMBLY),
    },
    [1000] = { --AS
        [1] = zo_strformat(SI_SPEEDRUN_AS_BEGIN_OLMS),
        [2] = zo_strformat(SI_SPEEDRUN_AS_90_PERCENT),
        [3] = zo_strformat(SI_SPEEDRUN_AS_75_PERCENT),
        [4] = zo_strformat(SI_SPEEDRUN_AS_50_PERCENT),
        [5] = zo_strformat(SI_SPEEDRUN_AS_25_PERCENT),
        [6] = zo_strformat(SI_SPEEDRUN_AS_KILL_OLMS),
    },
    [1051] = { --CR
        [1] = zo_strformat(SI_SPEEDRUN_CR_BEGIN_ZMAJA),
        [2] = zo_strformat(SI_SPEEDRUN_CR_SIRORIA_APPEAR),
        [3] = zo_strformat(SI_SPEEDRUN_CR_RELEQUEN_APPEAR),
        [4] = zo_strformat(SI_SPEEDRUN_CR_GALENWE_APPEAR),
        [5] = zo_strformat(SI_SPEEDRUN_CR_SHADOW_APPEAR),
        [6] = zo_strformat(SI_SPEEDRUN_CR_KILL_SHADOW),
    },
    [1121] = { --SS
        [1] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_SS_KILL_FIRST),
        [3] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_SECOND),
        [4] = zo_strformat(SI_SPEEDRUN_SS_KILL_SECOND),
        [5] = zo_strformat(SI_SPEEDRUN_SS_BEGIN_LAST),
        [6] = zo_strformat(SI_SPEEDRUN_SS_KILL_LAST),
    },
    [1196] = { --KA
        [1] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_YANDIR),
        [2] = zo_strformat(SI_SPEEDRUN_KA_KILL_YANDIR),
        [3] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_VROL),
        [4] = zo_strformat(SI_SPEEDRUN_KA_KILL_VROL),
        [5] = zo_strformat(SI_SPEEDRUN_KA_BEGIN_FALGRAVN),
        [6] = zo_strformat(SI_SPEEDRUN_KA_KILL_FALGRAVN),
        -- [7] = "",
    },
    [1082] = { --BRP
				-- [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
				-- [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
				-- [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
				-- [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
				-- [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
				-- [6] = zo_strformat(SI_SPEEDRUN_ARENA_COMPLETE),

        [1] = "1.1",
        [2] = "1.2",
        [3] = "1.3",
        [4] = "1.4",
        [5] = "1st Complete",
        [6] = "2.1",
				[7] = "2.2",
        [8] = "2.3",
        [9] = "2.4",
        [10] = "2nd Complete",
        [11] = "3.1",
        [12] = "3.2",
				[13] = "3.3",
        [14] = "3.4",
        [15] = "3rd Complete",
        [16] = "4.1",
        [17] = "4.2",
        [18] = "4.3",
				[19] = "4.4",
        [20] = "4th Complete",
        [21] = "5.1",
        [22] = "5.2",
        [23] = "5.3",
        [24] = "5.4",
				[25] = "5th Complete", --"Final Boss",
    },
    [677] = { --MA
        [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
        [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
        [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
        [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
        [6] = zo_strformat(SI_SPEEDRUN_ARENA_SIXTH),
        [7] = zo_strformat(SI_SPEEDRUN_ARENA_SEVENTH),
        [8] = zo_strformat(SI_SPEEDRUN_ARENA_EIGHTH),
				[9] = zo_strformat(SI_SPEEDRUN_ARENA_NINTH),	--zo_strformat(SI_SPEEDRUN_ARENA_COMPLETE),
    },
    [635] = { --DSA
        [1] = zo_strformat(SI_SPEEDRUN_ARENA_FIRST),
        [2] = zo_strformat(SI_SPEEDRUN_ARENA_SECOND),
        [3] = zo_strformat(SI_SPEEDRUN_ARENA_THIRD),
        [4] = zo_strformat(SI_SPEEDRUN_ARENA_FOURTH),
        [5] = zo_strformat(SI_SPEEDRUN_ARENA_FIFTH),
        [6] = zo_strformat(SI_SPEEDRUN_ARENA_SIXTH),
        [7] = zo_strformat(SI_SPEEDRUN_ARENA_SEVENTH),
        [8] = zo_strformat(SI_SPEEDRUN_ARENA_EIGHTH),
        [9] = zo_strformat(SI_SPEEDRUN_ARENA_NINTH),
        [10] = zo_strformat(SI_SPEEDRUN_ARENA_TENTH),
				-- [11] = zo_strformat(SI_SPEEDRUN_ARENA_COMPLETE),
    },
		[1227] = { --Vateshran Hollows
        [1] = "Boss 1", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        [2] = "Boss 2", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        [3] = "Boss 3", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        [4] = "Boss 4", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        [5] = "Boss 5", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        [6] = "Boss 6", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
				[7] = "Maebroogha |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
				-- [8] = "Last Boss Dead",
				-- [1] = "Portal 1", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        -- [2] = "Portal 2", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
        -- [3] = "Portal 3", -- |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
				-- [4] = "Maebroogha |t20:20:esoui\\art\\icons\\poi\\poi_groupboss_incomplete.dds|t",
		},
}

Speedrun.scoreReasons = {
		[0] = {
				name = "No Bonus",
				id = RAID_POINT_REASON_MIN_VALUE,
				times = 0,
				-- total = 0,
		},
		[1] = {
				name = "Small adds:",
				id = RAID_POINT_REASON_KILL_NORMAL_MONSTER,
				times = 0,
				-- total = 0,
		},
		[2] = {
				name = "Large adds:",
				id = RAID_POINT_REASON_KILL_BANNERMEN,
				times = 0,
				-- total = 0,
		},
		[3] = {
				name = "Elite adds:",
				id = RAID_POINT_REASON_KILL_CHAMPION,
				times = 0,
				-- total = 0,
		},
		[4] = {
				name = "Miniboss",
				id = RAID_POINT_REASON_KILL_MINIBOSS,
				times = 0,
				-- total = 0,
		},
		[5] = {
				name = "Boss",
				id = RAID_POINT_REASON_KILL_BOSS,
				times = 0,
				-- total = 0,
		},
		[6] = {
				name = "Activity Bonus Low",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_LOW,
				times = 0,
				-- total = 0,
		},
		[7] = {
				name = "Activity Bonus Medium",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM,
				times = 0,
				-- total = 0,
		},
		[8] = {
				name = "Activity Bonus High",
				id = RAID_POINT_REASON_BONUS_ACTIVITY_HIGH,
				times = 0,
				-- total = 0,
		},
		[9] = {
				name = "Resurrections",
				id = RAID_POINT_REASON_LIFE_REMAINING,
				times = 0,
				-- total = 0,
		},
		[10] = {
				name = "Bonus Point One",
				id = RAID_POINT_REASON_BONUS_POINT_ONE,
				times = 0,
				-- total = 0,
		},
		[11] = {
				name = "Bonus Point Two",
				id = RAID_POINT_REASON_BONUS_POINT_TWO,
				times = 0,
				-- total = 0,
		},
		[12] = {
				name = "Bonus Point Three",
				id = RAID_POINT_REASON_BONUS_POINT_THREE,
				times = 0,
				-- total = 0,
		},
		[13] = {
				name = "Sigil Bonus x1",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_ONE,
				times = 0,
				-- total = 0,
		},
		[14] = {
				name = "Sigil Bonus x2",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_TWO,
				times = 0,
				-- total = 0,
		},
		[15] = {
				name = "Sigil Bonus x3",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_THREE,
				times = 0,
				-- total = 0,
		},
		[16] = {
				name = "Sigil Bonus x4",
				id = RAID_POINT_REASON_SOLO_ARENA_PICKUP_FOUR,
				times = 0,
				-- total = 0,
		},
		[17] = {
				name = "Max Value / Boss",
				id = RAID_POINT_REASON_MAX_VALUE,
				times = 0,
				-- total = 0,
		},
}

-- function Speedrun.MainBRP() --copied from BRHelper thx @andy.s
--     local x, y = GetMapPlayerPosition("player");
--     local stage
--     if IsUnitInCombat("player") and x > 0.54 and x < 0.64 and y > 0.79 and y < 0.89 then
--         stage = 1
--     elseif x > 0.3 and x < 0.4 and y > 0.69 and y < 0.8 then
--         stage = 2
--     elseif x > 0.41 and x < 0.52 and y > 0.43 and y < 0.53 then
--         stage = 3
--     elseif x > 0.63 and x < 0.73 and y > 0.22 and y < 0.32 then
--         stage = 4
--     elseif x > 0.4 and x < 0.5 and y > 0.08 and y < 0.18 then
--         stage = 5
--     else
--         stage = 0
--     end
--     if Speedrun.stage == stage - 1 then
--         Speedrun.stage = stage
--         Speedrun.savedVariables.stage = Speedrun.stage
--         Speedrun.UpdateWaypointNew(GetRaidDuration())
--     end
-- end

-- Speedrun.BossDead = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
--     if Speedrun.raidID == 635 then
--         if scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM then
--             Speedrun.UpdateWaypointNew(GetRaidDuration())
--         elseif scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_LOW  then
--             d("Need To Trigger on Low: " .. scoreUpdateReason)
--         elseif scoreUpdateReason == RAID_POINT_REASON_BONUS_ACTIVITY_HIGH  then
--             d("Need To Trigger on High: " .. scoreUpdateReason)
--         end
--         return
--     end
-- 		if Speedrun.raidID == 635 then
-- 				if scoreUpdateReason == RAID_POINT_REASON_KILL_BOSS then
--     				--finish arena
--        			Speedrun.UpdateWaypointNew(GetRaidDuration())
--        			Speedrun.isBossDead = true
--        			Speedrun.savedVariables.isBossDead = Speedrun.isBossDead
-- 				end
--     end
-- end


-- Speedrun.MainVH = function(eventCode, scoreUpdateReason, scoreAmount, totalScore)
-- 		local reasons = {}
-- 		local scoreTime = GetRaidDuration()
-- 		if Speedrun.Step <= 7 then
-- 				reasons[scoreTime[scoreUpdateReason]] = (scoreUpdateReason == 13 or scoreUpdateReason == 14 or scoreUpdateReason == 15 or scoreUpdateReason == 16 or scoreUpdateReason == RAID_POINT_REASON_MIN_VALUE)	--scoreUpdateReason == 5 then
-- 				for k, v in pairs(reasons) do
-- 						if
-- 						Speedrun.UpdateWaypointNew(GetRaidDuration())
-- 		end
-- end
----------------------------------------------------------------------------------------------

-- function Speedrun.SetScoreReasons(k, v)
-- 		Speedrun.scoreReasons[k].times = Speedrun.scoreReasons[k].times + 1
-- 		Speedrun.savedVariables.scoreReasons[k].times = Speedrun.scoreReasons[k].times
-- 		Speedrun.scoreReasons[k].total = Speedrun.scoreReasons[k].total + v
-- 		Speedrun.savedVariables.scoreReasons[k].total = Speedrun.scoreReasons[k].total
-- end
--
-- function Speedrun.GetScoreReasons()
-- 		for reason, times in pairs(Speedrun.scoreReasons) do
-- 				local reason = Speedrun.scoreReasons[reason]
-- 				if reason ~= nil then
-- 						local times = Speedrun.scoreReasons[reason].times
-- 						local total = Speedrun.scoreReasons[reason].total
-- 						local name = Speedrun.scoreReasons[reason].name
-- 						if times > 0 then
-- 								Speedrun:dbg(1, '|cdf4242<<1>>|r (<<4>>) x<<2>> = <<3>> total', name, times, total, reason)
-- 						else
-- 								Speedrun:dbg(1, 'No |cdf4242<<1>>|r (<<2>>) registered', name, reason)
-- 						end
-- 				else
-- 						Speedrun:dbg(1, 'Reason <<1>> is nil', reason)
-- 				end
-- 		end
-- end

-- function Speedrun.onScoreChanged(eventCode, scoreUpdateReason, scoreAmount, totalScore)
-- 		Speedrun.scoreUpdateReasons.times[Speedrun.scoreReasons[scoreUpdateReason]] + 1 = scoreUpdateReason == Speedrun.scoreReasons[scoreUpdateReason]
-- 		Speedrun.scoreUpdateReasons.total[Speedrun.scoreReasons[scoreUpdateReason]] + scoreAmount = scoreUpdateReason == Speedrun.scoreReasons[scoreUpdateReason]
-- end

--[[ SCORE UPDATE REASONS

0 	=	{
				RAID_POINT_REASON_MIN_VALUE
				RAID_POINT_REASON_KILL_NOXP_MONSTER
				RAID_POINT_REASON_ITERATION_BEGIN
			}
1		= 	RAID_POINT_REASON_KILL_NORMAL_MONSTER
2		= 	RAID_POINT_REASON_KILL_BANNERMEN
3		=		RAID_POINT_REASON_KILL_CHAMPION
4 	=		RAID_POINT_REASON_KILL_MINIBOSS
5		= 	RAID_POINT_REASON_KILL_BOSS
6		=		RAID_POINT_REASON_BONUS_ACTIVITY_LOW
7		=		RAID_POINT_REASON_BONUS_ACTIVITY_MEDIUM
8		=		RAID_POINT_REASON_BONUS_ACTIVITY_HIGH
9		=		RAID_POINT_REASON_LIFE_REMAINING
10	=		RAID_POINT_REASON_BONUS_POINT_ONE
11	=		RAID_POINT_REASON_BONUS_POINT_TWO
12	=		RAID_POINT_REASON_BONUS_POINT_THREE
13	=		RAID_POINT_REASON_SOLO_ARENA_PICKUP_ONE
14	=		RAID_POINT_REASON_SOLO_ARENA_PICKUP_TWO
15	=		RAID_POINT_REASON_SOLO_ARENA_PICKUP_THREE
16	=		RAID_POINT_REASON_SOLO_ARENA_PICKUP_FOUR
17	=	{
				RAID_POINT_REASON_ITERATION_END
				RAID_POINT_REASON_MAX_VALUE
				RAID_POINT_REASON_SOLO_ARENA_COMPLETE
			}

]]

-- local function PortalStart(text)
-- 		if string.find(text, "Welcome to the Wounding! A playground for Molag Bal's fiends.") then
-- 				local blueStart = GetRaidDuration()/1000
-- 				if string.find(text, "Phew! That last one was a big guy!") then
-- 						local blueEnd = (GetRaidDuration()/1000) - blueStart
--
-- 				end
--
-- 		elseif string.find(text, "Hmm, the Brimstone Den. Sorry about the heat. It doesn't bother me so much due to my being, well, dead.") then
-- 				Speedrun.Portal = redStart
--
-- 		elseif string.find(text, "This death is only temporary!") then
-- 				Speedrun.Portal = redEnd
--
--
--
-- shadow warrior 2
--
-- a way out
