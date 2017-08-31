local addon_name, addon_shared = ...

local _G = getfenv(0);
local Addon = _G[addon_name];

local frameStrataOptions = {
	[1] = "BACKGROUND",
	[2] = "LOW",
	[3] = "MEDIUM",
	[4] = "HIGH",
	[5] = "DIALOG",
	[6] = "FULLSCREEN",
	[7] = "FULLSCREEN_DIALOG",
	[8] = "TOOLTIP",
};

local frameStrataNums = {
	["BACKGROUND"] 			= 1,
	["LOW"] 				= 2,
	["MEDIUM"] 				= 3,
	["HIGH"] 				= 4,
	["DIALOG"] 				= 5,
	["FULLSCREEN"] 			= 6,
	["FULLSCREEN_DIALOG"] 	= 7,
	["TOOLTIP"] 			= 8,
};

local gearLevelOptions = {
	[1] = "Disabled",
	[2] = "Raid Finder",
	[3] = "Normal",
	[4] = "Heroic",
	[5] = "Mythic",
};

local gearLevelSingleOptions = {
	[1] = "Use Global Option",
	[2] = "Raid Finder",
	[3] = "Normal",
	[4] = "Heroic",
	[5] = "Mythic",
	[6] = "Hide Item",
};

local avatarOptions = {
	type = "group",
	name = "Avatar",
	desc = "Avatar Options",
	args = {
		unlock = {
			type = "execute",
			order = 0,
			name = "Unlock Avatar",
			desc = "Unlock Avatar frame to move it around",
			width = "double",
			func = function()
				Addon:UnlockFrame();
				Addon:CloseOptions();
			end,
		},
		enabled = {
			type = "toggle",
			order = 1,
			name = "Enable Avatar",
			desc = "Toggle Avatar on or off",
			set = function(info, value) Addon.db.profile.enabled = value; Addon:RefreshFrame(); end,
			get = function(info) return Addon.db.profile.enabled; end,
		},
		
		general_group = {
			type = "group",
			name = "General",
			desc = "General Options",
			inline = true,
			order = 10,
			args = {
				-- toggle_weapon = {
				-- 	type = "toggle",
				-- 	order = 0,
				-- 	name = "Show Weapon(s)",
				-- 	desc = "Showing weapons on the Avatar",
				-- 	set = function(into, value) Addon.db.profile.show.weapon = value; Addon:RefreshFrame(); end,
				-- 	get = function(info) return Addon.db.profile.show.weapon; end,
				-- },
				toggle_armor = {
					type = "toggle",
					order = 5,
					name = "Show Armor",
					desc = "Showing armor on the Avatar",
					set = function(into, value) Addon.db.profile.show.armor = value; Addon:RefreshFrame(); end,
					get = function(info) return Addon.db.profile.show.armor; end,
				},
				toggle_tabard = {
					type = "toggle",
					order = 7,
					name = "Show Tabard",
					desc = "Showing tabard on the Avatar",
					set = function(into, value) Addon.db.profile.show.tabard = value; Addon:RefreshFrame(); end,
					get = function(info) return Addon.db.profile.show.tabard; end,
				},
				toggle_shirt = {
					type = "toggle",
					order = 7,
					name = "Show Shirt",
					desc = "Showing shirt on the Avatar",
					set = function(into, value) Addon.db.profile.show.shirt = value; Addon:RefreshFrame(); end,
					get = function(info) return Addon.db.profile.show.shirt; end,
				},
				toggle_helm = {
					type = "toggle",
					order = 10,
					name = "Always Hide Helm",
					desc = "Always hide helm on Avatar regardless if it's displayed on character",
					set = function(into, value) Addon.db.profile.show.helm = not value; Addon:RefreshFrame(); end,
					get = function(info) return not Addon.db.profile.show.helm; end,
				},
				
				alpha_slider = {
					type = "range",
					order = 15,
					name = "Avatar Alpha",
					desc = "Change Avatar opacity",
					min = 0,
					max = 1.0,
					step = 0.02,
					bigStep = 0.02,
					isPercent = true,
					width = "full",
					set = function(into, value) Addon.db.profile.alpha = value; Addon:SetFrameSettings(); end,
					get = function(info) return Addon.db.profile.alpha; end,
				},
			},
		},
		
		position_group = {
			type = "group",
			name = "Frame Settings",
			desc = "Frame Settings",
			inline = true,
			order = 20,
			args = {
				anchor_point = {
					type = "input",
					order = 0,
					name = "Point",
					desc = "Primary anchor point",
					width = "half",
					set = function(info, value) Addon.db.profile.position.point = value; Addon:SetFrameSettings(); end,
					get = function(info) return Addon.db.profile.position.point; end,
				},
				anchor_relative_point = {
					type = "input",
					order = 5,
					name = "Relative To",
					desc = "The point Avatar is relative to",
					width = "half",
					set = function(info, value) Addon.db.profile.position.relativePoint = value; Addon:SetFrameSettings(); end,
					get = function(info) return Addon.db.profile.position.relativePoint; end,
				},
				position_x = {
					type = "input",
					order = 10,
					name = "Position X",
					desc = "Avatar X position offset",
					width = "half",
					set = function(info, value) Addon.db.profile.position.x = tonumber(value) or 0; Addon:SetFrameSettings(); end,
					get = function(info) return tostring(Addon.db.profile.position.x); end,
				},
				position_y = {
					type = "input",
					order = 15,
					name = "Position Y",
					desc = "Avatar Y position offset",
					width = "half",
					set = function(info, value) Addon.db.profile.position.y = tonumber(value) or 0; Addon:SetFrameSettings(); end,
					get = function(info) return tostring(Addon.db.profile.position.y); end,
				},
				
				frame_width = {
					type = "input",
					order = 20,
					name = "Frame Width",
					desc = "Avatar frame width",
					width = "half",
					set = function(info, value) Addon.db.profile.size.w = tonumber(value) or 0; Addon:SetFrameSettings(); end,
					get = function(info) return tostring(Addon.db.profile.size.w); end,
				},
				frame_height = {
					type = "input",
					order = 25,
					name = "Frame Height",
					desc = "Avatar frame height",
					width = "half",
					set = function(info, value) Addon.db.profile.size.h = tonumber(value) or 0; Addon:SetFrameSettings(); end,
					get = function(info) return tostring(Addon.db.profile.size.h); end,
				},
				
				framestrata_dropdown = {
					type = "select",
					name = "Frame Strata",
					desc = "Change the frame's layer",
					style = "dropdown",
					values = function() return frameStrataOptions; end,
					set = function(info, value) Addon.db.profile.frameStrata = frameStrataOptions[value]; Addon:SetFrameSettings(); end,
					get = function(info) return frameStrataNums[Addon.db.profile.frameStrata]; end,
					order = 30,
				},
				framelevel_slider = {
					type = "range",
					order = 35,
					name = "Frame Level",
					desc = "Change the frame's relative level compared to other frames in the same layer",
					min = 0,
					softMax = 20,
					max = 100,
					step = 1,
					set = function(into, value) Addon.db.profile.frameLevel = value; Addon:SetFrameSettings(); end,
					get = function(info) return Addon.db.profile.frameLevel; end,
				},
			},
		},
		
		facing_group = {
			type = "group",
			name = "Miscellaneous Avatar Options",
			desc = "Miscellaneous Avatar Options",
			inline = true,
			order = 22,
			args = {
				facing_slider = {
					type = "range",
					order = 1,
					name = "Avatar Facing (degrees)",
					desc = "The direction the Avatar character is facing in degrees",
					min = -180,
					max = 180,
					step = 1,
					bigStep = 1,
					width = "double",
					set = function(info, value) Addon.db.profile.facing = (tonumber(value) or 0) * (math.pi / 180.0); Addon:SetFrameSettings(); end,
					get = function(info) return Addon.db.profile.facing * (180.0 / math.pi); end,
				},
				hide_in_combat_toggle = {
					type = "toggle",
					order = 5,
					name = "Hide Avatar in Combat",
					desc = "Avatar will be hidden during combat.",
					set = function(into, value) Addon.db.profile.hideInCombat = value; end,
					get = function(info) return Addon.db.profile.hideInCombat; end,
				},
			},
		},
		
		lighting_group = {
			type = "group",
			name = "Lighting",
			desc = "Lighting",
			inline = true,
			order = 30,
			args = {
				dya_slider = {
					type = "range",
					order = 1,
					name = "Light Direction Yaw",
					desc = "Direct Light Direction Yaw",
					min = -180,
					max = 180,
					step = 1,
					width = "normal",
					set = function(info, value) Addon.db.profile.light.dya = value; Addon:UpdateLightDirection(); Addon:SetFrameSettings() end,
					get = function(info) return Addon.db.profile.light.dya end,
				},
				dza_slider = {
					type = "range",
					order = 2,
					name = "Light Direction Pitch",
					desc = "Direct Light Direction Pitch",
					min = -180,
					max = 180,
					step = 1,
					width = "normal",
					set = function(info, value) Addon.db.profile.light.dza = value; Addon:UpdateLightDirection(); Addon:SetFrameSettings() end,
					get = function(info) return Addon.db.profile.light.dza end,
				},
				
				di_slider = {
					type = "range",
					order = 5,
					name = "Direct Light Intensity",
					desc = "Direct Light Intensity",
					min = 0,
					max = 1,
					step = 0.01,
					width = "normal",
					set = function(info, value) Addon.db.profile.light.di = value; Addon:SetFrameSettings() end,
					get = function(info) return Addon.db.profile.light.di end,
				},
				dc_slider = {
					type = "color",
					order = 10,
					name = "Direct Light Color",
					desc = "Direct Light Color",
					hasAlpha = false,
					width = "normal",
					set = function(info, r, g, b)
						Addon.db.profile.light.dr = r;
						Addon.db.profile.light.dg = g;
						Addon.db.profile.light.db = b;
						Addon:SetFrameSettings();
					end,
					get = function(info) return Addon.db.profile.light.dr, Addon.db.profile.light.dg, Addon.db.profile.light.db, 1.0 end,
				},
				ai_slider = {
					type = "range",
					order = 15,
					name = "Ambient Light Intensity",
					desc = "Ambient Light Intensity",
					min = 0,
					max = 1,
					step = 0.01,
					width = "normal",
					set = function(info, value) Addon.db.profile.light.ai = value; Addon:SetFrameSettings() end,
					get = function(info) return Addon.db.profile.light.ai end,
				},
				ac_slider = {
					type = "color",
					order = 20,
					name = "Ambient Light Color",
					desc = "Ambient Light Color",
					hasAlpha = false,
					width = "normal",
					set = function(info, r, g, b)
						Addon.db.profile.light.ar = r;
						Addon.db.profile.light.ag = g;
						Addon.db.profile.light.ab = b;
						Addon:SetFrameSettings();
					end,
					get = function(info) return Addon.db.profile.light.ar, Addon.db.profile.light.ag, Addon.db.profile.light.ab, 1.0 end,
				},
			},
		},
		
		race_group = {
			type = "group",
			name = "Change Visual Race and Gender (experimental, only works for this session)",
			desc = "Change Visual Race and Gender",
			inline = true,
			order = 40,
			args = {
				race_dropdown = {
					type = "select",
					name = "Avatar Race",
					desc = "Select Visual Race",
					style = "dropdown",
					values = function() return Addon.RaceList; end,
					set = function(info, value) Addon.Visual.Race = value; Addon:UpdateRace(); end,
					get = function(info) return Addon.Visual.Race; end,
					order = 0,
				},
				gender_dropdown = {
					type = "select",
					name = "Avatar Gender",
					desc = "Select Visual Gender",
					style = "dropdown",
					values = function() return Addon.Genders; end,
					set = function(info, value) Addon.Visual.Gender = value; Addon:UpdateRace(); end,
					get = function(info) return Addon.Visual.Gender; end,
					order = 10,
				},
			},
		},
		
		profile_group = {
			type = "group",
			name = "Avatar Profile",
			desc = "Avatar Profile",
			inline = true,
			order = 50,
			args = {
				use_global = {
					type = "toggle",
					order = 0,
					name = "Use Global Profile",
					desc = "Make Avatar use a global profile shared between all characters",
					width = "full",
					set = function(info, value) Addon:ToggleGlobalProfile(value); end,
					get = function(info) return Addon.db:GetCurrentProfile() == "Global Profile"; end,
				},
				
				profiles_dropdown = {
					type = "select",
					name = "Choose Profile",
					desc = "Select which settings profile to use",
					style = "dropdown",
					values = function() return Addon:GetProfiles() end,
					set = function(info, value) Addon:ChangeProfile(value) end,
					get = function(info) return Addon:GetCurrentProfileKey() end,
				},
				
				copy_profile_dropdown = {
					type = "select",
					name = "Copy Profile",
					desc = "Select which profile settings to copy over to the current profile",
					style = "dropdown",
					values = function() return Addon:GetProfiles(true) end,
					set = function(info, value) Addon:CopyProfile(value) end,
					get = function(info) return 0 end,
				},
				
				delete_profile_dropdown = {
					type = "select",
					name = "Delete Profile",
					desc = "Select a profile to delete",
					style = "dropdown",
					values = function() return Addon:GetProfiles() end,
					set = function(info, value) Addon:DeleteProfile(value) end,
					get = function(info) return 0 end,
				},
			},
		},
	},
};

