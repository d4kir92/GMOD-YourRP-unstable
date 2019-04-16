--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("Connect_Settings_Console", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_Console")
			net.SendToServer()
		end

		PARENT.consolebackground = createD("DPanel", PARENT, ctr(1000), ScrH() - ctr(140), ctr(20), ctr(20))

		PARENT.console = createD("RichText", PARENT.consolebackground, ctr(1000), ScrH() - ctr(140) - ctr(50), 0, 0)
		PARENT.console:SetFontInternal("Roboto18B")
		PARENT.console:InsertColorChange(0, 0, 0, 255)

		PARENT.consoletext = createD("DTextEntry", PARENT.consolebackground, ctr(1000), ctr(50), 0, ScrH() - ctr(140) - ctr(50))
		function PARENT.consoletext:OnEnter()
			net.Start("send_console_command")
				net.WriteString(self:GetText())
			net.SendToServer()
			self:SetText("")
			self:RequestFocus()
		end
	end
end)

net.Receive("get_console_line", function(len)
	local str = net.ReadString()
	if pa(settingsWindow) and pa(settingsWindow.window.site.console) then
		settingsWindow.window.site.console:AppendText(str)
		settingsWindow.window.site.console:AppendText("\n")
	end
end)

hook.Add("open_server_console", "open_server_console", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_Console")
	net.SendToServer()
end)
