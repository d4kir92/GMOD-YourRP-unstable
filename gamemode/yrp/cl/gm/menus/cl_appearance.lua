--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _appe = {}
_appe.r = {}
local _yrp_appearance = {}
local play = true
net.Receive( "get_menu_bodygroups", function( len )
	local _tbl = net.ReadTable()
	if _tbl.playermodels != nil and _tbl.playermodelsnone != nil then
		local _skin = tonumber( _tbl.skin )
		local _pms = combineStringTables( _tbl.playermodels, _tbl.playermodelsnone )
		local ply = LocalPlayer()
		if ply:GetNWBool( "bool_appearance_system", false ) and pa(_yrp_appearance.left) then
			if _yrp_appearance.left.GetChildren != nil then
				for i, child in pairs(_yrp_appearance.left:GetChildren()) do
					child:Remove()
				end
			end

			local _pmid = tonumber( _tbl.playermodelID )
			if _pmid > #_pms then
				_pmid = 1
			end
			local _pm = _pms[_pmid]
			if _pm == "" or _pm == " " then
				_pm = "models/player/skeleton.mdl"
			end
			if pm != "" then
				local _cbg = {}
				_cbg[1] = _tbl.bg0 or 0
				_cbg[2] = _tbl.bg1 or 0
				_cbg[3] = _tbl.bg2 or 0
				_cbg[4] = _tbl.bg3 or 0
				_cbg[5] = _tbl.bg4 or 0
				_cbg[6] = _tbl.bg5 or 0
				_cbg[7] = _tbl.bg6 or 0
				_cbg[8] = _tbl.bg7 or 0
				_cbg[9] = _tbl.bg8 or 0
				_cbg[10] = _tbl.bg9 or 0
				_cbg[11] = _tbl.bg10 or 0
				_cbg[12] = _tbl.bg11 or 0
				_cbg[13] = _tbl.bg12 or 0
				_cbg[14] = _tbl.bg13 or 0
				_cbg[15] = _tbl.bg14 or 0
				_cbg[16] = _tbl.bg15 or 0
				_cbg[17] = _tbl.bg16 or 0
				_cbg[18] = _tbl.bg17 or 0
				_cbg[19] = _tbl.bg18 or 0
				_cbg[20] = _tbl.bg19 or 0

				function _yrp_appearance.left:Paint( pw, ph )
					--surfacePanel( self, pw, ph )
					--draw.SimpleTextOutlined( lang_string( "appearance" ), "HudBars", pw/2, ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
				end

				_appe.r.play = createD("DButton", _yrp_appearance.left, ctr(100), ctr(100), BScrW() / 4, ScrH() - ctr(200) )
				_appe.r.play:SetText("")
				function _appe.r.play:Paint(pw, ph)
					local tab = {}
					tab.w = pw
					tab.h = ph
					tab.text = {}
					tab.text.text = ""
					DrawButton(self, tab)
					local symbol = "pause"
					local color = Color(255, 0, 0)
					if !self:IsHovered() and play then
						symbol = "play"
						color = Color(0, 255, 0)
					elseif self:IsHovered() and !play then
						symbol = "play"
						color = Color(0, 255, 0)
					end
					DrawIcon(GetDesignIcon(symbol), pw, ph, 0, 0, color)
				end
				function _appe.r.play:DoClick()
					play = !play
				end

				_appe.r.pm = createD( "DModelPanel", _yrp_appearance.left, ScrH() - ctr(100), BScrW() / 2, 0, ctr(50) )
				_appe.r.pm:SetModel( _pm )
				_appe.r.pm:SetAnimated( true )
				_appe.r.pm.Angles = Angle( 0, 0, 0 )
				_appe.r.pm:RunAnimation()

				function _appe.r.pm:DragMousePress()
					self.PressX, self.PressY = gui.MousePos()
					self.Pressed = true
				end
				function _appe.r.pm:DragMouseRelease() self.Pressed = false end

				function _appe.r.pm:LayoutEntity( ent )
					if self.Pressed then
						local mx = gui.MousePos()
						self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

						self.PressX, self.PressY = gui.MousePos()
					elseif play then
						self.Angles = self.Angles + Angle(0, 0.1, 0)
					end
					ent:SetAngles( self.Angles )
					if self.bAnimated then
						self:RunAnimation()
					end
				end

				-- Playermodel changing
				local _tmpPM = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( 80 ), BScrW() / 2, ctr( 50 ) )
				_tmpPM.cur = _pmid
				_tmpPM.max = #_pms
				_tmpPM.name = lang_string( "appearance" )
				function _tmpPM:Paint( pw, ph )
					surfacePanel( self, pw, ph )
					draw.SimpleTextOutlined( self.name .. " (" .. _tmpPM.cur .. "/" .. _tmpPM.max .. ")", "DermaDefault", ctr( 60 ), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
				end

				local _tmpPMUp = createD( "DButton", _tmpPM, ctr( 50 ), ctr( 80 / 2 - 4 ), ctr( 2 ), ctr( 2 ) )
				_tmpPMUp:SetText( "" )
				function _tmpPMUp:Paint( pw, ph )
					if _tmpPM.cur < _tmpPM.max then
						surfaceButton( self, pw, ph, "↑" )
					end
				end
				function _tmpPMUp:DoClick()
					if _tmpPM.cur < _tmpPM.max then
						_tmpPM.cur = _tmpPM.cur + 1
					end
					net.Start( "inv_pm_up" )
						net.WriteInt( _tmpPM.cur, 16 )
					net.SendToServer()
					_appe.r.pm.Entity:SetModel( _pms[_tmpPM.cur] )
				end

				local _tmpPMDo = createD( "DButton", _tmpPM, ctr( 50 ), ctr( 80 / 2 - 4), ctr( 2 ), ctr( 2 + 40 ) )
				_tmpPMDo:SetText( "" )
				function _tmpPMDo:Paint( pw, ph )
					if _tmpPM.cur > 1 then
						surfaceButton( self, pw, ph, "↓" )
					end
				end
				function _tmpPMDo:DoClick()
					if _tmpPM.cur > 1 then
						_tmpPM.cur = _tmpPM.cur - 1
					end
					net.Start( "inv_pm_do" )
						net.WriteInt( _tmpPM.cur, 16 )
					net.SendToServer()
					_appe.r.pm.Entity:SetModel( _pms[_tmpPM.cur] )
				end

				--[[ Skin changing ]]--
				_tbl.bgs = _appe.r.pm.Entity:GetBodyGroups()

				local _tmpSkin = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( 80 ), BScrW() / 2, ctr( 200 ) )
				_tmpSkin.cur = _appe.r.pm.Entity:GetSkin()
				_tmpSkin.max = _appe.r.pm.Entity:SkinCount()
				_tmpSkin.name = lang_string( "skin" )
				function _tmpSkin:Paint( pw, ph )
					surfacePanel( self, pw, ph )
					draw.SimpleTextOutlined( self.name .. " (" .. _tmpSkin.cur + 1 .. "/" .. _tmpSkin.max .. ")", "DermaDefault", ctr( 60 ), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
				end

				local _tmpSkinUp = createD( "DButton", _tmpSkin, ctr( 50 ), ctr( 80 / 2 - 4 ), ctr( 2 ), ctr( 2 ) )
				_tmpSkinUp:SetText( "" )
				function _tmpSkinUp:Paint( pw, ph )
					if _tmpSkin.cur < _tmpSkin.max - 1 then
						surfaceButton( self, pw, ph, "↑" )
					end
				end
				function _tmpSkinUp:DoClick()
					if _tmpSkin.cur < _tmpSkin.max-1 then
						_tmpSkin.cur = _tmpSkin.cur + 1
					end
					net.Start( "inv_skin_up" )
						net.WriteInt( _tmpSkin.cur, 16 )
					net.SendToServer()
					_appe.r.pm.Entity:SetSkin( _tmpSkin.cur )
				end

				local _tmpSkinDo = createD( "DButton", _tmpSkin, ctr( 50 ), ctr( 80 / 2 - 4), ctr( 2 ), ctr( 2 + 40 ) )
				_tmpSkinDo:SetText( "" )
				function _tmpSkinDo:Paint( pw, ph )
					if _tmpSkin.cur > 0 then
						surfaceButton( self, pw, ph, "↓" )
					end
				end
				function _tmpSkinDo:DoClick()
					if _tmpSkin.cur > 0 then
						_tmpSkin.cur = _tmpSkin.cur - 1
					end
					net.Start( "inv_skin_do" )
						net.WriteInt( _tmpSkin.cur, 16 )
					net.SendToServer()
					if ea( _appe.r.pm.Entity ) then
						_appe.r.pm.Entity:SetSkin( _tmpSkin.cur )
					end
				end

				-- Bodygroups changing
				for k, v in pairs( _tbl.bgs ) do
					if _cbg[k] != nil then
						_cbg[k] = tonumber(_cbg[k])
						_appe.r.pm.Entity:SetBodygroup( k-1, tonumber(_cbg[k]))
						local _height = 80
						local _tmpBg = createD( "DPanel", _yrp_appearance.left, ScrH2() - ctr( 30 ), ctr( _height ), BScrW() / 2, ctr( 300 ) + k * ctr( _height + 2 ) )
						_tmpBg.name = v.name
						_tmpBg.max = v.num
						_tmpBg.cur = _cbg[k]
						_tmpBg.id = v.id
						function _tmpBg:Paint( pw, ph )
							surfacePanel( self, pw, ph )
							draw.SimpleTextOutlined( self.name .. " (" .. _tmpBg.cur + 1 .. "/" .. _tmpBg.max .. ")", "DermaDefault", ctr( 60 ), ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, ctr( 1 ), Color( 0, 0, 0, 255 ) )
						end
						_tmpBgUp = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height / 2 - 4 ), ctr( 2 ), ctr( 2 ) )
						_tmpBgUp:SetText( "" )
						function _tmpBgUp:Paint( pw, ph )
							if _tmpBg.cur < _tmpBg.max - 1 then
								surfaceButton(self, pw, ph, "↑")
							end
						end
						function _tmpBgUp:DoClick()
							if _tmpBg.cur < _tmpBg.max-1 then
								_tmpBg.cur = _tmpBg.cur + 1
							end
							net.Start( "inv_bg_up" )
								net.WriteInt( _tmpBg.cur, 16 )
								net.WriteInt( _tmpBg.id, 16 )
							net.SendToServer()
							_appe.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
						end

						_tmpBgDo = createD( "DButton", _tmpBg, ctr( 50 ), ctr( _height / 2 - 4 ), ctr( 2 ), ctr( _height / 2 - 2 ) )
						_tmpBgDo:SetText( "" )
						function _tmpBgDo:Paint( pw, ph )
							if _tmpBg.cur > 0 then
								surfaceButton( self, pw, ph, "↓" )
							end
						end
						function _tmpBgDo:DoClick()
							if _tmpBg.cur > 0 then
								_tmpBg.cur = _tmpBg.cur - 1
							end
							net.Start( "inv_bg_do" )
								net.WriteInt( _tmpBg.cur, 16 )
								net.WriteInt( _tmpBg.id, 16 )
							net.SendToServer()
							_appe.r.pm.Entity:SetBodygroup( _tmpBg.id, _tmpBg.cur )
						end
					end
				end
			end
		end
	else
		function _yrp_appearance.window:Paint( pw, ph )
			surfaceWindow( self, pw, ph, lang_string( "appearance" ) .. " - " .. lang_string( "menu" ) .. " [PROTOTYPE]" )
			local tab = {}
			tab.x = pw / 2
			tab.y = ph / 2
			tab.font = "mat1header"
			tab.text = "Role Has No Playermodel!"
			DrawText(tab)
		end
	end
