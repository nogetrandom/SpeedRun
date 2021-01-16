Speedrun = Speedrun or {}
local Speedrun = Speedrun

Speedrun.slash      					= "/speed"
Speedrun.prefix     					= "|cffffffSpeed|r|cdf4242Run|r: "
Speedrun.debugMode 						= 0

-- Speedrun.mapName 							= ""
-------------------------
---- Functions    -------
-------------------------
function Speedrun.SlashCommand(command)
    -- Debug Options ----------------------------------------------------------
    if command == "track 0" then
        d(Speedrun.prefix .. "Tracking: Off")
        Speedrun.debugMode = 0
        Speedrun.savedVariables.debugMode = 0
    elseif command == "track 1" then
        d(Speedrun.prefix .. "Tracking: low (only checkpoints)")
        Speedrun.debugMode = 1
        Speedrun.savedVariables.debugMode = 1
		elseif command == "track 2" then
	       d(Speedrun.prefix .. "Tracking: high (all score updates)")
	       Speedrun.debugMode = 2
	       Speedrun.savedVariables.debugMode = 2
		-- Hide Group -------------------------------------------------------------
		elseif command == "hg" or command == "hidegroup" then
				Speedrun.HideGroupToggle()
    -- Adds -------------------------------------------------------------------
		elseif command == "score" then
				Speedrun.PrintScoreReasons()
		-- Default ----------------------------------------------------------------
    else
        d(Speedrun.prefix .. " Command not recognized!\n[ |cffffff/speed|r (|cffffffcommand|r) ] options are:\n[ |cfffffftrack|r |cffffff0|r - |cffffff2|r ] To post selection in chat.\n    [ |cffffff0|r ]: Only settings changes.\n    [ |cffffff1|r ]: Trial Checkpoint Updates.\n    [ |cffffff2|r ]: Every score update (adds included).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat")
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
		Speedrun.HideGroup(not Speedrun.savedVariables.groupHidden)
end

function Speedrun.HideGroup(hide) --copied from HideGroup by Wheels - thanks!
		if hide == true then
				SetCrownCrateNPCVisible(true)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Hiding group members")
						Speedrun.savedVariables.nameplates = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES)
						Speedrun.savedVariables.healthBars = GetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS)
				end
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(NAMEPLATE_CHOICE_NEVER))
				SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(NAMEPLATE_CHOICE_NEVER))
		else
				SetCrownCrateNPCVisible(false)
				if Speedrun.savedVariables.groupHidden ~= hide then
						Speedrun:dbg(0, "Showing group members")
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_NAMEPLATES, tostring(Speedrun.savedVariables.nameplates))
						SetSetting(SETTING_TYPE_NAMEPLATES, NAMEPLATE_TYPE_GROUP_MEMBER_HEALTHBARS, tostring(Speedrun.savedVariables.healthBars))
				end
		end
		Speedrun.savedVariables.groupHidden = hide
end

