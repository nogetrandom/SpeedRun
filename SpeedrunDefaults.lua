Speedrun = Speedrun or {}
local Speedrun = Speedrun
---------------------------
---- Variables Default ----
---------------------------
Speedrun.Default = {
    --table
    customTimerSteps = {},
    raidList = {},
		scores = {},

	  --UI
		finalScore = 0,
    segmentTimer = {},
    speedrun_container_OffsetX = 500,
    speedrun_container_OffsetY = 500,
    isMovable = true,
    uiIsHidden = true,
		addsAreHidden = true,

		--variables
    currentRaidTimer = {},
    lastBossName = "",
		currentBossName = "",
    raidID = 0,
    isBossDead = true,
    Step = 1,
    stage = 0,

    --settings
    addsOnCR = true,
    hmOnSS = 4,
		debugMode = 0,
		nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES),
		healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS),
		groupHidden = false,

		mapName = "",
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
						display = Speedrun.scoreReasonList[k].display,
						type = Speedrun.scoreReasonList[k].type,
        }
    end
end

function Speedrun.GetDefaultScores()
		Speedrun:GenerateDefaultScores()
		return Speedrun.Default.scores
end
