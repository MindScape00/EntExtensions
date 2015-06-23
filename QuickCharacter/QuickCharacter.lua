local qcloginhandle = CreateFrame("frame","qcloginhandle");
qcloginhandle:RegisterEvent("PLAYER_LOGIN");
qcloginhandle:SetScript("OnEvent", function()
    QCInitialize();
end);

function QCInitialize()
	if CharacterHasBeenSeen == nil then
		CharacterHasBeenSeen = 0
	end
	if SayOnce ~= 1 then
		qctitles()
		qcskills()
		SayOnce = 1
		CharacterHasBeenSeen = 1
	end
end

function qctitles()
	if CharacterHasBeenSeen == 0 then
		for x=1,229 do SendChatMessage(".title add "..x);
		end 
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self,event,m,...)
			if m:find("You have earned the title") or m:find("You have added title") or m:find("You did not specify") then
				return true;
			end
		end);
	end
end

function qcskills()
	if CharacterHasBeenSeen == 0 then
		local s={43,44,45,46,54,55,136,160,172,173,226,228,229,473,415,414,413,293,433};
		for k,v in pairs(s)do SendChatMessage(".learnsk "..v.."");
		end
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self,event,m,...)
			if m:find("Learned skill") or m:find("Your skill") or m:find("You have gained") then
				return true;
			end
		end);
	end
end