local AVATAR_DELETE_PROFILE = nil;

StaticPopupDialogs["AVATAR_DELETE_PROFILE_CONFIRM"] = {
	text = "Are you sure you want to delete profile %s?",
	button1 = YES,
	button2 = NO,
	sound = "igMainMenuOpen",
	OnShow = function(self, data)
		Addon:CloseOptions()
	end,
	OnAccept = function(self)
		Addon.db:DeleteProfile(AVATAR_DELETE_PROFILE);
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Deleted profile " .. AVATAR_DELETE_PROFILE .. ".");
	end,
	OnCancel = function(self)
	end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};

function Addon:GetProfiles(include_global, include_current)
	include_global = include_global or false;
	include_current = include_current or true;
	
	local currentProfile = self.db:GetCurrentProfile();
	local profiles = self.db:GetProfiles();
	local listProfiles = {};
	local currentProfileKey = 0;
	
	for key, value in pairs(profiles) do
		if(value ~= "Global Profile" and value == currentProfile) then
			currentProfileKey = key;
		end
		
		if(value ~= "Global Profile" or include_global) then
			listProfiles[key] = value;
		end
	end
	
	if(not include_current) then
		listProfiles[currentProfileKey] = nil;
	end
	
	self.currentProfileKey = currentProfileKey;
	
	return listProfiles;
