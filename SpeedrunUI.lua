-------------------------
---- Variables    ----
-------------------------
Speedrun = Speedrun or {}
local Speedrun = Speedrun
local WM = GetWindowManager()
local globalTimer
local previousSegment
local currentRaid
local bestPossibleTime
-------------------------
---- Functions       ----
-------------------------
function Speedrun.SaveLoc()
    Speedrun.savedVariables["speedrun_container_OffsetX"] = SpeedRun_Timer_Container:GetLeft()
    Speedrun.savedVariables["speedrun_container_OffsetY"] = SpeedRun_Timer_Container:GetTop()
end

function Speedrun.ResetUI()
    SpeedRun_Timer_Container:SetHeight(0)
    SpeedRun_TotalTimer_Title:SetText(" ")
    SpeedRun_Vitality_Label:SetText("  ")
    SpeedRun_Advanced_PreviousSegment:SetText(" ")
    SpeedRun_Advanced_PreviousSegment:SetColor(unpack { 1, 1, 1 })
    SpeedRun_Advanced_BestPossible_Value:SetText(" ")
    SpeedRun_Score_Label:SetText(" ")

    if Speedrun.segments then
        for i,x in ipairs(Speedrun.segments) do
            local name = WM:GetControlByName(x:GetName())
            x:SetHidden(true)
            name:GetNamedChild("_Name"):SetText(" ")
            name:GetNamedChild("_Best"):SetText(" ")
            name:GetNamedChild("_Diff"):SetText(" ")
        end
    end
end

function Speedrun.ResetAnchors()
    SpeedRun_Timer_Container:ClearAnchors()
    SpeedRun_Timer_Container:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Speedrun.savedVariables["speedrun_container_OffsetX"], Speedrun.savedVariables["speedrun_container_OffsetY"])
end

function Speedrun.ToggleMovable()
    local self = Speedrun
    if not Speedrun.isMovable then
        SpeedRun_Timer_Container:SetMovable(true)

        Speedrun.SetUIHidden(false)
				Speedrun.HideAdds(false)
    else
        SpeedRun_Timer_Container:SetMovable(false)

        Speedrun.SetUIHidden(true)
				Speedrun.HideAdds(true)
    end
end

function Speedrun.SetUIHidden(hide)
    SpeedRun_Timer_Container:SetHidden(hide)
    SpeedRun_TotalTimer_Title:SetHidden(hide)
    SpeedRun_Vitality_Label:SetHidden(hide)
    SpeedRun_Score_Label:SetHidden(hide)
    SpeedRun_Advanced:SetHidden(hide)
end

function Speedrun.SetUIHidden(hide)
    if Speedrun.savedVariables.uiIsHidden == true then
        SpeedRun_Timer_Container:SetHidden(hide)
        SpeedRun_TotalTimer_Title:SetHidden(hide)
        SpeedRun_Vitality_Label:SetHidden(hide)
        SpeedRun_Score_Label:SetHidden(hide)
        SpeedRun_Advanced:SetHidden(hide)
    end
end

function Speedrun.UpdateGlobalTimer()
    SpeedRun_TotalTimer_Title:SetText(Speedrun.FormatRaidTimer(GetRaidDuration(), true))

    if (bestPossibleTime == nil or Speedrun.segmentTimer[Speedrun.Step] == Speedrun.segmentTimer[Speedrun.Step + 1]) then
        Speedrun.UpdateCurrentScore()
    end
end

function Speedrun.UpdateCurrentVitality()
    mVitality = GetCurrentRaidStartingReviveCounters()
    cVitality = GetRaidReviveCountersRemaining()
    if not mVitality then return end

    SpeedRun_Vitality_Label:SetText(cVitality .. " / " .. mVitality)

    if (cVitality == mVitality) then
       SpeedRun_Vitality_Label:SetColor(0, 1, 0, 1)
    elseif (cVitality > 0) then
  	   SpeedRun_Vitality_Label:SetColor(1, 1, 1, 1)
    else
       SpeedRun_Vitality_Label:SetColor(1, 0, 0, 1)
    end
end