function Speedrun.PrintScoreReasons()
		Speedrun:dbg(0, "Current Trial Score Points:")
		for k, v in pairs(Speedrun.scores) do
				local score = Speedrun.scores[k]
				-- if score.display == true and score.times > 0 then
				-- 		d('|cdf4242' .. score.name .. ' |r' .. ' x ' .. score.times)
				-- else
				if score ~= 9 then
						if score.times > 0 then
								d('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times .. ' = ' .. score.total .. ' points.')
						end
				elseif score == 9 then
						d('|cdf4242' .. score.name .. '|r' .. ' x ' .. score.times)
				end
		end
end

function Speedrun.BestPossible(raidID)
		local totalTime = 0
		if type(raidID) == "string" then --for vMA
        raidID = tonumber(string.sub(raidID,1,3))
    end
    for i, x in pairs(Speedrun.customTimerSteps[raidID]) do
        if Speedrun.GetSavedTimer(raidID,i) then
            totalTime = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + totalTime
        end
    end
    local vitality
    if raidID == 638 or raidID == 636 or raidID == 639 or raidID == 1082 or raidID == 635 then
        vitality = 24
    elseif raidID == 725 or raidID == 975 or raidID == 1000 or raidID == 1051 or raidID == 1121 or raidID == 1196 then
        vitality = 36
    elseif raidID == 677 or raidID == 1227 then
        vitality = 15
    end
    local score = tostring(math.floor(Speedrun.GetScore(totalTime, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore
    return score
end

function Speedrun.HideXP()
		ZO_PlayerProgress:SetAlpha(0)
		ZO_PlayerProgressBar:SetHidden(true)
		-- ZO_PlayerProgress:ClearAnchors()

		ZO_PlayerProgressBar:SetAlpha(0)
		ZO_PlayerProgressBar_Gamepad:SetAlpha(0)
		ZO_PlayerProgressBarBG:SetAlpha(0)
		ZO_PlayerProgressBarBGLeft:SetAlpha(0)
		ZO_PlayerProgressBarBGMiddle:SetAlpha(0)
		ZO_PlayerProgressBarBGRight:SetAlpha(0)
		ZO_PlayerProgressBarGloss:SetAlpha(0)
		ZO_PlayerProgressBarGlowContainer:SetAlpha(0)
		ZO_PlayerProgressBarGlowContainerCenter:SetAlpha(0)
		ZO_PlayerProgressBarGlowContainerLeft:SetAlpha(0)
		ZO_PlayerProgressBarGlowContainerRight:SetAlpha(0)
		ZO_PlayerProgressBarOverlay:SetAlpha(0)
		ZO_PlayerProgressBarOverlayLeft:SetAlpha(0)
		ZO_PlayerProgressBarOverlayMiddle:SetAlpha(0)
		ZO_PlayerProgressBarOverlayRight:SetAlpha(0)
		ZO_PlayerProgressLevel:SetAlpha(0)
		ZO_PlayerProgressLevelType:SetAlpha(0)
		ZO_PlayerProgressLevelTypeIcon:SetAlpha(0)

		ZO_PlayerProgressBar:SetHidden(true)
		ZO_PlayerProgressBar_Gamepad:SetHidden(true)
		ZO_PlayerProgressBarBG:SetHidden(true)
		ZO_PlayerProgressBarBGLeft:SetHidden(true)
		ZO_PlayerProgressBarBGMiddle:SetHidden(true)
		ZO_PlayerProgressBarBGRight:SetHidden(true)
		ZO_PlayerProgressBarGloss:SetHidden(true)
		ZO_PlayerProgressBarGlowContainer:SetHidden(true)
		ZO_PlayerProgressBarGlowContainerCenter:SetHidden(true)
		ZO_PlayerProgressBarGlowContainerLeft:SetHidden(true)
		ZO_PlayerProgressBarGlowContainerRight:SetHidden(true)
		ZO_PlayerProgressBarOverlay:SetHidden(true)
		ZO_PlayerProgressBarOverlayLeft:SetHidden(true)
		ZO_PlayerProgressBarOverlayMiddle:SetHidden(true)
		ZO_PlayerProgressBarOverlayRight:SetHidden(true)
		ZO_PlayerProgressLevel:SetHidden(true)
		ZO_PlayerProgressLevelType:SetHidden(true)
		ZO_PlayerProgressLevelTypeIcon:SetHidden(true)

		-- ZO_PlayerProgressBar:ClearAnchors()
		-- ZO_PlayerProgressBar_Gamepad:ClearAnchors()
		-- ZO_PlayerProgressBarBG:ClearAnchors()
		-- ZO_PlayerProgressBarBGLeft:ClearAnchors()
		-- ZO_PlayerProgressBarBGMiddle:ClearAnchors()
		-- ZO_PlayerProgressBarBGRight:ClearAnchors()
		-- ZO_PlayerProgressBarGloss:ClearAnchors()
		-- ZO_PlayerProgressBarGlowContainer:ClearAnchors()
		-- ZO_PlayerProgressBarGlowContainerCenter:ClearAnchors()
		-- ZO_PlayerProgressBarGlowContainerLeft:ClearAnchors()
		-- ZO_PlayerProgressBarGlowContainerRight:ClearAnchors()
		-- ZO_PlayerProgressBarOverlay:ClearAnchors()
		-- ZO_PlayerProgressBarOverlayLeft:ClearAnchors()
		-- ZO_PlayerProgressBarOverlayMiddle:ClearAnchors()
		-- ZO_PlayerProgressBarOverlayRight:ClearAnchors()
		-- ZO_PlayerProgressLevel:ClearAnchors()
		-- ZO_PlayerProgressLevelType:ClearAnchors()
		-- ZO_PlayerProgressLevelTypeIcon:ClearAnchors()

		-- ZO_ChampionBG:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionBGLeft:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionBGMiddle:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionBGRight:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionOverlay:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionOverlayLeft:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionOverlayMiddle:SetAlpha(0)
		-- ZO_PlayerProgressBarChampionOverlayRight:SetAlpha(0)
		--
		-- ZO_PlayerProgressBarChampionBG:SetHidden(true)
		-- ZO_PlayerProgressBarChampionBGLeft:SetHidden(true)
		-- ZO_PlayerProgressBarChampionBGMiddle:SetHidden(true)
		-- ZO_PlayerProgressBarChampionBGRight:SetHidden(true)
		-- ZO_PlayerProgressBarChampionOverlay:SetHidden(true)
		-- ZO_PlayerProgressBarChampionOverlayLeft:SetHidden(true)
		-- ZO_PlayerProgressBarChampionOverlayMiddle:SetHidden(true)
		-- ZO_PlayerProgressBarChampionOverlayRight:SetHidden(true)
		--
		-- ZO_PlayerProgressBarChampionBG:ClearAnchors()
		-- ZO_PlayerProgressBarChampionBGLeft:ClearAnchors()
		-- ZO_PlayerProgressBarChampionBGMiddle:ClearAnchors()
		-- ZO_PlayerProgressBarChampionBGRight:ClearAnchors()
		-- ZO_PlayerProgressBarChampionOverlay:ClearAnchors()
		-- ZO_PlayerProgressBarChampionOverlayLeft:ClearAnchors()
		-- ZO_PlayerProgressBarChampionOverlayMiddle:ClearAnchors()
		-- ZO_PlayerProgressBarChampionOverlayRight:ClearAnchors()

end
