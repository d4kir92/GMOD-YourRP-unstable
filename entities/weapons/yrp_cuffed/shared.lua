
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Weapon"

SWEP.PrintName = "Handcuffed"
SWEP.Language = "en"
SWEP.LanguageString = "LID_handcuffed"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.notdropable = true

SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = false

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = true

SWEP.HoldType = "duel"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.delay = CurTime()
	self.hp = 30
end

function SWEP:Reload()

end

function SWEP:Think()
	if SERVER and CurTime() > self.delay then
		self.delay = CurTime() + 0.3

		self.hp = self.hp + 1
		if self.hp > 30 then
			self.hp = 30
		end

		self.Owner:ShowStatus("befreien", 30 - self.hp, 30)
	end
end

function SWEP:DestroyCuffs()
	self.Owner:InteruptCasting()
	self.Owner:SelectWeapon("yrp_unarmed")
	self:Remove()
end

function SWEP:LowerHP()
	if SERVER then
		self.Owner:ShowStatus("befreien", 30 - self.hp, 30)
		self.hp = self.hp - 1
		if self.hp <= 0 then
			self:DestroyCuffs()
		end
	end
end

local _target
function SWEP:PrimaryAttack()
	self:LowerHP()
end

function SWEP:SecondaryAttack()

end