end

function Addon:GetCurrentProfileKey()
	if(not Addon.currentProfileKey) then
		Addon:GetProfiles();
	end
	
	return Addon.currentProfileKey;
end

function Addon:DeleteProfile(profile_key)
	local profiles = Addon:GetProfiles(false, false);
	
	AVATAR_DELETE_PROFILE = profiles[profile_key];
	StaticPopup_Show("AVATAR_DELETE_PROFILE_CONFIRM", AVATAR_DELETE_PROFILE);
end

function Addon:CopyProfile(profile_key)
	local profiles = Addon:GetProfiles(true);
	
	self.db:CopyProfile(profiles[profile_key]);
	DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Copied profile " .. profiles[profile_key] .. ".");
end

function Addon:ChangeProfile(profile_key)
	local profiles = Addon:GetProfiles();
	
	DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Using profile " .. profiles[profile_key] .. ".");
	self.db:SetProfile(profiles[profile_key]);
	
	Addon.currentProfileKey = profile_key;
end

function Addon:CloseOptions()
	LibStub("AceConfigDialog-3.0"):Close("Avatar");
	GameTooltip:Hide();
end

function Addon:LoadOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Avatar", avatarOptions);
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Avatar", "Avatar", nil);
end

Addon:LoadOptions();

function Addon:ShowOptions()
	Addon:LockFrame();
	
	local dialog = LibStub("AceConfigDialog-3.0");
	dialog:SetDefaultSize("Avatar", 590, 650);
	dialog:Open("Avatar");
