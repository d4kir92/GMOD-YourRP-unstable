--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("YFramePaint", "YFrame_Simple", function(self, pw, ph)
	local lply = LocalPlayer()
	if lply:GetNWString("string_interface_design") == "Simple" then
		draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), lply:InterfaceValue("YFrame", "HB"))

		draw.RoundedBox(0, 0, self:GetHeaderHeight(), pw, ph - self:GetHeaderHeight(), lply:InterfaceValue("YFrame", "BG"))

		draw.SimpleText(YRP.lang_string(self:GetTitle()), "Roboto18", self:GetHeaderHeight() / 4, self:GetHeaderHeight() / 2, lply:InterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return true
	end
end)

hook.Add("YButtonPaint", "YButton_Simple", function(self, pw, ph)
	local lply = LocalPlayer()
	if lply:GetNWString("string_interface_design") == "Simple" then
		local color = lply:InterfaceValue("YButton", "NC")
		local tcolor = lply:InterfaceValue("YButton", "NT")
		if self:IsDown() then
			color = lply:InterfaceValue("YButton", "SC")
			tcolor = lply:InterfaceValue("YButton", "ST")
		elseif self:IsHovered() then
			color = lply:InterfaceValue("YButton", "HC")
			tcolor = lply:InterfaceValue("YButton", "HT")
		end
		draw.RoundedBox(0, 0, 0, pw, ph, Color(color.r, color.g, color.b, 255))

		draw.SimpleText(YRP.lang_string(self:GetText()), "Roboto18", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end
end)