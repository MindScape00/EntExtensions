-------------------------------------------------------------------------------
-- QuickPhase by MindScape - Designed for Enteleaie
-------------------------------------------------------------------------------

local currentVersion = GetAddOnMetadata("QuickPhase", "Version")

-------------------------------------------------------------------------------
-- Local Simple Functions
-------------------------------------------------------------------------------

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

-------------------------------------------------------------------------------
-- NEW BUTTONS - Old ones were such a mess
-------------------------------------------------------------------------------

--Main Buttons
UnitPopupButtons["ConvenientCommandsTitle"] = {text = "ConvenientCommands", dist = 0, isTitle = true, isUninteractable = true, isSubsectionTitle = true};
UnitPopupButtons["QuickPhaseModHeader"] = { text = "|cffFF6060Phase Mod", dist = 0, nested = 1};
UnitPopupButtons["QuickPhaseMemberHeader"] = { text = "|cffFF6060Phase Member", dist = 0, nested = 1};

--Member Sub-Buttons
UnitPopupButtons["QuickPhaseMemberAdd"] = { text = "Add Member", dist = 0, tooltipText = "Add as Member to Phase"};
UnitPopupButtons["QuickPhaseMemberRemove"] = { text = "Remove Member", dist = 0, tooltipText = "Remove Member Permissions from Phase"};
UnitPopupButtons["QuickPhaseMemberPromote"] = { text = "Promote", dist = 0, tooltipText = "Promote Member to Officer"};
UnitPopupButtons["QuickPhaseMemberDemote"] = { text = "Demote", dist = 0, tooltipText = "Demote Officer to Member"};

--Mod Sub-Buttons
UnitPopupButtons["QuickPhaseModUI"] = { text = "ModUI", dist = 0, tooltipText = "Open Phase Mod UI (Kick with Reason)"};
UnitPopupButtons["QuickPhaseModKick"] = { text = "Kick", dist = 0, tooltipText = "Quickly kick from the phase."};
UnitPopupButtons["QuickPhaseModList"] = { text = "Blacklist", dist = 0, tooltipText = "Quickly Blacklist from the phase."};
UnitPopupButtons["QuickPhaseModUnlist"] = { text = "Unlist", dist = 0, tooltipText = "Quickly Unlist from the phase."};

--Defining Sub-Menus (Nested)
UnitPopupMenus["QuickPhaseModHeader"] = {"QuickPhaseModUI", "QuickPhaseModKick", "QuickPhaseModList", "QuickPhaseModUnlist"};
UnitPopupMenus["QuickPhaseMemberHeader"] = {"QuickPhaseMemberAdd", "QuickPhaseMemberRemove", "QuickPhaseMemberPromote", "QuickPhaseMemberDemote"};

-------------------------------------------------------------------------------
-- Hook to the Context Menu and add in our own items
-------------------------------------------------------------------------------

for menu, items in pairs(UnitPopupMenus) do
	local insertIndex
	for index, item in ipairs(items) do
		if item == "ConvenientCommandsTitle" then
			insertIndex = index
			if insertIndex then
				table.insert(items, insertIndex + 3, "QuickPhaseModHeader")
				table.insert(items, insertIndex + 4, "QuickPhaseMemberHeader")
				break
			end
		elseif item == "INTERACT_SUBSECTION_TITLE" then
			insertIndex = index
			if insertIndex then
				table.insert(items, insertIndex + 1 - 1, "ConvenientCommandsTitle")
				table.insert(items, insertIndex + 2 - 1, "QuickPhaseModHeader")
				table.insert(items, insertIndex + 3 - 1, "QuickPhaseMemberHeader")
				break
			end
		end
	end
end

-------------------------------------------------------------------------------
--Codes to OnClick and send out the command.
-------------------------------------------------------------------------------

