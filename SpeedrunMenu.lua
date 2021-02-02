Speedrun = Speedrun or {}
local Speedrun 					= Speedrun
local LAM2 							= LibAddonMenu2

--[[TODO]]
-- ------------------------
-- PROFILE FUNCTIONS
-- ------------------------
--[[
local profileCopyList		= {}
local profileCopyToCopy, profileCopyDropRef
local tinsert	 					= table.insert
local tsort		 					= table.sort

local function PopulateProfileLists()
		local currentPlayer		= tostring(GetCurrentCharacterId())
		local svVersion				= Speedrun.savedVariables.version

		for account, accountData in pairs(Speedrun.Default) do
				for key, data in pairs(accountData) do
						local profile = (data.lastCharname) and data.lastCharname or "" -- use human readable names instead of ID's for selection lists (Phinix)

						if (profile ~= nil) or (profile ~= "") then
								if (data.version == svVersion) then -- only populate current DB version
										if key ~= "$AccountWide" then
												if data.frameVersion and data.frameVersion >= 1.08 then -- only populate non-accountwide from accounts that have converted to ID format (Phinix)
														tinsert(profileCopyList, profile) -- don't add accountwide to copy selection
												end

										elseif (key ~= currentPlayer) then -- don't add current player to copy selection
												if key ~= "$AccountWide" then
														tinsert(profileCopyList, profile) -- don't add accountwide or current player to copy selection
												end
										end
								end
						end
				end
		end
		tsort(profileCopyList)
		tsort(profileDeleteList)
end

local function CopyTable(src, dest)
		if (type(dest) ~= 'table') then
				dest = {}
		end

		if (type(src) == 'table') then
				for k, v in pairs(src) do
						if (type(v) == 'table') then
								CopyTable(v, dest[k])
						end

						dest[k] = v
				end
		end
end

local function CopyProfile()
		local destProfile	= zo_strformat(SI_UNIT_NAME, GetUnitName("player"))
		local sourceData, destData
		local tAcct = profileCopyToCopy
		if profileCopyToCopy == nil or profileCopyToCopy == "" then return end

		for account, accountData in pairs(Speedrun.svDefault) do tAcct = tAcct:gsub(account,'') end
		tAcct = tAcct:gsub('%(',''):gsub('%)','') -- remove formatting used for tagging which global account profile is selected (Phinix)

		for account, accountData in pairs(Speedrun.svDefault) do
				for profile, data in pairs(accountData) do
						if data.lastCharname == profileCopyToCopy then
								sourceData = data -- get source data to copy
						end
						if data.lastCharname == destProfile then
								destData = data
						end
				end
		end
		if (not sourceData or not destData) then -- something went wrong, abort
				Speedrun:dbg(0, "Error During Copy")
		else
				CopyTable(sourceData, destData)
				Speedrun.savedVariables.lastCharname = zo_strformat(SI_UNIT_NAME, GetUnitName("player"))
				ReloadUI()
		end
end
]]
function Speedrun.GetTime(seconds)
    if seconds then
        if seconds < 3600 then
            return
						string.format("%02d:%02d",
            math.floor((seconds / 60) % 60),
            seconds % 60)
				else
					  return
						string.format("%02d:%02d:%02d",
            math.floor(seconds / 3600),
            math.floor((seconds / 60) % 60),
            seconds % 60)
        end
    end
end

function Speedrun.GetTooltip(timer)
    if timer then
        return zo_strformat(SI_SPEEDRUN_STEP_DESC_EXIST, math.floor(timer / 1000), Speedrun.GetTime(math.floor(timer / 1000)))
    else
        return zo_strformat(SI_SPEEDRUN_STEP_DESC_NULL)
    end
end

function Speedrun.Simulate(raidID)
    local totalTime = 0
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
    d("|cdf4242" .. zo_strformat(SI_ZONE_NAME,GetZoneNameById(raidID)) .. "|r")
    d(zo_strformat(SI_SPEEDRUN_SIMULATE_FUNCTION, Speedrun.GetTime(totalTime), score))
end

function Speedrun.Overwrite(raidID)
		local formatID = raidID
		for k, v in pairs(Speedrun.raidList[formatID]) do
				if Speedrun.customTimerSteps[formatID][k] then
						Speedrun.sV.raidList[formatID][k] = Speedrun.customTimerSteps[formatID][k]
				end
		end
		if Speedrun.IsInTrialZone() then
				ReloadUI("ingame")
		end
