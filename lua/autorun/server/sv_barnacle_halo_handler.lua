util.AddNetworkString("ttt_barnacle_placed")
util.AddNetworkString("ttt_barnacle_removed")

hook.Add("OnNPCKilled", "BarnacleAlive", function(npcEntity)
    if (npcEntity:GetClass() ~= "npc_barnacle") then return end
    if (npcEntity.IsTraitorBarnacle != true) then return end

    net.Start("ttt_barnacle_removed")
    net.WriteEntity(npcEntity)
    net.Send(GetTraitorFilter(false)) -- GetTraitorFilter(alivePlayersOnly=false) defined in TTT gamemode
end)