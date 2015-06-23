--- Setting Variables

local PQKICK_LIST = "|cffff6060Phase Mod" -- GUI Toggle
local PKICK_BUTTON = "|cffff6060Phase Kick"
local PLIST_BUTTON = "|cffff6060Phase List"
local PMEM_BUTTON = "|cffff6060Phase Member"

--- Defining the CMD function for later

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

--- Placing the buttons into the Right-Click Unit Popup Menu, just above the "Cancel" button.

UnitPopupButtons["PKICK_BUTTON"] = { text = PKICK_BUTTON, dist = 0, nested = 1};
UnitPopupButtons["PLIST_BUTTON"] = { text = PLIST_BUTTON, dist = 0, nested = 1};
UnitPopupButtons["PMEM_BUTTON"] = {text = PMEM_BUTTON, dist = 0, nested = 1, tooltipText = "Quick Controls for managing the selected players phase membership status."};

--- GUI Buttons

UnitPopupButtons["PQKICK_LIST"] = {text = PQKICK_LIST, dist = 0, nested = 1}; -- The Header
UnitPopupButtons["PQKICK_GUI"] = {text = "|cffFF6060Phase ModUI", dist = 0, tooltipText = "Shows GUI for removing or listing the selected player from the phase."}; -- The Toggle
UnitPopupButtons["PQLIST_UNLIST"] = {text = "|cffFF6060Unlist", dist = 0}; -- The Unlist

--- Create Sub Buttons

UnitPopupButtons["PKICK_KICK"] = {text = "|cffFF6060Kick", dist = 0};
UnitPopupButtons["PLIST_LIST"] = {text = "|cffFF6060List", dist = 0};
UnitPopupButtons["PLIST_UNLIST"] = {text = "|cffFF6060Unlist", dist = 0};
UnitPopupButtons["PMEM_ADD"] = {text = "|cffFF6060Add", dist = 0, tooltipText = "Add the selected player as a phase member."};
UnitPopupButtons["PMEM_REMO"] = {text = "|cffFF6060Remove", dist = 0, tooltipText = "Remove the selected player as a phase member."};
UnitPopupButtons["PMEM_PROMO"] = {text = "|cffFF6060Promote", dist = 0, tooltipText = "Promote the selected member to a phase officer."};
UnitPopupButtons["PMEM_DEMO"] = {text = "|cffFF6060Demote", dist = 0, tooltipText = "Demote the selected officer to a phase member."};

UnitPopupMenus["PKICK_BUTTON"] = {"PLIST_LIST", "PLIST_UNLIST"};
UnitPopupMenus["PMEM_BUTTON"] = {"PMEM_ADD", "PMEM_REMO", "PMEM_PROMO", "PMEM_DEMO"};
UnitPopupMenus["PQKICK_LIST"] = {"PQKICK_GUI", "PLIST_UNLIST"}; --GUI Toggle-List

for menu, items in pairs(UnitPopupMenus) do
	for i = 0, #items do
		if items[1] == "WHISPER" or items[2] == "WHISPER" then
			if items[i] == "CANCEL" then
				table.insert(items, i - 2, "PQKICK_GUI") --GUI Toggle
				table.insert(items, i - 1, "PMEM_BUTTON")
				break
			end
		end
	end
end

--Codes to OnClick and send out the command.

local function CCPhaseButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "PKICK_BUTTON" == self.value then
	cmd("phase removeplayer "..unitpopupframe.name)
	end
end

hooksecurefunc("UnitPopup_OnClick", CCPhaseButtons_OnClick)

local function CCPhaseSubButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "PKICK_KICK" == self.value then
	cmd("phase removeplayer "..unitpopupframe.name)
	elseif "PLIST_LIST" == self.value then
	cmd("phase list player "..unitpopupframe.name)
	elseif "PLIST_UNLIST" == self.value then
	cmd("phase unlist player "..unitpopupframe.name)
	elseif "PMEM_ADD" == self.value then
	cmd("phase member addmem "..unitpopupframe.name)
	elseif "PMEM_REMO" == self.value then
	cmd("phase member removemem "..unitpopupframe.name)
	elseif "PMEM_PROMO" == self.value then
	cmd("phase member promote "..unitpopupframe.name)
	elseif "PMEM_DEMO" == self.value then
	cmd("phase member demote "..unitpopupframe.name)
	end
end

hooksecurefunc("UnitPopup_OnClick", CCPhaseSubButtons_OnClick)

--- GUI Buttons

local function CCQPhaseGUIButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "PQKICK_GUI" == self.value then
	QuickPhaseFrame01:Show();
	QPReasonBox:SetText("")
	QPPlayerNameBox:SetText(unitpopupframe.name)
	QPReasonBox:SetFocus()
	elseif "PQLIST_UNLIST" == self.value then
	cmd("phase unlist player "..unitpopupframe.name)
	end
end

hooksecurefunc("UnitPopup_OnClick", CCQPhaseGUIButtons_OnClick)

-- Form Hide and Show

function QPFormHide_OnClick()
	QuickPhaseFrame01:Hide();
	QPReasonBox:SetText("")
	QPPlayerNameBox:SetText("")
end

function QPFormShow_OnClick()
	QuickPhaseFrame01:Show();
end

-- Making the GUI buttons do something OnClick

function QPSilenceCheckButton1_OnLoad()
	QPSilenceCheckButton1.silenced = false
end

function QPSilenceCheckButton1_OnClick()
	if QPSilenceCheckButton1.silenced == true then
		QPSilenceCheckButton1.silenced = false;
	elseif QPSilenceCheckButton1.silenced == false then
		QPSilenceCheckButton1.silenced = true;
	end
end

function QPListButtonUI_OnClick()
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
    cmd("phase list player "..b);
	QuickPhaseFrame01.isKicking = true
	QuickPhaseFrame01:Hide();
return msg;
end

function QPUnListButtonUI_OnClick()
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
    cmd("phase unlist player "..b);
	QuickPhaseFrame01:Hide();
return msg;
end

function QPKickButtonUI_OnClick()
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
    cmd("phase removeplayer "..b);
	QuickPhaseFrame01.isKicking = true
	QuickPhaseFrame01:Hide();
return msg;
end

-- Setting the Chat Filter

function filter(self, event, msg, ...)
local clearmsg = gsub(msg,"|cff%x%x%x%x%x%x","");
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
	if QuickPhaseFrame01.isKicking == true and clearmsg:find(b.." has been kicked.") then
		if d == nil or d == "" then
			cmd('whisper "'..b..'" You have been kicked from the phase.');
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been kicked from the phase.'); 
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		else
			cmd('whisper "'..b..'" You have been kicked from the phase for reason: ' ..d);
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been kicked from the phase for reason: ' ..d);
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		end
	elseif QuickPhaseFrame01.isKicking == true and clearmsg:find("Player has been blacklisted.") then
		if d == nil or d == "" then
			cmd('whisper "'..b..'" You have been listed from the phase.');
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been listed from the phase.');
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		else
			cmd('whisper "'..b..'" You have been listed from the phase for reason: ' ..d);
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been listed from the phase for reason: ' ..d);
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		end
	elseif QuickPhaseFrame01.isKicking == true then
		QuickPhaseFrame01.isKicking = false;
	end
end

-- Turning the Filter on

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filter)

--- Slash Command to return current build being used

SLASH_CCQKVERSION1, SLASH_CCQKVERSION2 = '/QuickPhase', '/ccqp'; -- 3.
function SlashCmdList.CCQKVERSION(msg, editbox) -- 4.
 print("ConvenientCommands: QuickPhase ReleaseBuild -> 5.3");
end

--- End for now