end

function Addon:OnProfileChanged()
	Addon:RefreshAvatar();
end

function Addon:ToggleGlobalProfile(toggle)
	if(toggle) then
		
		local currentProfile = self.db:GetCurrentProfile();
		
		local globalExists = false;
		
		for key, value in pairs(self.db:GetProfiles()) do
			if(value == "Global Profile") then
				globalExists = true;
				break;
			end
		end
		
		self.db:SetProfile("Global Profile");
		
		-- If a Global Profile profile doesn't exists yet we can copy from the current character's profile
		if(not globalExists) then
			self.db:CopyProfile(currentProfile, true);
		end
		
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Using Global Profile profile.");
		
	else
		
		local name = UnitName("player");
		local realm = GetRealmName();
		local profileName = name .. " - " .. realm;
		self.db:SetProfile(profileName);
		
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Using profile " .. profileName .. ".");
		
	end
	
	Addon:RefreshAvatar(true);
	
end

function Addon:LockFrame()
	if(not Addon.FrameUnlocked) then return end
	
	AvatarModelFrame:SetFrameStrata(self.db.profile.frameStrata);
	AvatarModelFrame:SetFrameLevel(self.db.profile.frameLevel);
	AvatarModelFrame:EnableMouse(false);
	AvatarModelFrame:EnableMouseWheel(false);
	
	AvatarModelFrameBackdrop:Hide();
	AvatarInstructionsFrame:Hide();
	
	Addon.FrameUnlocked = false;
