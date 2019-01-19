-------------------------------------------------------------------------------
-- QuickApp by MindScape - Designed for Enteleaie
-------------------------------------------------------------------------------

local currentVersion = GetAddOnMetadata("QuickApp", "Version")

-------------------------------------------------------------------------------
-- Local Simple Functions
-------------------------------------------------------------------------------

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

-------------------------------------------------------------------------------
-- Hook to the Context Menu and add in our own items
-------------------------------------------------------------------------------

UnitPopupButtons["ConvenientCommandsTitle"] = {text = "ConvenientCommands", dist = 0, isTitle = true, isUninteractable = true, isSubsectionTitle = true};
UnitPopupButtons["QuickAppAppearButton"] = { text = "|cff00E5EEAppear", dist = 0, tooltipText = "Appear to the selected player."}
UnitPopupButtons["QuickAppSummonButton"] = { text = "|cff00E5EESummon", dist = 0, tooltipText = "Summon the selected player to you."}
UnitPopupButtons["QuickAppInfoButton"] = { text = "|cff00E5EEPlayer Info", dist = 0, tooltipText = "Show the selected player's account info and character list."} --Admin Only now - Disabled

for menu, items in pairs(UnitPopupMenus) do
	local insertIndex
	for index, item in ipairs(items) do
		if item == "ConvenientCommandsTitle" then
			insertIndex = index
			if insertIndex then
				table.insert(items, insertIndex + 1, "QuickAppAppearButton")
				table.insert(items, insertIndex + 2, "QuickAppSummonButton")
				break
			end
		elseif item == "INTERACT_SUBSECTION_TITLE" then
			insertIndex = index
			if insertIndex then
				table.insert(items, insertIndex + 1 - 1, "ConvenientCommandsTitle")
				table.insert(items, insertIndex + 2 - 1, "QuickAppAppearButton")
				table.insert(items, insertIndex + 3 - 1, "QuickAppSummonButton")
				break
			end
		end
	end
end

--[[ The Old Code
--local function BuildPopupMenu( addSummon ) -- Disabled to disable the libEnteleaie Check
  for menu, items in pairs(UnitPopupMenus) do
    for i = 0, #items do
      if items[i] == "WHISPER" or items[i] == "QTWHISPER_BUTTON" then
		if items[i+1] == "APPEAR_BUTTON" then return; end
        table.insert(items, i + 1, "APPEAR_BUTTON")
		table.insert(items, i + 2, "SUMMON_BUTTON")
        --if addSummon == "1" then -- Disabled as the Permission Check is no longer Required
          --table.insert(items, i + 2, "SUMMON_BUTTON") -- This was moved to all players, no longer needs a perm check.
          --table.insert(items, i + 3, "INFO_BUTTON") -- Admin Only, Removed. Permissions No Longer Needed
        --end
        break
      end
    end
  end
--end
  ]]--

-------------------------------------------------------------------------------
-- OnLogin event to check permissions and then build the popupmenu -- Disabled cuz no more Perm Checks
-------------------------------------------------------------------------------

--[[
local frame = CreateFrame("frame");
frame:RegisterEvent("PLAYER_LOGIN");
frame:SetScript("OnEvent", function()
    libEnteleaie:Get("permissions", "d", BuildPopupMenu);
end);
]]--

-------------------------------------------------------------------------------
-- New, Streamlined OnClick code
-------------------------------------------------------------------------------

local function CCButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "QuickAppAppearButton" == self.value then
	cmd("appear "..unitpopupframe.name)
	elseif "QuickAppSummonButton" == self.value then
	cmd("summon "..unitpopupframe.name)
	elseif "QuickAppInfoButton" == self.value then
	cmd("player "..unitpopupframe.name)
	end
end

hooksecurefunc("UnitPopup_OnClick", CCButtons_OnClick)

-------------------------------------------------------------------------------
-- Slash Command to return current build being used
-------------------------------------------------------------------------------

SLASH_CCQAVERSION1, SLASH_CCQAVERSION2 = '/QuickApp', '/ccqa'; -- 3.
function SlashCmdList.CCQAVERSION(msg, editbox) -- 4.
 print("|cff00E5EEConvenientCommands: QuickApp v"..currentVersion);
end

--- End for now