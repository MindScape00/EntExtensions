--- Setting Variables

local APPEAR_BUTTON = "|cff00E5EEAppear"
local SUMMON_BUTTON = "|cff00E5EESummon"
local INFO_BUTTON = "|cff00E5EEPlayer Info"

--- Defining the CMD function for later

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

--- Placing the buttons into the Right-Click Unit Popup Menu, just below the "Whisper" button.

UnitPopupButtons["APPEAR_BUTTON"] = { text = APPEAR_BUTTON, dist = 0, tooltipText = "Appear to the selected player."}
UnitPopupButtons["SUMMON_BUTTON"] = { text = SUMMON_BUTTON, dist = 0, tooltipText = "Summon the selected player to you."}
UnitPopupButtons["INFO_BUTTON"] = { text = INFO_BUTTON, dist = 0, tooltipText = "Show the selected player's account info and character list."}

local function BuildPopupMenu( addSummon )
  for menu, items in pairs(UnitPopupMenus) do
    for i = 0, #items do
      if items[i] == "WHISPER" or items[i] == "QTWHISPER_BUTTON" then
		if items[i+1] == "APPEAR_BUTTON" then return; end
        table.insert(items, i + 1, "APPEAR_BUTTON")
        if addSummon == "1" then
          table.insert(items, i + 2, "SUMMON_BUTTON")
          table.insert(items, i + 3, "INFO_BUTTON")
        end
        break
      end
    end
  end
end

---Checking Permissions set of the user

local frame = CreateFrame("frame");
frame:RegisterEvent("PLAYER_LOGIN");
frame:SetScript("OnEvent", function()
    libEnteleaie:Get("permissions", "d", BuildPopupMenu);
end);

--New, Streamlined OnClick code

local function CCButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "APPEAR_BUTTON" == self.value then
	cmd("appear "..unitpopupframe.name)
	elseif "SUMMON_BUTTON" == self.value then
	cmd("summon "..unitpopupframe.name)
	elseif "INFO_BUTTON" == self.value then
	cmd("player "..unitpopupframe.name)
	end
end

hooksecurefunc("UnitPopup_OnClick", CCButtons_OnClick)

--- Slash Command to return current build being used

SLASH_CCQAVERSION1, SLASH_CCQAVERSION2 = '/QuickApp', '/ccqa'; -- 3.
function SlashCmdList.CCQAVERSION(msg, editbox) -- 4.
 print("ConvenientCommands: QuickApp ReleaseBuild -> 3.3");
end

--- End for now
