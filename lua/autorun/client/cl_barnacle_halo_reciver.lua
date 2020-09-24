local barnacleEntities = {}

net.Receive("ttt_barnacle_placed", function()
    local barnacleEntity = net.ReadEntity()

    barnacleEntities[barnacleEntity:EntIndex()] = barnacleEntity
end)


net.Receive("ttt_barnacle_removed", function()
    local barnacleEntity = net.ReadEntity()

    barnacleEntities[barnacleEntity:EntIndex()] = nil
end)

hook.Add("TTTPrepareRound", "ttt_barnacle_TTTPrepareRound")
hook.Add("TTTPrepareRound", "ttt_barnacle_TTTPrepareRound", function()
    barnacleEntities = {}
end)

hook.Add("TTTEndRound", "ttt_barnacle_TTTEndRound")
hook.Add("TTTEndRound", "ttt_barnacle_TTTEndRound", function()
    barnacleEntities = {}
end)

hook.Remove("PreDrawHalos", "ttt_barnacle_PreDrawHalos")
hook.Add("PreDrawHalos", "ttt_barnacle_PreDrawHalos", function()
    if not GetGlobalBool("ttt_barnacle_draw_outline", true) then return end
    if table.IsEmpty(barnacleEntities) then return end

    if TTT2 then
        for _, v in pairs(barnacleEntities) do
            outline.Add(v, Color(255,0,0, 255), OUTLINE_MODE_VISIBLE)
        end
    else
        halo.Add(barnacleEntities, Color(255,0,0, 255), 1, 1, 10, true, true)
    end
end)
