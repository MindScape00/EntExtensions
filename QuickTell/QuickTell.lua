--- Setting Variables

local QTWHISPER_BUTTON = "|cff00FF7FWhisper"

--- Defining the CMD function for later

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

--- Placing the new QTWHISPER button, and removing the Blizzard Whisper button.

UnitPopupButtons["QTWHISPER_BUTTON"] = { text = QTWHISPER_BUTTON, dist = 0, tooltipText = "Whisper the selected player." }

for menu, items in pairs(UnitPopupMenus) do
	for i = 0, #items do
		if items[i] == "WHISPER" then
			table.remove(items, i, "WHISPER")
			table.insert(items, i+1, "QTWHISPER_BUTTON")
			break
		end
	end
end

--OnClick Code. The function checks if there's a space in the name, and uses !whisper "CHAR NAME" if there is; if there's no space, it defaults to using "/whisper". Why? Compatability, I guess.

local function QTWButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
		if "QTWHISPER_BUTTON" == self.value then
		ChatFrame1EditBox:SetFocus()
			if string.find(unitpopupframe.name, "%s") then
			ChatFrame1EditBox:SetText('!whisper "'..unitpopupframe.name..'" ')
			else
			ChatFrame1EditBox:SetText('/whisper '..unitpopupframe.name..' ')
		end
	end
end

hooksecurefunc("UnitPopup_OnClick", QTWButtons_OnClick)

--Old OnClick code; it doesn't have the compatability features, and will use !whisper for everyone, unexclusively and without prejudice. Keeping it here for debug and informational purposes.

--[[
local function QTWButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "QTWHISPER_BUTTON" == self.value then
	ChatFrame1EditBox:SetFocus()
	ChatFrame1EditBox:SetText('!whisper "'..unitpopupframe.name..'" ')
	end
end

hooksecurefunc("UnitPopup_OnClick", QTWButtons_OnClick)
--]]

--- Slash Command to return current build being used

SLASH_CCQTVERSION1, SLASH_CCQTVERSION2 = '/QuickTell', '/ccqt'; -- 3.
function SlashCmdList.CCQTVERSION(msg, editbox) -- 4.
 print("ConvenientCommands: QuickTell ReleaseBuild 1.0");
end

--- End for now
