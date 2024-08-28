--[[
Author: Goennigoegoe aka nullptr
Date: I don't remember when this was made but it was a while ago back when MCPEngu was stil a moderator.

I don't know if this even works, if it doesn't then just use something else I guess.
]]--

local SteamID = ""; -- Input the SteamID here eg STEAM_0:0:123456789
local name = ""; -- streamers display name on steam

local useName = true;

callbacks.Register( "OnLobbyUpdated", "StreamSniper", function( lobby )
    local PlayerInLobby = false;

    local length = 0;

    for _, player in pairs( lobby:GetMembers() ) do
        --print( player:GetSteamID(), player:GetTeam() )
        length = length + 1;

        if player:GetSteamID() == SteamID and useName == false then
            PlayerInLobby = true;
        elseif steam.GetPlayerName(player:GetSteamID()) == name and useName == true then
            PlayerInLobby = true;
        end
    end

    local currentQueueGroup = party.GetAllMatchGroups()["Casual"];

    if length > 1 then
        if not PlayerInLobby then
            if party.GetQueuedMatchGroups()["Casual"] ~= nil then
                local reasons = party.CanQueueForMatchGroup( currentQueueGroup );

                if reasons == true then
                    party.QueueUp( currentQueueGroup );
                else
                    for k,v in pairs( reasons ) do
                        print( v );
                    end
                end
            end
        else
            party.CancelQueue(currentQueueGroup);
        end
    end
end )
