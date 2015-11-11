local addon_name, addon_shared = ...

local LibStub = LibStub;
local Addon = LibStub("AceAddon-3.0"):NewAddon(addon_name, "AceEvent-3.0", "AceHook-3.0");
_G[addon_name] = Addon;

local GENDER_ID = UnitSex("player")-2;
local RACE_ID = select(2, UnitRace("player"));
if(RACE_ID == 25 or RACE_ID == 26) then RACE_ID = 24 end

local function GetCurrentResolutionSize()
	-- local resolutions		= { GetScreenResolutions() };
	-- return strsplit("x", resolutions[GetCurrentResolution()]);
	return GetScreenWidth(), GetScreenHeight();
end

function Addon:OnInitialize()
	local screen_width, screen_height = GetCurrentResolutionSize();
	
	SLASH_AVATAR1	= "/avatar";
	SLASH_AVATAR2	= "/av";
	SlashCmdList["AVATAR"] = function(command) Addon:ConsoleHandler(command); end
	
	local defaults = {
		profile = {
			enabled = true,
			alpha = 1,
			show = {
				weapon = true,
				armor = true,
				helm = true,
				tabard = true,
				shirt = true,
			},
			hideInCombat = false,
			
			facing = 0.0,
			frameStrata = "BACKGROUND",
			frameLevel = 0,
			
			gearLevel = 1,
			gearLevelAll = false,
			
			gearLevelPerItem = {
				[1] = 1,
				[3] = 1,
				[5] = 1,
				[6] = 1,
				[7] = 1,
				[8] = 1,
				[9] = 1,
				[10] = 1,
				[15] = 1,
			},
			
			position = {
				point = "CENTER",
				relativePoint = "CENTER",
				x = 0,
				y = 0,
			},
			size = {
				w = screen_height,
				h = screen_height,
			},
			
			light = {
				dya = 0,
				dza = -10,
				
				dx = 0.93,	-- Direct Position
				dy = -0.98,
				dz = -0.17,
				
				di = 0.8,	-- Direct Intensity
				dr = 1.0,	-- Direct Colors
				dg = 0.9,
				db = 0.8,
				
				ai = 0.65,	-- Ambient Intensity
				ar = 1.0,	-- Ambient Colors
				ag = 1.0,
				ab = 1.0,
			},
		}
	};
	
	self.db = LibStub("AceDB-3.0"):New("AvatarDB", defaults);
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged");
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged");
	
	Addon:UpdateLightDirection();
end

local factionIcons = {
	Alliance = [[|TInterface\BattlefieldFrame\Battleground-Alliance:16:16:0:0:32:32:4:26:4:27|t ]],
	Horde = [[|TInterface\BattlefieldFrame\Battleground-Horde:16:16:0:0:32:32:5:25:5:26|t ]],
}

Addon.RaceList = {
	[1] = factionIcons.Alliance.." Human",
	[3] = factionIcons.Alliance.." Dwarf",
	[4] = factionIcons.Alliance.." Night Elf",
	[7] = factionIcons.Alliance.." Gnome",
	[11] = factionIcons.Alliance.." Draenei",
	[22] = factionIcons.Alliance.." Worgen",
	[2] = factionIcons.Horde.." Orc",
	[5] = factionIcons.Horde.." Undead",
	[6] = factionIcons.Horde.." Tauren",
	[8] = factionIcons.Horde.." Troll",
	[10] = factionIcons.Horde.." Blood Elf",
	[9] = factionIcons.Horde.." Goblin",
	[24] = "Pandaren",
};

Addon.RaceIds = {
	["Human"] 		= 1,
	["Orc"] 		= 2,
	["Dwarf"] 		= 3,
	["NightElf"] 	= 4,
	["Scourge"]		= 5,
	["Tauren"] 		= 6,
	["Gnome"] 		= 7,
	["Troll"] 		= 8,
	["Goblin"] 		= 9,
	["BloodElf"] 	= 10,
	["Draenei"] 	= 11,
	["Worgen"] 		= 22,
	["Pandaren"] 	= 24,
};

Addon.Genders = {
	[0] = "Male",
	[1] = "Female",
};
	
Addon.Visual = {
	Race = Addon.RaceIds[RACE_ID],
	Gender = GENDER_ID,
};