end

function Speedrun.ResetData(raidID)
    local formatID = raidID
    if Speedrun.raidList[formatID].timerSteps then
        Speedrun.raidList[formatID].timerSteps = {}
        Speedrun.sV.raidList = Speedrun.raidList
        ReloadUI("ingame")
    end
end

function Speedrun.CreateOptionTable(raidID, step)
    local formatID = raidID
    return
		{		type = "editbox",
        name = zo_strformat(SI_SPEEDRUN_STEP_NAME, Speedrun.stepList[raidID][step]),
        tooltip = Speedrun.GetTooltip(Speedrun.raidList[formatID].timerSteps[step]),
        default = "",
        getFunc = function() return tostring(Speedrun.customTimerSteps[raidID][step]) end,
        setFunc = function(newValue)
            Speedrun.sV.customTimerSteps[raidID][step] = newValue
            Speedrun.customTimerSteps[raidID][step] = newValue
        end,
    }
end

function Speedrun.CreateRaidMenu(raidID)
    local raidMenu = {}
    table.insert(raidMenu,
				{		type = "description",
          	text = zo_strformat(SI_SPEEDRUN_RAID_DESC),
    })
    if raidID == 1051 then
        table.insert(raidMenu, {type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ADDS_CR_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ADDS_CR_DESC),
            default = true,
            getFunc = function() return Speedrun.savedVariables.addsOnCR end,
            setFunc = function(newValue)
                Speedrun.savedVariables.addsOnCR = newValue
                Speedrun.addsOnCR = newValue
            end,
        })
    end
    if raidID == 1121 then
        local choices = {
            [1] = zo_strformat(SI_SPEEDRUN_ZERO),
            [2] = zo_strformat(SI_SPEEDRUN_ONE),
            [3] = zo_strformat(SI_SPEEDRUN_TWO),
            [4] = zo_strformat(SI_SPEEDRUN_THREE),
        }
        table.insert(raidMenu, {type = "dropdown",
            name = zo_strformat(SI_SPEEDRUN_HM_SS_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_HM_SS_DESC),
            choices = choices,
						default = choices[4],
						getFunc = function() return choices[Speedrun.savedVariables.hmOnSS] end,
						setFunc = function(selected)
								for index, name in ipairs(choices) do
										if name == selected then
												Speedrun.savedVariables.hmOnSS = index
												Speedrun.hmOnSS = index
												break
										end
								end
						end,
        })
    end
    for i, x in ipairs(Speedrun.stepList[raidID]) do
        table.insert(raidMenu, Speedrun.CreateOptionTable(raidID, i))
    end
    table.insert(raidMenu, {    type = "button",
                                name = zo_strformat(SI_SPEEDRUN_SIMULATE_NAME),
                                tooltip = zo_strformat(SI_SPEEDRUN_SIMULATE_DESC),
                                func = function()
                                    Speedrun.Simulate(raidID)
                                end,
                                width = "half",
    })
		table.insert(raidMenu, {    type = "button",
                                name = "Apply Times",
                                tooltip = "Overwrite current saved times with entered custom times",
                                func = function()
                                    Speedrun.Overwrite(raidID)
                                end,
                                width = "half",
																isDangerous = true,
                                warning = "Confirm Changes.\n|cff0000If you are currently in a trial you this will also reload ui|r  ",
    })
    table.insert(raidMenu, {    type = "button",
                                name = zo_strformat(SI_SPEEDRUN_RESET_NAME),
                                tooltip = zo_strformat(SI_SPEEDRUN_RESET_DESC),
                                func = function()
                                    Speedrun.ResetData(raidID)
                                end,
                                width = "half",
                                isDangerous = true,
                                warning = zo_strformat(SI_SPEEDRUN_RESET_WARNING),
    })
    return {    type = "submenu",
                name = (zo_strformat(SI_ZONE_NAME, GetZoneNameById(raidID))),
                controls = raidMenu,
    }