end

function Addon:SavePosition()
	local point, _, relativePoint, x, y = AvatarModelFrame:GetPoint();
	Addon.db.profile.position.point = point;
	Addon.db.profile.position.relativePoint = relativePoint;
	Addon.db.profile.position.x = tonumber(string.format("%.2f", x));
	Addon.db.profile.position.y = tonumber(string.format("%.2f", y));
	
	local w, h = AvatarModelFrame:GetSize();
	Addon.db.profile.size.w = tonumber(string.format("%.2f", w));
	Addon.db.profile.size.h = tonumber(string.format("%.2f", h));
	
	Addon.db.profile.facing = AvatarModelFrame:GetFacing();
end

function Addon:UnlockFrame()
	if(Addon.FrameUnlocked) then return end
	
	if(not self.db.profile.enabled) then
		self.db.profile.enabled = true;
		Addon:RefreshAvatar();
	end
	
	AvatarModelFrame:SetFrameStrata("FULLSCREEN");
	AvatarModelFrame:EnableMouse(true);
	AvatarModelFrame:EnableMouseWheel(true);
	
	AvatarModelFrameBackdrop:Show();
	AvatarInstructionsFrame:Show();
	
	Addon.FrameUnlocked = true;
end

function Addon:ConsoleHandler(rawcommand)
	local command, arg1, arg2, arg3, arg4	= strsplit(" ", string.lower(rawcommand));
	
	if(command == "toggle") then
		
		local thing = arg1;
		
		if(thing == nil) then
			
			self.db.profile.enabled = false;
			Addon:UpdateAvatar("AVATAR_TOGGLES");
			
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar|r Avatar " .. (self.db.profile.enabled and "|cff82cd40enabled|r" or "|cffc92222disabled|r") .. ".");
			
		elseif(thing == "weapon") then
			
			self.db.profile.show.weapon = not self.db.profile.show.weapon;
			Addon:UpdateAvatar("AVATAR_TOGGLES");
			
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar|r Avatar weapon " .. (self.db.profile.show.weapon and "|cff82cd40visible|r" or "|cffc92222hidden|r") .. ".");
			
		elseif(thing == "armor") then
			
			self.db.profile.show.armor = not self.db.profile.show.armor;
			Addon:UpdateAvatar("AVATAR_TOGGLES");
			
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar|r Avatar armor " .. (self.db.profile.show.armor and "|cff82cd40visible|r" or "|cffc92222hidden|r") .. ".");
			
		elseif(thing == "tabard") then
			
			self.db.profile.show.tabard = not self.db.profile.show.tabard;
			Addon:UpdateAvatar("AVATAR_TOGGLES");
			
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar|r Avatar tabard " .. (self.db.profile.show.tabard and "|cff82cd40visible|r" or "|cffc92222hidden|r") .. ".");
			
		end
		
	elseif(command == "equip") then
		
		local _, item = strsplit(" ", string.lower(rawcommand), 2);
		
		if(not strfind(item, "|Hitem")) then
			local item_id, bonusId = item:match("(%d+):(%d+)")
			if(not item_id) then
				item_id = tonumber(item);
			end
			
			item = string.format("item:%d:0:0:0:0:0:0:0:%d:0:0:1:%d", item_id, UnitLevel("player"), bonusId);
		end
		
		if(item) then
			AvatarModelFrame:TryOn(item);
		end
					
	elseif(command == "alpha") then
		
		local alphaValue = tonumber(arg1);
		
		if(alphaValue >= 0 and alphaValue <= 1) then
			self.db.profile.alpha = alphaValue;
			Addon:UpdateAvatar("AVATAR_ALPHA");
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Alpha set to " .. alphaValue .. ".");
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Insert a value between 0.0 to 1.0");
		end
		
	elseif(command == "profile") then
		
		local profileName = arg1;
		
		if(profileName ~= "Global Profile") then
			Addon.db:SetProfile(profileName);
			DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Using profile " .. profileName .. ".");
		end
		
	elseif(command == "unlock") then
		
		Addon:UnlockFrame();
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Unlocked");
		
	elseif(command == "lock") then
		
		Addon:LockFrame();
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fcAvatar:|r Locked");
	
	elseif(command == "help" or command == "commands" or command == "?") then
		
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc======== Avatar - Usage ========|r");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar help or /av help|r - Show usage");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250toggle|r - Show/hide avatar (currently " .. (self.db.profile.enabled and "|cff82cd40visible|r" or "|cffc92222hidden|r") .. ")");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250toggle [weapon/armor/tabard]|r - Show/hide avatar weapon, armor or tabard");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250profile [profile name]|r - Change current profile (" .. Addon.db:GetCurrentProfile() .. ")");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250alpha [value 0.0-1.0]|r - Set transparency of the avatar (transparent to opaque - currently " .. self.db.profile.alpha ..")");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250equip [equipment itemlink]|r - Equip avatar with an item");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250lock|r - Lock avatar");
		DEFAULT_CHAT_FRAME:AddMessage("|cff81e6fc/avatar|r |cfff8e250unlock|r - Unlock avatar allowing positioning, scaling and rotating with the mouse");
		
	else
		
		Addon:RefreshAvatar(true);
		Addon:ShowOptions();
		
	end
end