local function QuickPhaseButtons_OnClick(self)
	local unitpopupframe = UIDROPDOWNMENU_INIT_MENU;
	if "QuickPhaseModKick" == self.value then
		cmd("phase kick "..unitpopupframe.name)
	elseif "QuickPhaseModList" == self.value then
		cmd("phase blacklist add "..unitpopupframe.name)
	elseif "QuickPhaseModUnlist" == self.value then
		cmd("phase blacklist remove "..unitpopupframe.name)
	elseif "QuickPhaseMemberAdd" == self.value then
		cmd("phase member add "..unitpopupframe.name)
	elseif "QuickPhaseMemberRemove" == self.value then
		cmd("phase member remove "..unitpopupframe.name)
	elseif "QuickPhaseMemberPromote" == self.value then
		cmd("phase member promote "..unitpopupframe.name)
	elseif "QuickPhaseMemberDemote" == self.value then
		cmd("phase member demote "..unitpopupframe.name)
	elseif "QuickPhaseModHeader" == self.value or "QuickPhaseModUI" == self.value then
		QuickPhaseFrame01:Show();
		QPReasonBox:SetText("")
		QPPlayerNameBox:SetText(unitpopupframe.name)
		QPReasonBox:SetFocus()
	end
end

hooksecurefunc("UnitPopup_OnClick", QuickPhaseButtons_OnClick)

-------------------------------------------------------------------------------
-- Making the GUI buttons do something OnClick
-------------------------------------------------------------------------------

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
    cmd("phase blacklist add "..b);
	QuickPhaseFrame01.isKicking = true
	QuickPhaseFrame01:Hide();
return msg;
end

function QPUnListButtonUI_OnClick()
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
    cmd("phase blacklist remove "..b);
	QuickPhaseFrame01:Hide();
return msg;
end

function QPKickButtonUI_OnClick()
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
    cmd("phase kick "..b);
	QuickPhaseFrame01.isKicking = true
	QuickPhaseFrame01:Hide();
return msg;
end

-------------------------------------------------------------------------------
-- Setting the Chat Filter
-------------------------------------------------------------------------------

function filter(self, event, msg, ...)
local clearmsg = gsub(msg,"|cff%x%x%x%x%x%x","");
local b = QPPlayerNameBox:GetText();
local d = QPReasonBox:GetText();
	if QuickPhaseFrame01.isKicking == true and clearmsg:find(b.." kicked.") then
		if d == nil or d == "" then
			cmd('whisper "'..b..'" [ALERT] You have been kicked from the phase.');
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been kicked from the phase.'); 
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		else
			cmd('whisper "'..b..'" [ALERT] You have been kicked from the phase for reason: ' ..d);
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been kicked from the phase for reason: ' ..d);
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		end
	elseif QuickPhaseFrame01.isKicking == true and clearmsg:find("Player has been added to the blacklist.") then
		if d == nil or d == "" then
			cmd('whisper "'..b..'" [ALERT] You have been listed from the phase.');
				if QPSilenceCheckButton1.silenced == false then 
					cmd('phase announce [ALERT]: '..b..' has been listed from the phase.');
				end
			QuickPhaseFrame01:Hide();
			QuickPhaseFrame01.isKicking = false;
		else
			cmd('whisper "'..b..'" [ALERT] You have been listed from the phase for reason: ' ..d);
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

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filter)

-------------------------------------------------------------------------------
--- Slash Command to return current build being used
-------------------------------------------------------------------------------

SLASH_CCQKVERSION1, SLASH_CCQKVERSION2 = '/QuickPhase', '/ccqp'; -- 3.
function SlashCmdList.CCQKVERSION(msg, editbox) -- 4.
 print("|cffFF6060ConvenientCommands: QuickPhase v"..currentVersion);
end

SLASH_CCQKDEVBOX1 = '/qpui'; -- 3.
function SlashCmdList.CCQKDEVBOX(msg, editbox) -- 4.
 QuickPhaseFrame01:Show();
end

--- End for now