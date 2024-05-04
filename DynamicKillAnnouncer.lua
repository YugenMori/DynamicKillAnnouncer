-- Author: Yugen
--
-- DynamicKillAnnouncer
--
-- Supports any version of wow
--
-- Simple Frame that annaunces when you kill someone in pvp
--
-- This is a module from AbyssUI that works alone too, not needing the UI itself to run
--
--------------------------------------------------------------
-- Init - Tables - Saves
local addonName, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("DynamicKillAnnouncer")
local GetWoWVersion = ((select(4, GetBuildInfo())))
--
local f = CreateFrame("Frame", "DynamicKillAnnouncer_Config", UIParent)
f:SetSize(50, 50)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
  character = UnitName("player").."-"..GetRealmName()
  -- Config/Panel
	if not DynamicKillAnnouncer_Config then
		local DynamicKillAnnouncer_Config = {}
	end
	-- AddonSettings
	if not AbyssUIAddonSettings then
		AbyssUIAddonSettings = {}
	end
  if not AbyssUIAddonSettings[character] then
    AbyssUIAddonSettings[character] = {}
  end
	-- Color Init
  if not COLOR_MY_UI then
      COLOR_MY_UI = {}
  end
  if not COLOR_MY_UI[character] then
      COLOR_MY_UI[character] = {}
  end
  if not COLOR_MY_UI[character].Color then
      COLOR_MY_UI[character].Color = { r = 1, g = 1, b = 1 }
  end
end)
-- Fonts
local function AbyssUI_Fontification(globalFont, subFont, damageFont)
local locale = GetLocale()
local fontName, fontHeight, fontFlags = MinimapZoneText:GetFont()
local mediaFolder = "Interface\\AddOns\\DynamicKillAnnouncer\\textures\\font\\"
  if (locale == "zhCN") then
    globalFont  = mediaFolder.."zhCN-TW\\senty.ttf"
    subFont   	= mediaFolder.."zhCN-TW\\senty.ttf"
    damageFont  = mediaFolder.."zhCN-TW\\senty.ttf"
  elseif (locale == "zhTW") then
    globalFont  = mediaFolder.."zhCN-TW\\senty.ttf"
    subFont   	= mediaFolder.."zhCN-TW\\senty.ttf"
    damageFont  = mediaFolder.."zhCN-TW\\senty.ttf"
  elseif (locale == "ruRU") then
    globalFont  = mediaFolder.."ruRU\\dejavu.ttf"
    subFont   	= mediaFolder.."ruRU\\dejavu.ttf"
    damageFont  = mediaFolder.."ruRU\\dejavu.ttf"
  elseif (locale == "koKR") then
    globalFont  = mediaFolder.."koKR\\dxlbab.ttf"
    subFont   	= mediaFolder.."koKR\\dxlbab.ttf"
    damageFont  = mediaFolder.."koKR\\dxlbab.ttf"
  elseif (locale == "frFR" or locale == "deDE" or locale == "enGB" or locale == "enUS" or locale == "itIT" or
    locale == "esES" or locale == "esMX" or locale == "ptBR") then
    globalFont  = mediaFolder.."global.ttf"
    subFont   	= mediaFolder.."npcfont.ttf"
    damageFont  = mediaFolder.."damagefont.ttf"
  else
    globalFont  = fontName
    subFont   	= fontName
    damageFont  = fontName
  end
  return globalFont, subFont, damageFont
