if libEnteleaie then return; end

local _api = {};
local api = {};
libEnteleaie = setmetatable( {}, { __index = _api; __api = api } );

local fifo = {}
function fifo:Create()
	local t = {}
	t._t = {}
	function t:push(...)
		if ... then
			local targs = {...}
			for _,v in pairs(targs) do
				table.insert(self._t, v)
			end
		end
	end
	function t:pop(num)
		local num = num or 1
		local entries = {}
		for i = 1, num do
			table.insert(entries, self._t[1])
			table.remove(self._t, 1)
		end
		return unpack(entries)
	end
	function t:getn() return #self._t end
	return t;
end

api["get"] = {

	["permissions"] = {
		["cache"] = -1;
		["cacheStore"] = function( args )
			if args == "" then -- the permissions
				return getmetatable(libEnteleaie).__api.get.permissions._store
			elseif getmetatable(libEnteleaie).__api.get.permissions._store then -- 1 if the permission is found, 0 if not
				return strfind( getmetatable(libEnteleaie).__api.get.permissions._store, args) and 1 or 0;
			else
				return nil;
			end
		end;
		["parse"] = function( response, info )
			if info.args == "" then
				getmetatable(libEnteleaie).__api.get.permissions._store = response
			end
			return response;
		end;
	};
	
	["cooldown"] = {
		["cache"] = 0;
		["lastCache"] = 0;
		["parse"] = function( response, info )
			cooldown = { strsplit( " ", response ) }
			return {
				["announce"] = cooldown[1],
				["gameobject"] = cooldown[2],
				["npc"] = cooldown[3],
			};
		end;
	};
	
	["location"] = {
		["cache"] = 0;
		["lastCache"] = 0;
		["parse"] = function( response, info )
			location = { strsplit( " ", response ) }
			return {
				["m"] = location[1],
				["x"] = location[2],
				["y"] = location[3],
				["z"] = location[4],
				["o"] = location[5],
			};
		end;
	};
	["phase"] = {
		["cache"] = 0;
		["lastcache"] = 0;
		["parse"] = function( response, info )
			return response;
		end;
	};
};
api["set"] = {
};

local _queue = fifo:Create();
local function sendAPIRequest( type, target, args, callback )
	_queue:push({ ["type"] = type, ["target"] = target, ["args"] = args, ["callback"] = callback })
	SendChatMessage( "!api " .. strjoin(" ", type, target, args) )
end

_api["Get"] = function( self, target, args, callback )
	args = args or ""
	
	if ( callback == nil ) then
		if ( type( args ) == "function" ) then
			callback = args
			args = ""
		else
			_ERRORMESSAGE( "Callback not set." )
			return;
		end
	end
	
	if ( api.get[target] == nil ) then
		_ERRORMESSAGE( "Target invalid." )
		return;
	end
	
	if ( api.get[target].cache == -1 ) or
		( api.get[target].cache ~= 0 and
			api.get[target].cache + api.get[target].lastCache >= time()
		)
	then
		returnValue = nil
		if type(api.get[target].cacheStore) == "function" then
			returnValue = api.get[target].cacheStore( args )
		elseif api.get[target].cacheStore then
			returnValue = api.get[target].cacheStore
		end
		if returnValue ~= nil then
			callback( returnValue )
			return;
		end
	end
	
	sendAPIRequest( "get", target, args, callback )

end;

local function getAPIResponse( self, event, response, body, channel, sender )

	if
		event ~= "CHAT_MSG_ADDON" or
		body ~= "" or
		sender ~= UnitName("player") or
		_queue:getn() == 0
	then
		return;
	end

	info = _queue:pop()

	returnValue = api[info.type][info.target].parse( response, info )

	api.get[info.target].lastCache = time()
	api[info.type][info.target].lastValue = returnValue

	info.callback( returnValue )
	
end

local responder = CreateFrame( "frame", "_libEnteleaie" )
responder:SetScript( "OnEvent", getAPIResponse )
responder:RegisterEvent( "CHAT_MSG_ADDON" )