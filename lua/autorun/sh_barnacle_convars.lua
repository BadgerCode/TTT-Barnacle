CreateConVar("ttt_barnacle_health", 100, {FCVAR_NOTIFY, FCVAR_ARCHIVE}) -- player can oneshot barnacle with crowbar
CreateConVar("ttt_barnacle_transparency", 25, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_barnacle_draw_outline", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add('TTTUlxInitCustomCVar', 'TTTBarnacleInitRWCVar', function(name)
    ULib.replicatedWritableCvar('ttt_barnacle_health', 'rep_ttt_barnacle_health', GetConVar('ttt_barnacle_health'):GetInt(), true, false, name)
    ULib.replicatedWritableCvar('ttt_barnacle_transparency', 'rep_ttt_barnacle_transparency', GetConVar('ttt_barnacle_transparency'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_barnacle_draw_outline', 'rep_ttt_barnacle_draw_outline', GetConVar('ttt_barnacle_draw_outline'):GetBool(), true, false, name)
end)

if SERVER then
	AddCSLuaFile()

	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add("TTT2SyncGlobals", "ttt_barnacle_sync_convars", function()
		SetGlobalInt("ttt_barnacle_health", GetConVar("ttt_barnacle_health"):GetInt())
		SetGlobalInt("ttt_barnacle_transparency", GetConVar("ttt_barnacle_transparency"):GetInt())
		SetGlobalInt("ttt_barnacle_draw_outline", GetConVar("ttt_barnacle_draw_outline"):GetBool())
    end)

    cvars.AddChangeCallback("ttt_barnacle_health", function(cv, old, new)
		SetGlobalInt("ttt_barnacle_health", tonumber(new))
	end)
    cvars.AddChangeCallback("ttt_barnacle_transparency", function(cv, old, new)
		SetGlobalInt("ttt_barnacle_transparency", tonumber(new))
	end)
    cvars.AddChangeCallback("ttt_barnacle_draw_outline", function(cv, old, new)
		SetGlobalInt("ttt_barnacle_draw_outline", tobool(new))
	end)
    
end

if CLIENT then
	hook.Add('TTTUlxModifyAddonSettings', 'TTTBarnacleModifySettings', function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local tttrsclp = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp:SetSize(390, 60)
		tttrsclp:SetExpanded(1)
		tttrsclp:SetLabel('Basic Settings')

		local tttrslst = vgui.Create('DPanelList', tttrsclp)
		tttrslst:SetPos(5, 25)
		tttrslst:SetSize(390, 120)
		tttrslst:SetSpacing(5)

		tttrslst:AddItem(xlib.makeslider{
			label = "ttt_barnacle_health (Def. 100)",
			repconvar = "rep_ttt_barnacle_health",
			min = 1, max = 300,
			parent = tttrslst
		})
        
		tttrslst:AddItem(xlib.makeslider{
			label = "ttt_barnacle_transparency (Def. 25)",
			repconvar = "rep_ttt_barnacle_transparency",
			min = 0, max = 255,
			parent = tttrslst
		})

		tttrslst:AddItem(xlib.makecheckbox{
			label = "ttt_barnacle_draw_outline (Def. 1)",
			repconvar = "rep_ttt_barnacle_draw_outline",
			parent = tttrslst
		})


		xgui.hookEvent('onProcessModules', nil, tttrspnl.processModules)
		xgui.addSubModule('Barnacle', tttrspnl, nil, name)
	end)
end