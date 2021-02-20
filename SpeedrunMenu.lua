Speedrun = Speedrun or {}
local Speedrun = Speedrun
local LAM2 = LibAddonMenu2

function Speedrun:GetProfileNames()
		local profiles = {}
		for name, v in pairs(Speedrun.savedVariables.profiles) do
				table.insert(profiles, name)
		end
		return profiles
end

function Speedrun.AddProfile()
		local name = Speedrun_ProfileEditbox.editbox:GetText()
		Speedrun:dbg(0, "Adding new profile [<<1>>]", name)

		if name == "Default" then return end
		if Speedrun.savedVariables.profiles[name] ~= nil then
				Speedrun:dbg(0, "Profile [".. name .."] Already Exist!")
				return
		end

		if (name ~= "") then
				Speedrun.savedVariables.profiles[name] = Speedrun.GetDefaultProfile()
				Speedrun.savedVariables.activeProfile = name
				-- Update the dropbox
				Speedrun_ProfileDropdown:UpdateChoices(Speedrun:GetProfileNames())
				Speedrun.LoadProfile(name)
		else
				Speedrun:dbg(0, "Failed to add profile!")
		end
end

function Speedrun.DeleteProfile()
		local name = Speedrun_ProfileDropdown.data.getFunc()
		Speedrun:dbg(0, "Deleting profile: [<<1>>]", name)

		-- "Default" profile can't be deleted
		if name == "Default" then
				Speedrun:dbg(0, "Profile [Default] cannot deleted!")
				return
		end

		-- update profile vars
		local new_list = { }
		for k, v in pairs(Speedrun.savedVariables.profiles) do
				if name ~= k then
						new_list[k] = v
				end
		end
		Speedrun.savedVariables.profiles = new_list

		-- set "Default" as active
		Speedrun.LoadProfile("Default")
		-- update dropdown
		Speedrun_ProfileDropdown:UpdateChoices(Speedrun:GetProfileNames())
end

function Speedrun.LoadProfile(name)
		Speedrun:dbg(0, "Loading profile: [<<1>>]", name)
		if Speedrun.savedVariables.profiles[name] == nil then
				return
		end
		Speedrun.savedVariables.activeProfile = name
		Speedrun.RefreshData()
end

function Speedrun.RefreshData()
		Speedrun:dbg(2, "Updating Menu")
		Speedrun.customTimerSteps = Speedrun.savedVariables.activeProfile.customTimerSteps
		Speedrun.raidList = Speedrun.savedVariables.activeProfile.raidList
		Speedrun.addsOnCR = Speedrun.savedVariables.activeProfile.addsOnCR
		Speedrun.hmOnSS = Speedrun.savedVariables.activeProfile.hmOnSS
end

function Speedrun.GetTime(seconds)
    if seconds then
        if seconds < 3600 then
            return 	string.format("%02d:%02d", math.floor((seconds / 60) % 60), seconds % 60)
        else
            return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds / 60) % 60), seconds % 60)
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
    local timer = 0
    for i, x in pairs(Speedrun.customTimerSteps[raidID]) do

				if Speedrun.GetSavedTimer(raidID,i) then
            timer = math.floor(Speedrun.GetSavedTimer(raidID,i) / 1000) + timer
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

    local score = tostring(math.floor(Speedrun.GetScore(timer, vitality, raidID)))
    local fScore = string.sub(score,string.len(score)-2,string.len(score))
    local dScore = string.gsub(score,fScore,"")
    score = dScore .. "'" .. fScore

    d("|cdf4242" .. zo_strformat(SI_ZONE_NAME,GetZoneNameById(raidID)) .. "|r")
    d(zo_strformat(SI_SPEEDRUN_SIMULATE_FUNCTION, Speedrun.GetTime(timer), score))
end

function Speedrun.Overwrite(raidID)
		local formatID = raidID
		-- For MA and VH
		if raidID == 677 or raidID == 1227 then
        formatID = raidID .. GetUnitName("player")

				if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
            formatID = raidID
        end
    end

		for k, v in pairs(Speedrun.raidList[formatID]) do
				if Speedrun.customTimerSteps[formatID][k] then
						Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList[formatID][k] = Speedrun.customTimerSteps[formatID][k]
				end
		end

		if Speedrun.IsInTrialZone() then
				ReloadUI("ingame")
		end