end
local globalFont, subFont, damageFont = AbyssUI_Fontification(globalFont, subFont, damageFont)
-- Textures
local dialogFrameTexture 		= "Interface\\Addons\\AbyssUI\\textures\\extra\\dialogFrameTexture"
local dialogFrameTextureBorder 	= "Interface\\DialogFrame\\UI-DialogBox-Background"
----------------------------------------------------
-- AbyssUI_ReloadFrame
local AbyssUI_ReloadFrame = CreateFrame("Frame", "$parentAbyssUI_ReloadFrame", UIParent)
AbyssUI_ReloadFrame:Hide()
AbyssUI_ReloadFrame:SetWidth(400)
AbyssUI_ReloadFrame:SetHeight(150)
AbyssUI_ReloadFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, -100)
AbyssUI_ReloadFrame:EnableMouse(true)
AbyssUI_ReloadFrame:SetClampedToScreen(true)
AbyssUI_ReloadFrame:SetMovable(true)
AbyssUI_ReloadFrame:RegisterForDrag("LeftButton")
AbyssUI_ReloadFrame:SetScript("OnDragStart", AbyssUI_ReloadFrame.StartMoving)
AbyssUI_ReloadFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
AbyssUI_ReloadFrame:SetFrameStrata("Dialog")
AbyssUI_ReloadFrame.text = AbyssUI_ReloadFrame.text or AbyssUI_ReloadFrame:CreateFontString(nil,"ARTWORK","QuestMapRewardsFont")
AbyssUI_ReloadFrame.text:SetScale(1.5)
AbyssUI_ReloadFrame.text:SetAllPoints(true)
AbyssUI_ReloadFrame.text:SetPoint("CENTER")
AbyssUI_ReloadFrame.text:SetText(L["A reload is necessary so this configuration can be save!\n"..
"Click the |cffffcc00'confirm'|r button to Reload.\nYou still can make changes (do before you confirm)."])
----------------------------------------------------
local Border = AbyssUI_ReloadFrame:CreateTexture(nil, "BACKGROUND")
Border:SetTexture(dialogFrameTextureBorder)
Border:SetPoint("TOPLEFT", -3, 3)
Border:SetPoint("BOTTOMRIGHT", 3, -3)
--Border:SetVertexColor(0.2, 0.2, 0.2, 0.6)
----------------------------------------------------
local BorderBody = AbyssUI_ReloadFrame:CreateTexture(nil, "ARTWORK")
BorderBody:SetTexture(dialogFrameTextureBorder)
BorderBody:SetAllPoints(AbyssUI_ReloadFrame)
BorderBody:SetVertexColor(0.34, 0.34, 0.34, 0.7)
----------------------------------------------------
local Texture = AbyssUI_ReloadFrame:CreateTexture(nil, "BACKGROUND")
Texture:SetTexture(dialogFrameTextureBorder)
Texture:SetAllPoints(AbyssUI_ReloadFrame)
AbyssUI_ReloadFrame.texture = Texture
----------------------------------------------------
local f = CreateFrame("Frame", nil)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function() 
	local FrameButtonConfirm = CreateFrame("Button","$parentFrameButtonConfirm", AbyssUI_ReloadFrame, "UIPanelButtonTemplate")
	FrameButtonConfirm:SetHeight(24)
	FrameButtonConfirm:SetWidth(100)
	FrameButtonConfirm:SetPoint("BOTTOM", AbyssUI_ReloadFrame, "BOTTOM", 0, 10)
	FrameButtonConfirm.text = FrameButtonConfirm.text or FrameButtonConfirm:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	--FrameButtonConfirm.text:SetFont(globalFont, 14)
	FrameButtonConfirm.text:SetPoint("CENTER", FrameButtonConfirm, "CENTER", 0, 0)
	FrameButtonConfirm.text:SetText(L["Confirm"])
		if (AbyssUIAddonSettings.FontsValue == true and AbyssUIAddonSettings.ExtraFunctionDisableFontWhiteText ~= true) then
			AbyssUI_ApplyFonts(FrameButtonConfirm.text)
		else
			FrameButtonConfirm.text:SetFont(globalFont, 14)
			FrameButtonConfirm.text:SetTextColor(248/255, 248/255, 248/255)
			FrameButtonConfirm.text:SetShadowColor(0, 0, 0)
			FrameButtonConfirm.text:SetShadowOffset(1, -1)
		end
	FrameButtonConfirm:SetScript("OnClick", function()
		AbyssUI_ReloadFrame:Hide()
		ReloadUI()
	end)