function Addon:OnEnable()
	Addon:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	Addon:RegisterEvent("UNIT_MODEL_CHANGED");
	Addon:RegisterEvent("UNIT_MODEL_UPDATE");
	
	Addon:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	
	Addon:RegisterEvent("PLAYER_REGEN_DISABLED");
	Addon:RegisterEvent("PLAYER_REGEN_ENABLED");
	-- Addon:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	Addon:RegisterEvent("BARBER_SHOP_APPEARANCE_APPLIED", "RefreshAvatar");
	Addon:RegisterEvent("TRANSMOGRIFY_SUCCESS", "RefreshAvatar");
	
	Addon:RefreshAvatar();
end

function Addon:PLAYER_REGEN_DISABLED()
	if(Addon.db.profile.hideInCombat) then
		AvatarModelFrame.fadeout:Play();
		AvatarModelFrame.hiddenInCombat = true;
	end
end

function Addon:PLAYER_REGEN_ENABLED()
	if(AvatarModelFrame.hiddenInCombat) then
		AvatarModelFrame.fadein:Play();
		AvatarModelFrame.hiddenInCombat = false;
	end
end

function AvatarModelFrame_OnFadeInPlay()
	
end

function AvatarModelFrame_OnFadeOutFinished()
	
end

function Avatar_IsVisible()
	return Addon.db.profile.enabled and AvatarModelFrame and
		   AvatarModelFrame:IsShown() and not AvatarModelFrame.hiddenInCombat;
end

function Addon:OnDisable()
		
end

AVATAR_INSTRUCTIONS_TEXT = "|cffffc437Avatar Unlocked|r|n|nPan with Left Mouse|nResize with Right Mouse|nRotate with Mouse Wheel";
AVATAR_INSTRUCTIONS_LOCK = "Lock Avatar Model";

function AvatarModelFrame_Lock(self)
	Addon:LockFrame();
end

function AvatarModelFrame_OnLoad(self)
	local screen_width, screen_height = GetCurrentResolutionSize();
	self:SetMinResize(screen_height * 0.05, screen_height * 0.05);
	self:SetMaxResize(screen_height * 2.0, screen_height * 2.0);
	
	self:EnableMouse(false);
	self:EnableMouseWheel(false);
	
	self:RegisterForDrag("LeftButton", "RightButton");
	self:SetMovable(true);
	self:SetResizable(true);
end

function AvatarModelFrame_OnMouseWheel(self, delta)
	local multiplier = IsControlKeyDown() and 0.3 or 0.15;
	self:SetFacing(self:GetFacing() + delta * multiplier);
	Addon.db.profile.facing = self:GetFacing();
end

function AvatarModelFrame_OnMouseUp(self, button)
	self:StopMovingOrSizing();
	Addon:SavePosition();
end

function AvatarModelFrame_OnMouseDown(self, button)
	if (button == "LeftButton") then
		self:StartMoving();
		
	elseif (button == "RightButton") then
		self:StartSizing();
	end
end

function AvatarModelFrame_OnShow(self)
	Addon:UpdateRace();
	Addon:RefreshEquipmentToggle();
end

function AvatarModelFrame_OnHide(self)
	self:StopMovingOrSizing();
end

-- ANIM_ID = 97;
-- ANIM_MAX = 1750;
-- ANIM_SPEED = 1;

-- ANIM_ENABLE = 2;

local AnimFrame = 0;
function AvatarModelFrame_OnUpdate(self, elapsed)
	if(not Addon.db.profile.enabled) then return end
	
	-- AnimFrame = AnimFrame + 1000 * elapsed * ANIM_SPEED;
	-- if(AnimFrame >= ANIM_MAX) then AnimFrame = 0 end
	
	-- if(ANIM_ENABLE == 1) then
	-- 	AvatarModelFrame:SetSequenceTime(ANIM_ID, AnimFrame);
	-- elseif(ANIM_ENABLE == 2) then
	-- 	AvatarModelFrame:SetSequence(ANIM_ID);
	-- end
end


function Addon:UpdateLightDirection()
	local l = self.db.profile.light;
	
	local ya = l.dya * (math.pi / 180.0);
	local za = l.dza * (math.pi / 180.0);
	
	ya = -ya + math.pi;
	
	l.dx = math.cos(ya) * math.cos(za);
	l.dy = math.sin(ya) * math.sin(za);
	l.dz = math.sin(za);
	
	local nl = sqrt((l.dx * l.dx) + (l.dy * l.dy) + (l.dz * l.dz));
	l.dx = l.dx / nl;
	l.dy = l.dy / nl;
	l.dz = l.dz / nl;
end