end
-------------------------
---- Settings Window ----
-------------------------
function Speedrun.CreateSettingsWindow()
    local panelData = {
        type = "panel",
        name = "Speedrun",
        displayName = "Speed|cdf4242Run|r",
        author = "Floliroy, Panaa, |cc0c0c0@|r|cff6666n|r|cc0c0c0ogetrandom|r", --|cc0c0c0@|rn|cc0c0c0ogetrandom|r",
        version = Speedrun.version,
        slashCommand = "/speed",
        registerForRefresh = true,
        registerForDefaults = true,
    }
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)
    local optionsData = {
        {   type = "divider",
        },
        -- {   type = "divider",
        -- },
        --[[{   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ENABLE_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ENABLE_DESC),
            default = true,
            getFunc = function() return end,
            setFunc = function(newValue)
                --TODO
            end,
        },]]
        {   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_LOCK_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_LOCK_DESC),
            default = true,
            getFunc = function() return Speedrun.isMovable end,
            setFunc = function(newValue)
                Speedrun.isMovable = newValue
                Speedrun.savedVariables.isMovable = newValue
                Speedrun.ToggleMovable()
            end,
        },
        {   type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ENABLEUI_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ENABLEUI_DESC),
            default = true,
            getFunc = function() return Speedrun.uiIsHidden end,
            setFunc = function(newValue)
                Speedrun.uiIsHidden = newValue
                Speedrun.savedVariables.uiIsHidden = newValue
                Speedrun.SetUIHidden(newValue)
								if GetZoneId(GetUnitZoneIndex("player")) == 1227 then
										Speedrun.HideAdds(newValue)
								end
            end,
        },
        -- {   type = "checkbox",
        --     name = "Simple Display",
        --     tooltip = "Display only score, vitality and timer",
        --     default = false,
        --     getFunc = function() return Speedrun.uiSimple end,
        --     setFunc = function(newValue)
        --         Speedrun.uiSimple = newValue
        --         Speedrun.savedVariables.uiSimple = newValue
        --         Speedrun.ToggleUISimple(newValue)
        --     end,
        -- },
        {
            type = "header",
            name = "Score Simulator and Records",
        },
        {   type = "submenu",
            name = "info",
            controls = {
            		{   type = "description",
                		text = "Details are still under construction",
            		},
            		{   type = "description",
                		text = zo_strformat(SI_SPEEDRUN_GLOBAL_DESC),
            		},
								{   type = "divider",
								},
								{		type = "description",
										text = "Available [|cffffff/speed|r] commands are:\n[ |cfffffftrack|r |cffffff0|r - |cffffff2|r ] To post selection in chat.\n    [ |cffffff0|r ]: Only a few updates.\n    [ |cffffff1|r ]: Trial Checkpoint Updates.\n    [ |cffffff2|r ]: Every score update (adds included).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat",
								},
            		{   type = "divider",
            		},
								{		type = "submenu",
										name = "ignore this",
										controls = {
												{   type = "description",
														text = zo_strformat(SI_SPEEDRUN_AUTHOR_DESC),
												},
										},
								},
        		},
    		},
    		{ 	type = "submenu",
      			name = "Trials",
      			controls = {
	     					Speedrun.CreateRaidMenu(638),
		        		Speedrun.CreateRaidMenu(636),
				        Speedrun.CreateRaidMenu(639),
				        Speedrun.CreateRaidMenu(725),
				        Speedrun.CreateRaidMenu(975),
				        Speedrun.CreateRaidMenu(1000),
				        Speedrun.CreateRaidMenu(1051),
				        Speedrun.CreateRaidMenu(1121),
				        Speedrun.CreateRaidMenu(1196),
		      	},
    		},
    		{   type = "submenu",
        		name = "Arenas",
        		controls = {
								{   type = "checkbox",
				        		name = "Enable Vateshran Hollows adds UI",
										tooltip = "Enable the add kill counter UI section for Vateshran Hollows",
						        default = true,
						        getFunc = function() return Speedrun.addsAreHidden end,
				        		setFunc = function(newValue)
		            				Speedrun.addsAreHidden = newValue
		            				Speedrun.savedVariables.addsAreHidden = newValue
		            				Speedrun.HideAdds(newValue)
		        				end,
								},
				        Speedrun.CreateRaidMenu(1082),
				        Speedrun.CreateRaidMenu(677),
				        Speedrun.CreateRaidMenu(635),
								Speedrun.CreateRaidMenu(1227),
    				},
  			},
		}

    LAM2:RegisterOptionControls("Speedrun_Settings", optionsData)

end
