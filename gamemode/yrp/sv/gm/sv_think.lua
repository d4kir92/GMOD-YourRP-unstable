--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("PlayerStartTaunt", "yrp_taunt_start", function(ply, act, length)
	ply:SetNW2Bool("taunting", true)
	timer.Simple(length, function()
		ply:SetNW2Bool("taunting", false)
	end)
end)

util.AddNetworkString("client_lang")
net.Receive("client_lang", function(len, ply)
	local _lang = net.ReadString()
	printGM("db", ply:YRPName() .. " using language: " .. string.upper(_lang))
	ply:SetNW2String("client_lang", _lang or "NONE")
end)

function reg_hp(ply)
	local hpreg = ply:GetNW2Int("HealthReg")
	if hpreg != nil then
		ply:Heal(hpreg)
		if ply:Health() > ply:GetMaxHealth() then
			ply:SetHealth(ply:GetMaxHealth())
		elseif ply:Health() < 0 then
			ply:Kill()
		end
	end
end

function reg_ar(ply)
	local arreg = ply:GetNW2Int("ArmorReg")
	if arreg != nil then
		ply:SetArmor(ply:Armor() + arreg)
		if ply:Armor() > ply:GetNW2Int("MaxArmor") then
			ply:SetArmor(ply:GetNW2Int("MaxArmor"))
		elseif ply:Armor() < 0 then
			ply:SetArmor(0)
		end
	end
end

function con_hg(ply, time)
	ply:SetNW2Float("hunger", tonumber(ply:GetNW2Float("hunger", 0.0)) - 0.01)
	if tonumber(ply:GetNW2Float("hunger", 0.0)) < 0.0 then
		ply:SetNW2Float("hunger", 0.0)
	end
	if tonumber(ply:GetNW2Float("hunger", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	elseif ply:GetNW2Bool("bool_hunger_health_regeneration", false) then
		local tickrate = tonumber(ply:GetNW2String("text_hunger_health_regeneration_tickrate", 1))
		if tickrate >= 1 and time % tickrate == 0 then
			ply:SetHealth(ply:Health() + 1)
			if ply:Health() > ply:GetMaxHealth() then
				ply:SetHealth(ply:GetMaxHealth())
			end
		end
	end
end

function con_th(ply)
	ply:SetNW2Float("thirst", tonumber(ply:GetNW2Float("thirst", 0.0)) - 0.02)
	if tonumber(ply:GetNW2Float("thirst", 0.0)) < 0.0 then
		ply:SetNW2Float("thirst", 0.0)
	end
	if tonumber(ply:GetNW2Float("thirst", 0.0)) < 20.0 then
		ply:TakeDamage(ply:GetMaxHealth() / 100)
	end
end

function con_st(ply)
	if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:IsOnGround() or ply:KeyDown(IN_SPEED) and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT)) and !ply:InVehicle() then
		ply:SetNW2Int("GetCurStamina", ply:GetNW2Int("GetCurStamina", 0) - (ply:GetNW2Int("stamindown", 1)))
		if ply:GetNW2Int("GetCurStamina", 0) < 0 then
			ply:SetNW2Int("GetCurStamina", 0)
		end
	elseif ply:GetNW2Float("thirst", 0) > 20 then
		ply:SetNW2Int("GetCurStamina", ply:GetNW2Int("GetCurStamina", 0) + ply:GetNW2Int("staminup", 1))
		if ply:GetNW2Int("GetCurStamina", 0) > ply:GetNW2Int("GetMaxStamina", 100) then
			ply:SetNW2Int("GetCurStamina", ply:GetNW2Int("GetMaxStamina", 100))
		end
	end

	if !ply:Slowed() then
		if ply:GetNW2Int("GetCurStamina", 0) < 20 or ply:GetNW2Float("thirst", 0) < 20 then
			ply:SetRunSpeed(ply:GetNW2Int("speedrun", 0) * 0.6)
			ply:SetWalkSpeed(ply:GetNW2Int("speedwalk", 0) * 0.6)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetNW2Int("speedrun", 0))
			ply:SetWalkSpeed(ply:GetNW2Int("speedwalk", 0))
			ply:SetCanWalk(true)
		end
	end