function Addon:SetFrameSettings()
	if(Addon.db.profile.enabled) then
		AvatarModelFrame:Show();
	else
		AvatarModelFrame:Hide();
	end
	
	AvatarModelFrame:ClearAllPoints();
	AvatarModelFrame:SetPoint(self.db.profile.position.point, UIParent, self.db.profile.position.relativePoint, self.db.profile.position.x, self.db.profile.position.y);
	AvatarModelFrame:SetFrameStrata(self.db.profile.frameStrata);
	AvatarModelFrame:SetFrameLevel(self.db.profile.frameLevel);
	
	AvatarModelFrame:SetWidth(self.db.profile.size.w);
	AvatarModelFrame:SetHeight(self.db.profile.size.h);
	AvatarModelFrame:SetFacing(self.db.profile.facing);
	AvatarModelFrame:SetAlpha(self.db.profile.alpha);
	
	Addon:UpdateAnimationAlphas();
	
	Addon:UpdateLightDirection();
	
	local l = self.db.profile.light;
	AvatarModelFrame:SetLight(1, 0,
		l.dx, l.dy, l.dz,
		l.ai, l.ar, l.ag, l.ab,
		l.di, l.dr, l.dg, l.db
	);
end

function Addon:UpdateAnimationAlphas()
	local fadein = AvatarModelFrame.fadein:GetAnimations();
	fadein:SetToAlpha(Addon.db.profile.alpha);
	
	local fadeout = AvatarModelFrame.fadeout:GetAnimations();
	fadeout:SetFromAlpha(Addon.db.profile.alpha);
end

function Addon:RefreshAvatar()
	AvatarModelFrame:SetUnit("player");
	Addon:UpdateRace();
	
	Addon:RefreshFrame();
end

function Addon:RefreshFrame()
	Addon:SetFrameSettings();
	Addon:RefreshEquipmentToggle();
end

-- 1 - Human
-- 2 - Orc
-- 3 - Dwarf
-- 4 - Nightelf
-- 5 - Undead
-- 6 - Tauren
-- 7 - Gnome
-- 8 - Troll
-- 9 - Goblin
-- 10 - Bloodelf
-- 11 - Draenei
-- 22 - Worgen
-- 24 - Pandaren
-- 25 - Alliance Pandaren
-- 26 - Horde Pandaren

function Addon:UpdateRace()
	AvatarModelFrame:SetCustomRace(Addon.Visual.Race, Addon.Visual.Gender);
	Addon:RefreshEquipmentToggle();
	Addon:UpdateAvatarPositioning();
end

local RACE_POSITIONS = {
	-- Default
	[0]		= {-0.65, 0.01, -0.05},

	-- Orc
	[2]		= {
		[0]	= {-1.15, 0.04, -0.1},
	},
	
	-- Dwarf
	[3]		= {
		[0]	= {-0.65, 0.0, -0.15},
		[1]	= {-0.65, -0.03, -0.03},
	},
	
	-- Tauren
	[6]		= {
		[0]	= {-0.75, 0.02, -0.15},
		[1]	= {-0.8, 0.01, -0.18},
	},
	
	-- Gnome
	[7]		= {
		[0]	= {-0.86, -0.03, -0.12},
		[1]	= {-0.86, -0.03, -0.12},
	},
	
	-- Troll
	[8]		= {
		[0]	= {-1.4, 0.02, -0.14},
	},
	
	-- Goblin
	[9]		= {
		[0]	= {-1.10, -0.02, -0.12},
		[1]	= {-1.2, -0.04, -0.13},
	},
	
	-- Blood elf
	[10]	= {
		[0]	= {-0.65, -0.02, 0.02},
		[1]	= {-0.65, 0.04, -0.02},
	},
	
	-- Draenei
	[11]	= {
		[0]	= {-0.95, 0.04, -0.12},
		[1]	= {-0.35, -0.04, -0.05},
	},
	
	-- Worgen
	[22]	= {
		[0]	= {-0.95, -0.05, -0.12},
		[1]	= {0.0, -0.06, -0.05},
	},
	
	-- Panda
	[24]	= {
		[0]	= {-0.8, 0.04, 0},
		[1]	= {-1.15, 0.02, 0},
	},
};

function Addon:UpdateAvatarPositioning()
	local position = RACE_POSITIONS[0];
	
	if(RACE_POSITIONS[Addon.Visual.Race] and RACE_POSITIONS[Addon.Visual.Race][Addon.Visual.Gender]) then
		position = RACE_POSITIONS[Addon.Visual.Race][Addon.Visual.Gender];
	end
	
	AvatarModelFrame:SetPosition(unpack(position));
