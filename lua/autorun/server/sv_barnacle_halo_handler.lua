util.AddNetworkString("ttt_barnacle_halo_push")
local traitorList = {}
local tindex = 0
local brEnt = {}
local eindex = 0

--Get list of traitors in order send them information about barnacle
local function createTraitorList()
    local players = player.GetAll()
    for i = 1, #players do
        local p = players[i]
        if not p:IsTraitor() then continue end
        traitorList[#traitorList + 1] = p
    end
end
hook.Add( "TTTBeginRound", "TraitorList", createTraitorList)

--Clear list of traitor
hook.Add( "TTTPrepareRound", "ClearTraitorList", function()
    traitorList = {}
    tindex = 0
    brEnt = {}
    eindex = 0
end)
hook.Add( "TTTEndRound", "ClearTraitorList2", function()
    brEnt = {}
    eindex = 0
    net.Start("ttt_barnacle_halo_push")
    net.WriteTable(brEnt)
    net.Send(traitorList)
    traitorList = {}
    tindex = 0
end)

--Check if created entity is barnacle, if so send message to all traitors.
hook.Add( "OnEntityCreated", "BarnacleHalo", function( ent )
    if ent:GetClass() ~= "npc_barnacle" then return end
    if table.IsEmpty(traitorList) then return end
    brEnt[eindex] = ent
    eindex = eindex + 1
    net.Start("ttt_barnacle_halo_push")
    net.WriteTable(brEnt)
    net.Send(traitorList)
end)

--Check if killed NPC was barnacle, if so send message to all traitors
hook.Add("OnNPCKilled", "BarnacleAlive", function(npc)
    if npc:GetClass() ~= "npc_barnacle" then return end
    if table.IsEmpty(traitorList) then return end
    for k, v in pairs(brEnt) do
        if npc == v then 
            brEnt[k] = false
        end
    end
    net.Start("ttt_barnacle_halo_push")
    net.WriteTable(brEnt)
    net.Send(traitorList)
end)