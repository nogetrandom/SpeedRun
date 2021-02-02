Speedrun = Speedrun or {}
local Speedrun = Speedrun
---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
    --table
		scores 											= {},
		lastScores 									= {},
		raidList 										= {},
		customTimerSteps 						= {},
	  --UI
    speedrun_container_OffsetX 	= 500,
    speedrun_container_OffsetY 	= 500,
    isMovable 									= true,
    uiIsHidden 									= true,
		addsAreHidden 							= true,
		--variables
		currentRaidTimer 						= {},
		lastRaidTimer 							= {},
		lastBossName 								= "",
		currentBossName 						= "",
		raidID 											= 0,
		lastRaidID	 								= 0,
		Step 												= 1,
		isBossDead 									= true,
		totalTime										= 0,
		--UI
		segmentTimer 								= {},
    --settings
    addsOnCR 										= true,
    hmOnSS 											= 4,
		debugMode 									= 0,
		groupHidden 								= false,
		nameplates 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		healthBars 									= GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
}

Speedrun.svDefault = {
		--Table
		raidList 										= {},
		customTimerSteps 						= {},
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