end

hook.Add("Tick", "yrp_keydown", function()
	for k, ply in pairs(player.GetAll()) do
		anti_bunnyhop(ply)
	end
end)

function anti_bunnyhop(ply)
	if ply:KeyDown(IN_JUMP) and ply:GetNW2Bool("canjump", true) then
		ply:SetNW2Bool("canjump", false)
	elseif ply:OnGround() and !ply:GetNW2Bool("jump_resetting", false) and !ply:GetNW2Bool("canjump", false) then
		ply:SetNW2Bool("jump_resetting", true)
		timer.Simple(0.4, function()
			ply:SetNW2Bool("jump_resetting", false)
			ply:SetNW2Bool("canjump", true)
		end)
	end
end

function broken(ply)
	if IsBonefracturingEnabled() and !ply:Slowed() then
		if ply:GetNW2Bool("broken_leg_left") and ply:GetNW2Bool("broken_leg_right") then
			--[[ Both legs broken ]]--
			ply:SetRunSpeed(ply:GetNW2Int("speedrun", 0)*0.5)
			ply:SetWalkSpeed(ply:GetNW2Int("speedwalk", 0)*0.5)
			ply:SetCanWalk(false)
		elseif ply:GetNW2Bool("broken_leg_left") or ply:GetNW2Bool("broken_leg_right") then
			--[[ One leg broken ]]--
			ply:SetRunSpeed(ply:GetNW2Int("speedrun", 0)*0.25)
			ply:SetWalkSpeed(ply:GetNW2Int("speedwalk", 0)*0.25)
			ply:SetCanWalk(false)
		else
			ply:SetRunSpeed(ply:GetNW2Int("speedrun", 0))
			ply:SetWalkSpeed(ply:GetNW2Int("speedwalk", 0))
			ply:SetCanWalk(true)
		end
	end
end

function reg_ab(ply)
	ply:SetNW2Int("GetCurAbility", ply:GetNW2Int("GetCurAbility", 0) + ply:GetNW2Int("GetRegAbility", 1))

	if ply:GetNW2Int("GetCurAbility") > ply:GetNW2Int("GetMaxAbility") then
		ply:SetNW2Int("GetCurAbility", ply:GetNW2Int("GetMaxAbility"))
	elseif ply:GetNW2Int("GetCurAbility") < 0 then
		ply:SetNW2Int("GetCurAbility", 0)
	end
end

function time_jail(ply)
	if ply:GetNW2Bool("injail", false) then
		ply:SetNW2Int("jailtime", ply:GetNW2Int("jailtime", 0) - 1)
		if tonumber(ply:GetNW2Int("jailtime", 0)) <= 0 then
			clean_up_jail(ply)
		end
	end
end

function check_salary(ply)
	if worked(ply:GetNW2String("money"), "sv_think money fail") and worked(ply:GetNW2String("salary"), "sv_think salary fail") then
		if CurTime() >= ply:GetNW2Int("nextsalarytime", 0) and ply:HasCharacterSelected() and ply:Alive() then
			ply:SetNW2Int("nextsalarytime", CurTime() + ply:GetNW2Int("salarytime"))

			local _m = ply:GetNW2String("money", "FAILED")
			local _ms = ply:GetNW2String("salary", "FAILED")
			if _m == "FAILED" or _ms == "FAILED" then
				printGM("note", "_m or _ms failed _m: " .. _m .. " _ms: " .. _ms)
				return false
			end
			local _money = tonumber(_m)
			local _salary = tonumber(_ms)
			if _money != nil and _salary != nil then
				ply:SetNW2String("money", _money + _salary)
				ply:UpdateMoney()
			else
				printGM("error", "CheckMoney in check_salary [ money: " .. tostring(_money) .. " salary: " .. tostring(_salary) .. " ]")
				ply:CheckMoney()
			end
		end
	end
end

function dealerAlive(uid)
	for j, npc in pairs(ents.GetAll()) do
		if npc:IsNPC() then
			if tostring(npc:GetNW2String("dealerID", "FAILED")) == tostring(uid) then
				return true
			end
		end
	end
	return false
