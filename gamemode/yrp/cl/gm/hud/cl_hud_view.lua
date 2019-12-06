--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function showOwner(eyeTrace)
	if eyeTrace.Entity:GetRPOwner() == LocalPlayer() then
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. YRP.lang_string("LID_you"), "sef", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	elseif wk(eyeTrace.Entity:GetRPOwner()) then
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " .. eyeTrace.Entity:GetRPOwner():RPName(), "sef", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	elseif !strEmpty(eyeTrace.Entity:GetDString("ownerRPName")) or !strEmpty(eyeTrace.Entity:GetDString("ownerGroup")) then
		local groupname = eyeTrace.Entity:GetDString("ownerGroup", "")
		if string.lower(groupname) == "public" then
			groupname = YRP.lang_string("LID_public")
		end
		draw.SimpleTextOutlined(YRP.lang_string("LID_owner") .. ": " ..	eyeTrace.Entity:GetDString("ownerRPName", "") .. groupname, "sef", ScrW() / 2, ScrH2() + YRP.ctr(750), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function showSecurityLevel(door)
	if door:GetDInt("int_securitylevel", 0) > 0 then
		draw.SimpleTextOutlined(YRP.lang_string("LID_securitylevel") .. ": " ..	door:GetDInt("int_securitylevel", 0), "sef", ScrW() / 2, ScrH2() + YRP.ctr(800), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function HudView()
	local ply = LocalPlayer()
	local _eyeTrace = ply:GetEyeTrace()

	if ea(_eyeTrace.Entity) then
		if _eyeTrace.Entity:GetPos():Distance(ply:GetPos()) > GetGlobalDInt("int_door_distance", 200) then
			return
		end

		if GetGlobalDBool("bool_building_system", false) and (_eyeTrace.Entity:GetClass() == "prop_door_rotating" or _eyeTrace.Entity:GetClass() == "func_door" or _eyeTrace.Entity:GetClass() == "func_door_rotating") and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < GetGlobalDInt("int_door_distance", 200) then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopen", tab), "sef", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			local canbeowned = tobool(_eyeTrace.Entity:GetDTable("building", {}).bool_canbeowned)
			if canbeowned or ply:HasAccess() then
				local tab2 = {}
				tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_door")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopensettings", tab2), "sef", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				showOwner(_eyeTrace)
				showSecurityLevel(_eyeTrace.Entity)
			end
		elseif _eyeTrace.Entity:IsVehicle() and !ply:InVehicle() then
			local tab = {}
			tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstogetin", tab), "sef", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			if _eyeTrace.Entity:GetDString("ownerRPName") == ply:Nick() then
				local tab2 = {}
				tab2["KEY"] = "[" .. string.upper(GetKeybindName("menu_options_vehicle")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopensettings", tab2), "sef", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
			showOwner(_eyeTrace)
		elseif _eyeTrace.Entity:IsPlayer() then
			if _eyeTrace.Entity:GetColor().a != 0 or !_eyeTrace.Entity:GetDBool("cloaked") then
				local tab = {}
				tab["NAME"] = tostring(_eyeTrace.Entity:RPName())
				tab["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstointeractwith", tab), "sef", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif _eyeTrace.Entity:IsNPC() then
			if _eyeTrace.Entity:GetDString("dealerID", "") != "" then
				draw.SimpleTextOutlined(_eyeTrace.Entity:GetDString("name", ""), "sef", ScrW() / 2, ScrH2() + YRP.ctr(150), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				local key = {}
				key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
				draw.SimpleTextOutlined(YRP.lang_string("LID_presstotrade", key), "sef", ScrW() / 2, ScrH2() + YRP.ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			end
		elseif _eyeTrace.Entity:GetClass() == "yrp_clothing" and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstochangeyourclothes", key), "sef", ScrW() / 2, ScrH2() + YRP.ctr(650), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif _eyeTrace.Entity:HasStorage() and ply:GetPos():Distance(_eyeTrace.Entity:GetPos()) < 150 then
			local key = {}
			key["KEY"] = "[" .. string.upper(GetKeybindName("in_use")) .. "]"
			key["NAME"] = _eyeTrace.Entity:StorageName()
			draw.SimpleTextOutlined(YRP.lang_string("LID_presstoopenname", key), "sef", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		elseif _eyeTrace.Entity:GetDBool("yrp_has_use", false) then
			local text = "PRESS [" .. string.upper(GetKeybindName("in_use")) .. "]"
			if _eyeTrace.Entity:GetDString("yrp_use_message", "") != "" then
				text = text .. ": " .. _eyeTrace.Entity:GetDString("yrp_use_message", "")
			end
			draw.SimpleTextOutlined(text, "sef", ScrW() / 2, ScrH2() + YRP.ctr(700), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		end
		showOwner(_eyeTrace)
	end
end