end

function Addon:SetRace(id, sex)
	AvatarModelFrame:SetCustomRace(id, sex);
	Addon:RefreshEquipmentToggle();
end

-- Head 		1
-- Shoulder 	3
-- Shirt 		4
-- Chest 		5
-- Belt 		6
-- Legs 		7
-- Feet 		8
-- Wrist 		9
-- Gloves 		10
-- Back 		15
-- Main Hand 	16
-- Off Hand 	17
-- Tabard 		19 

function Addon:RefreshEquipmentToggle()
	if(not self.db.profile.show.weapon and not self.db.profile.show.armor and not self.db.profile.show.tabard and not self.db.profile.show.shirt) then
		Addon:Dress();
		AvatarModelFrame:Undress();
		
	else
		Addon:Dress();
						
		if(not self.db.profile.show.armor) then
			AvatarModelFrame:UndressSlot(1);
			AvatarModelFrame:UndressSlot(3);
			AvatarModelFrame:UndressSlot(4);
			AvatarModelFrame:UndressSlot(5);
			AvatarModelFrame:UndressSlot(6);
			AvatarModelFrame:UndressSlot(7);
			AvatarModelFrame:UndressSlot(8);
			AvatarModelFrame:UndressSlot(9);
			AvatarModelFrame:UndressSlot(10);
			AvatarModelFrame:UndressSlot(15);
		end
		
		if(not ShowingHelm() or not self.db.profile.show.helm) then
			AvatarModelFrame:UndressSlot(1);
		end
		
		if(not ShowingCloak()) then
			AvatarModelFrame:UndressSlot(15);
		end
			
		if(not self.db.profile.show.tabard) then
			AvatarModelFrame:UndressSlot(19);
		end
			
		if(not self.db.profile.show.shirt) then
			AvatarModelFrame:UndressSlot(4);
		end
	end
	
	Addon:UpdateConditionalToggle();
end

function Addon:PlayerHasAura(spell_id)
	for aura_id = 1, 40 do
		if(select(11, UnitAura("player", aura_id)) == spell_id) then
			return true
		end
	end
	
	return false
end

function Addon:UpdateConditionalToggle()
	if(Addon:PlayerHasAura(176438)) then
		AvatarModelFrame:Undress();
	end
end

function Addon:Dress()
	AvatarModelFrame:Undress();
	
	for slot_id = 1, 19 do
		local item_id = GetInventoryItemID("player", slot_id);
		local item_link = GetInventoryItemLink("player", slot_id);
		
		if(item_id) then
			local item;
			
			local transmogged, visible_id, _ = nil, nil;
			if(Addon:IsSlotTransmoggable(slot_id)) then
				transmogged, _, _, _, _, visible_id = GetTransmogrifySlotInfo(slot_id);
			end
			
			local gear_level = Addon.db.profile.gearLevel;
			if(Addon.db.profile.gearLevelPerItem[slot_id] ~= 1) then
				gear_level = Addon.db.profile.gearLevelPerItem[slot_id];
			end
			
			if(not transmogged and (not Addon:IsSlotTransmoggable(slot_id) or gear_level == 1 or not Addon.db.profile.gearLevelAll)) then
				item = item_link;
			else
				if(gear_level ~= 6) then
					item = Addon:GetGearLeveledItemString(gear_level, visible_id);
				end
			end
			
			if(item) then
				AvatarModelFrame:TryOn(item);
			else
				AvatarModelFrame:UndressSlot(slot_id);
			end
		end
	end
	
	AvatarModelFrame:UndressSlot(16);
	AvatarModelFrame:UndressSlot(17);
end

local gearLevelBonusID = {
	[1] = nil,
	[2] = {451, nil},
	[3] = nil,
	[4] = {449, 566},
	[5] = {450, 567},
}

function Addon:GetGearLeveledItemString(gear_level, item_id)
	if(not item_id) then return nil end
	
	local bonusIDs = gearLevelBonusID[gear_level];
	
	if(bonusIDs ~= nil) then
		local _, _, _, item_level = GetItemInfo(item_id)
		
		local index = 1;
		if(item_level and item_level >= 640) then
			index = 2;
		end
		
		local bonusID = bonusIDs[index];
	
		if(bonusID ~= nil) then
			return string.format("item:%d:0:0:0:0:0:0:0:%d:0:0:0:1:%d", item_id, UnitLevel("player"), bonusID);
		end
	end
	
	return string.format("item:%d", item_id);
end