end

local _time = 0
timer.Create("ServerThink", 1, 0, function()
	local _all_players = player.GetAll()

	for k, ply in pairs(_all_players) do
		ply:addSecond()

		if ply:GetNW2Bool("loaded", false) then
			anti_bunnyhop(ply)

			if !ply:GetNW2Bool("inCombat") then
				reg_hp(ply)	 --HealthReg
				reg_ar(ply)	 --ArmorReg
				ply:SetNW2Int("yrp_stars", 0)
			end

			if ply:IsBleeding() then
				local effect = EffectData()
				effect:SetOrigin(ply:GetPos() - ply:GetBleedingPosition())
				effect:SetScale(1)
				util.Effect("bloodimpact", effect)
				ply:TakeDamage(0.5, ply, ply)
			end

			if ply:GetNW2Bool("bool_hunger", false) then
				con_hg(ply, _time)
			end
			if ply:GetNW2Bool("bool_thirst", false) then
				con_th(ply)
			end
			if ply:GetNW2Bool("bool_stamina", false) then
				con_st(ply)
			end

			reg_ab(ply)
			time_jail(ply)
			check_salary(ply)
			broken(ply)
		end
	end

	if _time % 60 == 0 then
		local xp_per_minute = YRP.XPPerMinute()
		for i, p in pairs(player.GetAll()) do
			p:AddXP(xp_per_minute)
		end
	end

	if _time % 30 == 0 then
		for i, ply in pairs(_all_players) do
			if ply:GetRoleName() == nil and ply:Alive() then
				if !ply:IsBot() then
					ply:KillSilent()
				end
			end
		end
		local _dealers = SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
		if _dealers != nil and _dealers != false then
			for i, dealer in pairs(_dealers) do
				if tostring(dealer.uniqueID) != "1" then
					if !dealerAlive(dealer.uniqueID) then
						local _del = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = 'dealer' AND linkID = '" .. dealer.uniqueID .. "'")
						if _del != nil then
							printGM("gm", "DEALER [" .. dealer.name .. "] NOT ALIVE, reviving!")
							_del = _del[1]
							local _dealer = ents.Create("yrp_dealer")
							_dealer:SetNW2String("dealerID", dealer.uniqueID)
							_dealer:SetNW2String("name", dealer.name)
							local _pos = string.Explode(",", _del.position)
							_pos = Vector(_pos[1], _pos[2], _pos[3])
							_dealer:SetPos(_pos)
							local _ang = string.Explode(",", _del.angle)
							_ang = Angle(0, _ang[2], 0)
							_dealer:SetAngles(_ang)
							_dealer:SetModel(dealer.WorldModel)
							_dealer:Spawn()

							local sequence = _dealer.Entity:LookupSequence("idle_all_01")
							_dealer.Entity:ResetSequence("idle_all_01")

						end
					end
				end
			end
		end
	end

	if _time % GetBackupCreateTime() == 0 then
		RemoveOldBackups()
		CreateBackup()

		SearchForCollectionID()
	end

	local _auto_save = 300
	if _time % _auto_save == 0 then
		local _mod = _time % 60
		local _left = _time / 60 - _mod
		local _str = "Auto-Save (Uptime: " .. _left .. " " .. YRP.lang_string("LID_minutes") .. ")"
		save_clients(_str)
		SaveStorages(_str)
	end

	if GAMEMODE:IsAutomaticServerReloadingEnabled() then
		local _changelevel = 21600
		if _time >= _changelevel then
			printGM("gm", "Auto Reload")
			timer.Simple(1, function()
				game.ConsoleCommand("changelevel " .. GetMapNameDB() .. "\n")
			end)
		elseif _time >= _changelevel-30 then
			local _str = "Auto Reload in " .. _changelevel-_time .. " sec"
			printGM("gm", _str)
			net.Start("yrp_info2")
				net.WriteString(_str)
			net.Broadcast()
		end
	end

	if _time == 10 then
		YRPCheckVersion()
	elseif _time == 30 then
		IsServerInfoOutdated()
	end
	_time = _time + 1
end)

function RestartServer()
	game.ConsoleCommand("_restart")
end