end)
----------------------------------------------------
-- AbyssUI_ReloadFrameFadeUI
local AbyssUI_ReloadFrameFadeUI = CreateFrame("Frame", "$parentAbyssUI_ReloadFrameFadeUI", UIParent)
AbyssUI_ReloadFrameFadeUI:Hide()
AbyssUI_ReloadFrameFadeUI:SetWidth(500)
AbyssUI_ReloadFrameFadeUI:SetHeight(180)
AbyssUI_ReloadFrameFadeUI:SetPoint("CENTER", "UIParent", "CENTER", 0, -100)
AbyssUI_ReloadFrameFadeUI:EnableMouse(true)
AbyssUI_ReloadFrameFadeUI:SetClampedToScreen(true)
AbyssUI_ReloadFrameFadeUI:SetMovable(true)
AbyssUI_ReloadFrameFadeUI:RegisterForDrag("LeftButton")
AbyssUI_ReloadFrameFadeUI:SetScript("OnDragStart", AbyssUI_ReloadFrameFadeUI.StartMoving)
AbyssUI_ReloadFrameFadeUI:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
AbyssUI_ReloadFrameFadeUI:SetFrameStrata("Dialog")
AbyssUI_ReloadFrameFadeUI.text = AbyssUI_ReloadFrameFadeUI.text or AbyssUI_ReloadFrameFadeUI:CreateFontString(nil,"ARTWORK","QuestMapRewardsFont")
AbyssUI_ReloadFrameFadeUI.text:SetScale(1.5)
AbyssUI_ReloadFrameFadeUI.text:SetAllPoints()
AbyssUI_ReloadFrameFadeUI.text:SetText(L["It will only hide Blizzard frames, addons have their"..
" own frames,\n a good addon probably has an option to hide while out of combat.\n"..
" I could have added the entire interface to be hidden,\n but that would prevent"..
" interaction with some frames (auction, loot, quest, etc)."])
----------------------------------------------------
local Border = AbyssUI_ReloadFrameFadeUI:CreateTexture(nil, "BACKGROUND")
Border:SetTexture(dialogFrameTextureBorder)
Border:SetPoint("TOPLEFT", -3, 3)
Border:SetPoint("BOTTOMRIGHT", 3, -3)
--Border:SetVertexColor(0.2, 0.2, 0.2, 0.6)
----------------------------------------------------
local BorderBody = AbyssUI_ReloadFrameFadeUI:CreateTexture(nil, "ARTWORK")
BorderBody:SetTexture(dialogFrameTextureBorder)
BorderBody:SetAllPoints(AbyssUI_ReloadFrameFadeUI)
BorderBody:SetVertexColor(0.34, 0.34, 0.34, 0.7)
----------------------------------------------------
local Texture = AbyssUI_ReloadFrameFadeUI:CreateTexture(nil, "BACKGROUND")
Texture:SetTexture(dialogFrameTextureBorder)
Texture:SetAllPoints(AbyssUI_ReloadFrameFadeUI)
AbyssUI_ReloadFrameFadeUI.texture = Texture
----------------------------------------------------
local f = CreateFrame("Frame", nil)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function() 
	local FrameButtonConfirm = CreateFrame("Button","$parentFrameButtonConfirm", AbyssUI_ReloadFrameFadeUI, "UIPanelButtonTemplate")
	FrameButtonConfirm:SetHeight(24)
	FrameButtonConfirm:SetWidth(100)
	FrameButtonConfirm:SetPoint("BOTTOM", AbyssUI_ReloadFrameFadeUI, "BOTTOM", 0, 10)
	FrameButtonConfirm.text = FrameButtonConfirm.text or FrameButtonConfirm:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	--FrameButtonConfirm.text:SetFont(globalFont, 14)
	FrameButtonConfirm.text:SetPoint("CENTER", FrameButtonConfirm, "CENTER", 0, 0)
	FrameButtonConfirm.text:SetText(L["Confirm"])
		if (AbyssUIAddonSettings.FontsValue == true and AbyssUIAddonSettings.ExtraFunctionDisableFontWhiteText ~= true) then
			AbyssUI_ApplyFonts(FrameButtonConfirm.text)
		else
			FrameButtonConfirm.text:SetFont(globalFont, 14)
			FrameButtonConfirm.text:SetTextColor(248/255, 248/255, 248/255)
			FrameButtonConfirm.text:SetShadowColor(0, 0, 0)
			FrameButtonConfirm.text:SetShadowOffset(1, -1)
		end
	FrameButtonConfirm:SetScript("OnClick", function()
		AbyssUI_ReloadFrameFadeUI:Hide()
		ReloadUI()
	end)
end)
----------------------------------------------------
-- Config Frame
-- Panel
local function InitSettings()
  DynamicKillAnnouncer_Config.panel = CreateFrame("Frame", "$parentDynamicKillAnnouncer_Config", InterfaceOptionsFramePanelContainer)
  -- Register in the Interface Addon Options GUI
  -- Set the name for the Category for the Options Panel1
  DynamicKillAnnouncer_Config.panel.name = "DynamicKillAnnouncer"
  -- Add the panel to the Interface Options
  InterfaceOptions_AddCategory(DynamicKillAnnouncer_Config.panel, addonName)