end)

function toggleAppearanceMenu()
	if isNoMenuOpen() then
		open_appearance()
	else
		close_appearance()
	end
end

function close_appearance()
	if _yrp_appearance.window != nil then
		closeMenu()
		_yrp_appearance.window:Remove()
		if _yrp_appearance.drop_panel != nil then
			_yrp_appearance.drop_panel:Remove()
		end
		_yrp_appearance.window = nil
	end
end

net.Receive( "openAM", function( len )
	toggleAppearanceMenu()
end)

function open_appearance()
	openMenu()

	local ply = LocalPlayer()

	_yrp_appearance.window = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
	_yrp_appearance.window:SetTitle( "" )
	_yrp_appearance.window:Center()
	_yrp_appearance.window:SetDraggable( false )
	_yrp_appearance.window:ShowCloseButton( true )
	_yrp_appearance.window:SetSizable( true )
	function _yrp_appearance.window:OnClose()
		_yrp_appearance.window:Remove()
	end
	function _yrp_appearance.window:Paint( pw, ph )
		surfaceWindow( self, pw, ph, lang_string( "appearance" ) .. " - " .. lang_string( "menu" ) .. " [PROTOTYPE]" )
	end

	_yrp_appearance.left = createD( "DPanel", _yrp_appearance.window, BScrW(), ScrH() - ctr(50), 0, ctr(50) )
	function _yrp_appearance.left:Paint( pw, ph )
		--surfacePanel( self, pw, ph )
		--paintBr( pw, ph, Color( 255, 0, 0, 255 ))
	end

	if ply:GetNWBool( "bool_appearance_system", false ) then
		net.Start( "get_menu_bodygroups" )
		net.SendToServer()
	else
		function _yrp_appearance.left:Paint( pw, ph )
			surfacePanel( self, pw, ph, lang_string( "disabled" ) )
		end
	end

	_yrp_appearance.window:MakePopup()
end