function Speedrun.UpdateCurrentScore()
    local timer
    if bestPossibleTime then
        if Speedrun.segmentTimer[Speedrun.Step] == Speedrun.segmentTimer[Speedrun.Step + 1] or Speedrun.segmentTimer[Speedrun.Step + 1] == nil  then
            timer = GetRaidDuration()/1000
        else
            timer = bestPossibleTime/1000
        end
    else
        timer = GetRaidDuration()/1000
    end

    local score
    if  IsRaidInProgress() then
        score = math.floor(Speedrun.GetScore(timer+0.1,GetCurrentRaidLifeScoreBonus()/1000,Speedrun.raidID))
        SpeedRun_Score_Label:SetText(Speedrun.FormatRaidScore(score))
    end
end

function Speedrun.UpdateWindowPanel(waypoint, raid)
    waypoint = waypoint or 1
    raid = raid or nil
    if waypoint and raid then
        Speedrun.UpdateSegment(waypoint, raid)
    end
    Speedrun.UpdateGlobalTimer()
end

function Speedrun.CreateRaidSegment(id)
    --Reset segment control
    Speedrun.segmentTimer = {}

    local formatID = id
    if type(formatID) == "string" then --for vMA
        formatID = tonumber(string.sub(formatID,1,3))
        if Speedrun.raidList[id] == nil then
            Speedrun.raidList[id] = Speedrun.raidList[formatID]
            Speedrun.raidList[id].timerSteps = {}
            Speedrun.savedVariables.raidList = Speedrun.raidList
        end
    end

    local raid = Speedrun.raidList[id]
    SpeedRun_Timer_Container_Raid:SetText("|ce6b800" .. zo_strformat(SI_ZONE_NAME, GetZoneNameById(formatID)).. "|r")
    -- SpeedRun_Timer_Container_Raid:SetColor("#e6b800")

    for i, x in ipairs(Speedrun.stepList[formatID]) do

        local segmentRow
        if WM:GetControlByName("SpeedRun_Segment", i) then
            segmentRow = WM:GetControlByName("SpeedRun_Segment", i)
        else
            segmentRow = WM:CreateControlFromVirtual("SpeedRun_Segment", SpeedRun_Timer_Container, "SpeedRun_Segment", i)
        end
        segmentRow:GetNamedChild('_Name'):SetText(x);

        if Speedrun.GetSavedTimer(raid.id, i) then
            if i == 1 then
                Speedrun.segmentTimer[i] = Speedrun.GetSavedTimer(raid.id, i)
            else
                Speedrun.segmentTimer[i] = Speedrun.GetSavedTimer(raid.id, i) + Speedrun.segmentTimer[i - 1]
            end
            segmentRow:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(Speedrun.segmentTimer[i], true))

            bestPossibleTime = Speedrun.segmentTimer[i]
            SpeedRun_Advanced_BestPossible_Value:SetText(Speedrun.FormatRaidTimer(Speedrun.segmentTimer[i], true))
        else
            if i == 1 then
                Speedrun.segmentTimer[i] = 0
            else
                Speedrun.segmentTimer[i] = 0 + Speedrun.segmentTimer[i - 1]
            end
            segmentRow:GetNamedChild('_Best'):SetText(" ")

            bestPossibleTime = 0
            SpeedRun_Advanced_BestPossible_Value:SetText(" ")
        end

        if i == 1 then
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, 40)
        else
            segmentRow:SetAnchor(TOPLEFT, SpeedRun_Timer_Container, TOPLEFT, 0, (i * 20) + 20)
        end
        segmentRow:SetHidden(false)
        Speedrun.segments[i] = segmentRow;
    end
    Speedrun.SetUIHidden(false)
    SpeedRun_Timer_Container_Title:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
    SpeedRun_Timer_Container_Raid:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		if raid == 1227 and (not Speedrun.savedVariables.addsAreHidden) then
				Speedrun.ResetAddsUI()
				Speedrun.UpdateAdds()
				Speedrun.HideAdds(false)
		end
end