end
-- Options
local function Main_DynamicKillAnnouncer()
	-- Disable Kill Announcer --
	local KillAnnouncer_CheckButton = CreateFrame("CheckButton", "$parentKillAnnouncer_CheckButton", DynamicKillAnnouncer_Config.panel, "ChatConfigCheckButtonTemplate")
	KillAnnouncer_CheckButton:SetPoint("TOPLEFT", 10, -80)
	KillAnnouncer_CheckButton.Text:SetText(L["Disable Kill Announcer"])
	KillAnnouncer_CheckButton.tooltip = L["Disable the Kill Announcer frame that show up when you kill someone"]
	KillAnnouncer_CheckButton:SetChecked(AbyssUIAddonSettings.DisableKillAnnouncer)
	-- OnClick Function
	KillAnnouncer_CheckButton:SetScript("OnClick", function(self)
	AbyssUIAddonSettings.DisableKillAnnouncer = self:GetChecked()
	AbyssUI_ReloadFrame:Show()
	end)
	-- Silence Kill Announcer --
	local SilenceKillAnnouncer_CheckButton = CreateFrame("CheckButton", "$parentSilenceKillAnnouncer_CheckButton", DynamicKillAnnouncer_Config.panel, "ChatConfigCheckButtonTemplate")
	SilenceKillAnnouncer_CheckButton:SetPoint("TOPLEFT", 10, -110)
	SilenceKillAnnouncer_CheckButton.Text:SetText(L["Silence Kill Announcer"])
	SilenceKillAnnouncer_CheckButton.tooltip = L["Remove boss/kill sounds from the Kill Announcer frame"]
	SilenceKillAnnouncer_CheckButton:SetChecked(AbyssUIAddonSettings.SilenceKillAnnouncer)
	-- OnClick Function
	SilenceKillAnnouncer_CheckButton:SetScript("OnClick", function(self)
	AbyssUIAddonSettings.SilenceKillAnnouncer = self:GetChecked()
	end)
	-- PvE Kill Announcer --
	local PVEKillAnnouncer_CheckButton = CreateFrame("CheckButton", "$parentPVEKillAnnouncer_CheckButton", DynamicKillAnnouncer_Config.panel, "ChatConfigCheckButtonTemplate")
	PVEKillAnnouncer_CheckButton:SetPoint("TOPLEFT", 10, -140)
	PVEKillAnnouncer_CheckButton.Text:SetText("PVE Kill Announcer")
	PVEKillAnnouncer_CheckButton.tooltip = "Will work on pve kills also"
	PVEKillAnnouncer_CheckButton:SetChecked(AbyssUIAddonSettings.PVEKillAnnouncer)
	-- OnClick Function
	PVEKillAnnouncer_CheckButton:SetScript("OnClick", function(self)
	AbyssUIAddonSettings.PVEKillAnnouncer = self:GetChecked()
	end)
	----------------------------------------------------
	-- Kill Frame
	----------------------------------------------------
	local DynamicKillAnnouncerFrame = CreateFrame("Frame", "$parentDynamicKillAnnouncerFrame", UIParent)
	DynamicKillAnnouncerFrame:SetFrameStrata("BACKGROUND")
	DynamicKillAnnouncerFrame:SetWidth(128)
	DynamicKillAnnouncerFrame:SetHeight(128)
	DynamicKillAnnouncerFrame:SetAlpha(.90)
	DynamicKillAnnouncerFrame:SetClampedToScreen(true)
	DynamicKillAnnouncerFrame:SetPoint("CENTER", 120, 5)
	DynamicKillAnnouncerFrame:Hide()
	local t = DynamicKillAnnouncerFrame:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Addons\\DynamicKillAnnouncer\\textures\\extra\\bloodtexture")
	t:SetAllPoints(DynamicKillAnnouncerFrame)
	DynamicKillAnnouncerFrame.texture = t
	-- Text
	DynamicKillAnnouncerFrame.text = DynamicKillAnnouncerFrame.text or DynamicKillAnnouncerFrame:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	DynamicKillAnnouncerFrame.text:SetScale(1)
	DynamicKillAnnouncerFrame.text:SetPoint("CENTER")
	DynamicKillAnnouncerFrame.text:SetPoint("CENTER", DynamicKillAnnouncerFrame, "CENTER", 0, -15)
	DynamicKillAnnouncerFrame.text:SetFont(damageFont, 12, "THINOUTLINE")
	DynamicKillAnnouncerFrame.text:SetShadowColor(0/255, 0/255, 0/255)
	DynamicKillAnnouncerFrame.text:SetShadowOffset(1, -1)
	-- DynamicKillAnnouncerHeader
	local _G = _G
	local KillText = _G["KILLS"]
	local DynamicKillAnnouncerHeader = CreateFrame("Frame", "$parentDynamicKillAnnouncerHeader", DynamicKillAnnouncerFrame)
	DynamicKillAnnouncerHeader:SetFrameStrata("BACKGROUND")
	DynamicKillAnnouncerHeader:SetWidth(128)
	DynamicKillAnnouncerHeader:SetHeight(128)
	DynamicKillAnnouncerHeader:SetPoint("CENTER", 0, 20)
	-- Text
	DynamicKillAnnouncerHeader.text = DynamicKillAnnouncerHeader.text or DynamicKillAnnouncerHeader:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	DynamicKillAnnouncerHeader.text:SetScale(1.25)
	DynamicKillAnnouncerHeader.text:SetPoint("CENTER")
	DynamicKillAnnouncerHeader.text:SetPoint("CENTER", DynamicKillAnnouncerHeader, "CENTER", 0, -8)
	DynamicKillAnnouncerHeader.text:SetFont(damageFont, 12, "THINOUTLINE")
	DynamicKillAnnouncerHeader.text:SetShadowColor(0/255, 0/255, 0/255)
	DynamicKillAnnouncerHeader.text:SetShadowOffset(1, -1)
	DynamicKillAnnouncerHeader.text:SetText(strupper("|cfffd0101"..KillText.."|r"))
	-- Kill SoundList
	local soundIDSHorde = { 
		24531,  -- RAGNAROS 
		24530,  -- RAGNAROS2
		38065,  -- GARROSH 
		38066,  -- GARROSH2
		16020,  -- GARROSH3
		24477,  -- FANDRAL 
		13324,  -- Telestra 
		45439,  -- BLACKHAND2 
		21164,  -- Baine
		43913,  -- Koromar
		16146,  -- JARAXXUS
		109300, -- Bwonsamdi
		15591,  -- Kologarn
		42070,  -- Gugrokk2
		50083,  -- Kormrok
		24226,  -- DAAKARA
		44525,  -- KARGATH
		17067,  -- Valithria
		48498, 	-- Orc Male
		14506,  -- Xevozz
		16695,  -- Dsaurfang 
		16854,  -- Taldaram
		16681,  -- Valanar
		35572, 	-- KAZRAJIN
		50594,  -- DARKVINDICATOR
		50593,	-- DARKVINDICATOR2
		8894, 	-- BLA_NAXX
		8801,	-- FAER_NAXX
		10169,	-- Keli
		12027,	-- Halazzi
		10334,	-- Garg
		5831,	-- Herod
		15740,	-- Thorim
		10454,  -- Thrall
		35591, 	-- LeiShen
	}
	local soundIDSAlly = { 
		24531,  -- RAGNAROS 
		24530,  -- RAGNAROS2
		24477,  -- FANDRAL
		13324,  -- Telestra
		43913,  -- Koromar
		21576,  -- Muradin
		21574,  -- Muradin2
		16146,  -- JARAXXUS
		109300, -- Bwonsamdi
		15591,  -- Kologarn
		16061,  -- Varian
		16062, 	-- Varian2
		42070,  -- Gugrokk2
		43254,  -- Leroy Jenkins
		50083,  -- Kormrok
		44525,  -- KARGATH
		17067,  -- Valithria
		14506,  -- Xevozz
		16854,  -- Taldaram
		16681,  -- Valanar
		35572, 	-- KAZRAJIN
		50594,  -- DARKVINDICATOR
		50593,	-- DARKVINDICATOR2
		8894, 	-- BLA_NAXX
		8801,	-- FAER_NAXX
		10169,	-- Keli
		12027,	-- Halazzi
		10334,	-- Garg
		5831,	-- Herod
		15740,	-- Thorim
		35591, 	-- LeiShen
	}
	local numSoundsHorde = #soundIDSHorde
	local numSoundsAlly  = #soundIDSAlly
	local englishFaction, localizedFaction = UnitFactionGroup("player")
	local function PlaySoundRandom()
		if (englishFaction == "Horde") then
			PlaySound(soundIDSHorde[random(1, numSoundsHorde)], "MASTER")
		elseif (englishFaction == "Alliance") then
			PlaySound(soundIDSAlly[random(1, numSoundsAlly)], "MASTER")
		else
			return nil
		end
	end
	-- Kill Announcer
	local KillAnouncer = CreateFrame("FRAME", "$parentKillAnouncer")
	local name = GetUnitName("player")
	KillAnouncer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KillAnouncer:SetScript("OnEvent", function(self)
		if (AbyssUIAddonSettings.DisableKillAnnouncer ~= true) then
		    local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, prefixParam1, prefixParam2, dummyparam, suffixParam1, suffixParam2 = CombatLogGetCurrentEventInfo()
		    if (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE") and suffixParam2 > 0 then
				if (suffixParam2 ~= nil) then
					if (sourceName == name) then
						if (string.find(destGUID, "Player")) then
							DynamicKillAnnouncerFrame:Hide()
							DynamicKillAnnouncerFrame.text:SetText("|cfff2f2f2"..destName.."|r")
							if (AbyssUIAddonSettings.SilenceKillAnnouncer ~= true) then
								PlaySoundRandom()
							end
							UIFrameFadeIn(DynamicKillAnnouncerFrame, 4, 1, 0)
						end
			  		end
			  	end
		  	elseif (event == "SWING_DAMAGE") and prefixParam2 > 0 then
		  		if (prefixParam2 ~= nil) then
					if (sourceName == name) then
						if (string.find(destGUID, "Player")) then
							DynamicKillAnnouncerFrame:Hide()
							DynamicKillAnnouncerFrame.text:SetText("|cfff2f2f2"..destName.."|r")
							if (AbyssUIAddonSettings.SilenceKillAnnouncer ~= true) then
								PlaySoundRandom()
							end
							UIFrameFadeIn(DynamicKillAnnouncerFrame, 4, 1, 0)
						end
			  		end
			  	end
		    else
		    	return nil
		    end
		else
			return nil
		end
	end)
	-- PVEKillAnnouncer Announcer
	local PVEKillAnnouncer = CreateFrame("FRAME", "$parentPVEKillAnouncer")
	local name = GetUnitName("player")
	PVEKillAnnouncer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	PVEKillAnnouncer:SetScript("OnEvent", function(self)
		if (AbyssUIAddonSettings.PVEKillAnnouncer == true) then
		    local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, prefixParam1, prefixParam2, dummyparam, suffixParam1, suffixParam2 = CombatLogGetCurrentEventInfo()
		    if (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE") and suffixParam2 > 0 then
				if (suffixParam2 ~= nil) then
					if (sourceName == name) then
						if (not string.find(destGUID, "Player")) then
							DynamicKillAnnouncerFrame:Hide()
							DynamicKillAnnouncerFrame.text:SetText("|cfff2f2f2"..destName.."|r")
							if (AbyssUIAddonSettings.SilenceKillAnnouncer ~= true) then
								PlaySoundRandom()
							end
							UIFrameFadeIn(DynamicKillAnnouncerFrame, 4, 1, 0)
						end
			  		end
			  	end
		  	elseif (event == "SWING_DAMAGE") and prefixParam2 > 0 then
		  		if (prefixParam2 ~= nil) then
					if (sourceName == name) then
						if (not string.find(destGUID, "Player")) then
							DynamicKillAnnouncerFrame:Hide()
							DynamicKillAnnouncerFrame.text:SetText("|cfff2f2f2"..destName.."|r")
							if (AbyssUIAddonSettings.SilenceKillAnnouncer ~= true) then
								PlaySoundRandom()
							end
							UIFrameFadeIn(DynamicKillAnnouncerFrame, 4, 1, 0)
						end
			  		end
			  	end
		    else
		    	return nil
		    end
		else
			return nil
		end
	end)
end
-- Init
local f = CreateFrame("Frame")
f:SetSize(50, 50)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
	character = UnitName("player").."-"..GetRealmName()
	if not AbyssUIAddonSettings then
    	AbyssUIAddonSettings = {}
  	end
  	if not AbyssUIAddonSettings[character] then
    	AbyssUIAddonSettings[character] = {}
  	end
	InitSettings()
	Main_DynamicKillAnnouncer()
end)