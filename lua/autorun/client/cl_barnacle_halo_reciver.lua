local brEnt = {}

--Display every barnacle
hook.Add("PreDrawHalos", "DrawBarnacle", function()
    if not GetGlobalBool("ttt_barnacle_draw_outline", true) then return end
    if table.IsEmpty(brEnt) then return end
    if TTT2 then
        for _, v in pairs(brEnt) do
            outline.Add(v, Color(255,0,0, 255), OUTLINE_MODE_VISIBLE)
        end
    else
        halo.Add(brEnt, Color(255,0,0, 255), 1, 1, 10, true, true)
    end
end)

net.Receive("ttt_barnacle_halo_push", function()
    brEnt = net.ReadTable()
    table.insert(brEnt, false)
end)