function Speedrun.UpdateSegment(step, raid)
    --TODO Divide into multiple function
    if raid == nil then
        raid = GetZoneId(GetUnitZoneIndex("player"))
    end
    local difference
    if (Speedrun.segmentTimer[step] ~= nil and Speedrun.segmentTimer[step] ~= Speedrun.segmentTimer[step + 1])  then
        difference = Speedrun.currentRaidTimer[step] - Speedrun.segmentTimer[step]
    else
        difference = 0
    end

    --TODO correct previousSegementDif
    local previousSegementDif
    if Speedrun.GetSavedTimer(raid.id, step) and step > 1 then
        previousSegementDif = Speedrun.currentRaidTimer[step] - Speedrun.currentRaidTimer[step - 1] - Speedrun.GetSavedTimer(raid.id, step)
    elseif Speedrun.GetSavedTimer(raid.id, step) and step == 1 then
        previousSegementDif = Speedrun.currentRaidTimer[step] - Speedrun.GetSavedTimer(raid.id, step)
    else
        previousSegementDif = 0
    end

    --TODO IF NO PRESAVED TIME
    if Speedrun.segmentTimer[table.getn(Speedrun.segmentTimer)] then
        bestPossibleTime = difference + Speedrun.segmentTimer[table.getn(Speedrun.segmentTimer)]
        SpeedRun_Advanced_BestPossible_Value:SetText(Speedrun.FormatRaidTimer(bestPossibleTime))
        Speedrun.UpdateCurrentScore()
    else
        SpeedRun_Advanced_BestPossible_Value:SetText(" ")
    end
    SpeedRun_Advanced_PreviousSegment:SetText(Speedrun.FormatRaidTimer(previousSegementDif))
    if Speedrun.Step and Speedrun.currentRaidTimer[Speedrun.Step] and Speedrun.segments[Speedrun.Step] then
        Speedrun.segments[Speedrun.Step]:GetNamedChild('_Best'):SetText(Speedrun.FormatRaidTimer(Speedrun.currentRaidTimer[Speedrun.Step]))
    end
    local segment = Speedrun.segments[Speedrun.Step]:GetNamedChild('_Diff')
    segment:SetText(Speedrun.FormatRaidTimer(difference, true))
    Speedrun.DifferenceColor(difference, segment)
    Speedrun.DifferenceColor(previousSegementDif, SpeedRun_Advanced_PreviousSegment)
end

function Speedrun.DifferenceColor(diff, segment)
    if diff > 0 then
        segment:SetColor(unpack { 1, 0, 0 })
    else
        segment:SetColor(unpack { 0, 1, 0 })
    end
end

-- function Speedrun.UpdateAdds()
-- 		local zoneID = GetZoneId(GetUnitZoneIndex("player"))
-- 		if zoneID ~= 1227 then
-- 				SpeedRun_Adds:SetHidden(true)
-- 				SpeedRun_Adds_SA:SetText(" ")
-- 				SpeedRun_Adds_SA_Counter:SetText(" ")
-- 				SpeedRun_Adds_LA:SetText(" ")
-- 				SpeedRun_Adds_LA_Counter:SetText(" ")
-- 				SpeedRun_Adds_EA:SetText(" ")
-- 				SpeedRun_Adds_EA_Counter:SetText(" ")
-- 				Speedrun_Adds_Total:SetText(" ")
-- 				Speedrun_Adds_Total_Counter:SetText(" ")
-- 			 	return
-- 		else
-- 				Speedrun.scoreReasons = Speedrun.savedVariables.scoreReasons
-- 				SpeedRun_Adds:SetHidden(false)
-- 				for k, v in pairs(Speedrun.scoreReasons) do
-- 						local reason = Speedrun.scoreReasons[k]
-- 						if reason == 1 then
-- 								SpeedRun_Adds_SA_Counter:SetText(reason.times .. " / 63")
-- 								return
-- 						elseif reason == 2 then
-- 								SpeedRun_Adds_LA_Counter:SetText(reason.times .. " / 33")
-- 								return
-- 						elseif reason == 3 then
-- 								SpeedRun_Adds_EA_Counter:SetText(reason.times .. " / 14")
-- 								return
-- 						-- else
-- 						-- 		return
-- 						end
-- 				end
-- 		end
-- end

function Speedrun.HideAdds(hide)
		SpeedRun_Adds:SetHidden(hide)
end

function Speedrun.HideAdds(hide)
		if Speedrun.savedVariables.addsAreHidden == true then
				SpeedRun_Adds:SetHidden(hide)
		end
end

function Speedrun.ResetAddsUI()
		SpeedRun_Adds_SA:SetText(" ")
		SpeedRun_Adds_SA_Counter:SetText(" ")
		SpeedRun_Adds_LA:SetText(" ")
		SpeedRun_Adds_LA_Counter:SetText(" ")
		SpeedRun_Adds_EA:SetText(" ")
		SpeedRun_Adds_EA_Counter:SetText(" ")
end