end

function Speedrun.ResetData(raidID)
    local formatID = raidID
		-- For MA and VH
    if raidID == 677 or raidID == 1227 then
        formatID = raidID .. GetUnitName("player")

				if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
            formatID = raidID
        end
    end

		if Speedrun.raidList[formatID].timerSteps then
        Speedrun.raidList[formatID].timerSteps = {}
        Speedrun.savedVariables.profiles[Speedrun.activeProfile].raidList = Speedrun.raidList
        ReloadUI("ingame")
    end
end

function Speedrun.CreateOptionTable(raidID, step)
    local formatID = raidID

		-- For MA and VH
		if raidID == 677 or raidID == 1227 then
        formatID = raidID .. GetUnitName("player")

				if Speedrun.raidList[formatID] == nil or Speedrun.raidList[formatID] == {} then
            formatID = raidID
        end
    end

    return {type = "editbox",
            name = zo_strformat(SI_SPEEDRUN_STEP_NAME, Speedrun.stepList[raidID][step]),
            tooltip = Speedrun.GetTooltip(Speedrun.raidList[formatID].timerSteps[step]),
            default = "",
            getFunc = function() return tostring(Speedrun.customTimerSteps[raidID][step]) end,
            setFunc = function(newValue)
                Speedrun.savedVariables.profiles[Speedrun.activeProfile].customTimerSteps[raidID][step] = newValue
                Speedrun.customTimerSteps[raidID][step] = newValue
            end,
    }
end

