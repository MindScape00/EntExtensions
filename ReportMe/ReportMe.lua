---------- Initialization ----------

--- Setting Variables --- Deprecated, left for Legacy

-- local reportmeloginhandle = CreateFrame("frame","reportmeloginhandle");
-- reportmeloginhandle:RegisterEvent("PLAYER_LOGIN");
-- reportmeloginhandle:SetScript("OnEvent", function()
    -- ReportMeLogin();
-- end);

-- function ReportMeLogin()
	-- if reportmemessage == nil then
	-- reportmemessage = "If you have a problem, report me"
	-- end
-- end

--- Defining the "ann" function for later

local function ann(text)
  SendChatMessage(".ann "..text, "GUILD");
end

local function test(text) -- A Test Function to test in /say rather than in GLOBAL broadcast.
  SendChatMessage(""..text, "say");
end

-- Main Function

function RPRTME_FUNCT(msg, editbox)
	if reportmemessage == nil or reportmemessage == "" then
		ann("If you have a problem, report me: http://bit.ly/reportme1");
	else
		ann(""..reportmemessage..": http://bit.ly/reportme1");
	end
end

-- Note; bit.ly/reportme1 links to http://jacburn.at.ua/reportme which is a custom redirect in itself, therefore changeable in the future to initialize updates on the link without actually changing the addon or base link itself.

function RPRTMEFRAME_OnClick()
	RPRTME_FUNCT();
end

--- Slash Command to run

SLASH_RPRTME1, SLASH_RPRTME2 = '/reportme', '/rm'; -- 3.
function SlashCmdList.RPRTME(msg, editbox) -- 4.
	RPRTME_FUNCT();
end

SLASH_RPRTMESET1, SLASH_RPRTMESET2 = '/reportmeset', '/rms';
function SlashCmdList.RPRTMESET(msg, editbox)
	if msg == "" then
		reportmemessage = nil
		print("ReportMe | Message set to default. ('If you have a problem, report me')")
	else
		reportmemessage = msg
		print("ReportMe | Message Set to '"..msg.."'")
	end
end

--- End for now
