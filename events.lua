local addon_name = ...

local LibStub = LibStub;
local Addon = LibStub("AceAddon-3.0"):GetAddon(addon_name);

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

local SLOT_TYPE_WEAPON			= 0x01;
local SLOT_TYPE_ARMOR			= 0x02;
local SLOT_TYPE_TABARD			= 0x04;
local SLOT_TYPE_UNTRANSMOGGABLE	= 0x08;

local INVENTORY_SLOTS = {
	[1]		= SLOT_TYPE_ARMOR,
	[3]		= SLOT_TYPE_ARMOR,
	[4]		= SLOT_TYPE_ARMOR, -- Shirt
	[5]		= SLOT_TYPE_ARMOR,
	[6]		= SLOT_TYPE_ARMOR,
	[7]		= SLOT_TYPE_ARMOR,
	[8]		= SLOT_TYPE_ARMOR,
	[9]		= SLOT_TYPE_ARMOR,
	[10]	= SLOT_TYPE_ARMOR,
	[15]	= SLOT_TYPE_ARMOR,
	[16]	= SLOT_TYPE_WEAPON,
	[17]	= SLOT_TYPE_WEAPON,
	[19]	= SLOT_TYPE_TABARD,
};

function Addon:IsWeaponSlot(slot)
	return slot and INVENTORY_SLOTS[slot] == SLOT_TYPE_WEAPON;
end

function Addon:IsArmorSlot(slot)
	return slot and INVENTORY_SLOTS[slot] == SLOT_TYPE_ARMOR;
end

function Addon:IsTabardSlot(slot)
	return slot and INVENTORY_SLOTS[slot] == SLOT_TYPE_TABARD;
end

function Addon:IsSlotVisible(slot)
	return Addon:IsWeaponSlot(slot) or Addon:IsArmorSlot(slot) or Addon:IsTabardSlot(slot);
end

function Addon:IsSlotTransmoggable(slot)
	return slot and INVENTORY_SLOTS[slot] and bit.band(INVENTORY_SLOTS[slot], SLOT_TYPE_UNTRANSMOGGABLE) == 0;
end

function Addon:PLAYER_EQUIPMENT_CHANGED(event, slot_id, hasItem)
	if(hasItem) then
		if(slot_id == 1 and not Addon:ShowingHelm()) then return end
		if(slot_id == 15 and not Addon:ShowingCloak()) then return end
		if(slot_id == 3 and not Addon:ShowingShoulders()) then return end
		
		if(Addon:IsArmorSlot(slot_id) and not self.db.profile.show.armor) then return end
		
		if(Addon:IsWeaponSlot(slot_id) and not self.db.profile.show.weapon) then return end
		if(Addon:IsTabardSlot(slot_id) and not self.db.profile.show.tabard) then return end
		
		Addon:UpdateItemSlot(slot_id);
	else
		AvatarModelFrame:UndressSlot(slot_id);
	end
end

function Addon:UNIT_AURA(event, unit_id)
	if(unit_id == "player") then
		Addon:UpdateConditionalToggle();
	end
end

function Addon:UNIT_PORTRAIT_UPDATE(event, unit)
	if(unit == "player") then
		Addon:RefreshEquipmentToggle();
	end
end

function Addon:UNIT_MODEL_CHANGED(event, unit, ...)
	if(unit == "player") then
		-- Addon:RefreshAvatar();
	end
end
	
function Addon:UNIT_MODEL_UPDATE(event, ...)
	-- Addon:RefreshAvatar();
end