function Speedrun.CreateRaidMenu(raidID)
    local raidMenu = {}

		table.insert(raidMenu,
		{   type = "description",
				text = zo_strformat(SI_SPEEDRUN_RAID_DESC),
    })

    if raidID == 1051 then
        table.insert(raidMenu,
				{		type = "checkbox",
            name = zo_strformat(SI_SPEEDRUN_ADDS_CR_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ADDS_CR_DESC),
            default = true,
            getFunc = function() return Speedrun.savedVariables.profiles[Speedrun.activeProfile].addsOnCR end,
            setFunc = function(newValue)
                Speedrun.savedVariables.profiles[Speedrun.activeProfile].addsOnCR = newValue
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
        table.insert(raidMenu,
				{		type = "dropdown",
            name = zo_strformat(SI_SPEEDRUN_HM_SS_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_HM_SS_DESC),
            choices = choices,
						default = choices[4],
						getFunc = function() return choices[Speedrun.savedVariables.profiles[Speedrun.activeProfile].hmOnSS] end,
						setFunc = function(selected)
								for index, name in ipairs(choices) do
										if name == selected then
												Speedrun.savedVariables.profiles[Speedrun.activeProfile].hmOnSS = index
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

		table.insert(raidMenu,
		{   type = "button",
				name = zo_strformat(SI_SPEEDRUN_SIMULATE_NAME),
        tooltip = zo_strformat(SI_SPEEDRUN_SIMULATE_DESC),
        func = function()
            Speedrun.Simulate(raidID)
        end,
        width = "half",
    })

		table.insert(raidMenu,
		{   type = "description",
				name = "",
        width = "half",
    })

		table.insert(raidMenu,
		{		type = "button",
        name = "Apply Times",
        tooltip = "Overwrite current saved times with entered custom times",
        func = function()
          	Speedrun.Overwrite(raidID)
        end,
        width = "half",
				isDangerous = true,
        warning = "Confirm Changes.\n|cff0000If you are currently in a trial you this will also reload ui|r  ",
    })

		table.insert(raidMenu,
		{		type = "button",
        name = zo_strformat(SI_SPEEDRUN_RESET_NAME),
        tooltip = zo_strformat(SI_SPEEDRUN_RESET_DESC),
        func = function()
            Speedrun.ResetData(raidID)
        end,
        width = "half",
        isDangerous = true,
        warning = zo_strformat(SI_SPEEDRUN_RESET_WARNING),
    })

    return
		{		type = "submenu",
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
        author = "Floliroy, Panaa, @nogetrandom [PC-EU]",
        version = Speedrun.version,
        slashCommand = "/speed",
        registerForRefresh = true,
        -- registerForDefaults = true,
    }
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Speedrun_Settings", panelData)
    local optionsData = {
        {   type = "divider",
        },
        {   type = "checkbox",	-- Tracking
			      name = "Enable Tracking",--zo_strformat(SI_SPEEDRUN_ENABLE_NAME),
            tooltip = "Turn trial time and score tracking on / off",--zo_strformat(SI_SPEEDRUN_ENABLE_DESC),
            default = true,
						-- isDangerous = true,
						-- warning = "If you are in a trial, then data from current instance will be lost.",
            getFunc = function() return Speedrun.savedVariables.isTracking end,
            setFunc = function(newValue)
								Speedrun.ToggleTracking()
            end,
        },
				{   type = "divider",
				},
        {   type = "checkbox",	-- UI unlock / lock
            name = zo_strformat(SI_SPEEDRUN_LOCK_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_LOCK_DESC),
            default = true,
            getFunc = function() return Speedrun.isMovable end,
            setFunc = function(newValue)
                Speedrun.isMovable = newValue
                Speedrun.savedVariables.isMovable = newValue
                Speedrun.ToggleMovable()
            end,
						width = "half",
        },
        {   type = "checkbox",	-- UI show / hide
            name = zo_strformat(SI_SPEEDRUN_ENABLEUI_NAME),
            tooltip = zo_strformat(SI_SPEEDRUN_ENABLEUI_DESC),
            default = true,
            getFunc = function() return Speedrun.uiIsHidden end,
            setFunc = function(newValue)
                Speedrun.uiIsHidden = newValue
                Speedrun.savedVariables.uiIsHidden = newValue
                Speedrun.SetUIHidden(newValue)
            end,
						width = "half",
        },
        -- {   TODO
				--		 type = "checkbox",
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
				-- {   type = "header",
        --     name = "Profile Options",
				-- },
				{	  type = "submenu",		-- Profile Options
						name = "Profile Options",
						controls = {
								{		type = "editbox",		-- Create New Profile
										name = "Create New Profile",
										tooltip = "Write the name of the new profile and click the Save button to confirm",
										getFunc = function() return Speedrun.savedVariables.activeProfile end,
										setFunc = function(value) end,
										reference = "Speedrun_ProfileEditbox",
										-- width = "half",
								},
								{		type = "button",		-- Save
										name = "Save",
										func = Speedrun.AddProfile,
										-- width = "half",
								},
								{		type = 'dropdown',	-- Load Profile
										name = "Load Profile",
										choices = Speedrun:GetProfileNames(),
										getFunc = function() return Speedrun.savedVariables.activeProfile end,
										setFunc = function(value)
												Speedrun.LoadProfile(value)
										end,
										scrollable = 12,
										reference = "Speedrun_ProfileDropdown",
										-- width = "half",
								},
								-- {		type = "description",
								-- 		text = "",
								-- 		width = "half",
								-- },
								{		type = "button",		-- Delete Profile
										name = "Delete Profile",
										func = Speedrun.DeleteProfile,
										isDangerous = true,
										warning = "This can't be undone. Are you sure?",
										-- width = "half",
								},
						},
				},
				{   type = "header",
            name = "Score Simulator and Records",
        },
        {   type = "submenu", 	-- info
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
										text = "Available [|cffffff/speed|r] commands are:\n[ |cffffffshow|r ] or [ |cffffffhide|r ]: to show or hide the display.\n[ |cfffffftrack|r |cffffff0|r - |cffffff2|r ] To post selection in chat.\n    [ |cffffff0|r ]: Only a few updates.\n    [ |cffffff1|r ]: Trial Checkpoint Updates.\n    [ |cffffff2|r ]: Every score update (adds included).\n[ |cffffffhg|r ] or [ |cffffffhidegroup|r ]: Toggle function on/off.\n[ |cffffffscore|r ]: List current trial score variables in chat",
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
        {   type = "submenu",		-- Trials
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
        {   type = "submenu",		-- Arenas
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
