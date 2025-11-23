-- Initialize SavedVariables
AltBotMenuDB = AltBotMenuDB or { alts = {} }
-- Don't persist botStates between sessions, but maintain during current session
AltBotMenuDB.botStates = AltBotMenuDB.botStates or {}

-- Record/update the current character on login
local currentPlayerName
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    local name, realm = UnitName("player"), GetRealmName()
    local faction = UnitFactionGroup("player")
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    
    currentPlayerName = name  -- Store current player name

    AltBotMenuDB.alts[name] = AltBotMenuDB.alts[name] or {}
    AltBotMenuDB.alts[name].realm = realm
    AltBotMenuDB.alts[name].faction = faction
    AltBotMenuDB.alts[name].class = class
    AltBotMenuDB.alts[name].level = level
    
    -- Reset all bot states on login since bots log out with the player
    AltBotMenuDB.botStates = {}
end)

-- Create the frame (Vanilla style)
local frame = CreateFrame("Frame", "AltBotMenuFrame", UIParent)
frame:SetWidth(220)
frame:SetHeight(260)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
frame:Hide()

-- Title text
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
frame.title:SetText("Add Bot Alt")

-- Close button in top right corner
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
closeBtn:SetWidth(25)
closeBtn:SetHeight(25)
closeBtn:SetText("X")
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Make frame draggable + save position
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function() frame:StartMoving() end)
frame:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
    local point, _, relPoint, xOfs, yOfs = frame:GetPoint()
    AltBotMenuDB.point, AltBotMenuDB.relPoint, AltBotMenuDB.xOfs, AltBotMenuDB.yOfs = point, relPoint, xOfs, yOfs
end)

-- Restore saved position
frame:SetScript("OnShow", function()
    if AltBotMenuDB.point then
        frame:ClearAllPoints()
        frame:SetPoint(AltBotMenuDB.point, UIParent, AltBotMenuDB.relPoint, AltBotMenuDB.xOfs, AltBotMenuDB.yOfs)
    end
end)

-- Function to rebuild buttons dynamically
local function BuildButtons()
    -- Hide old buttons if any
    if frame.buttons then
        for _, b in ipairs(frame.buttons) do b:Hide() end
    end
    frame.buttons = {}

    local playerFaction = UnitFactionGroup("player")
    local i = 0
    for name, info in pairs(AltBotMenuDB.alts) do
        -- Exclude current player and only show same faction characters
        if info.faction == playerFaction and name ~= currentPlayerName then
            i = i + 1
            local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            btn:SetPoint("TOP", frame, "TOP", 0, -40 - (i-1)*30)  -- Adjusted to start below close button
            btn:SetWidth(160)
            btn:SetHeight(25)

            -- Store alt name directly on the button
            btn.altName = name
            
            -- Initialize bot state if not exists (default to false)
            if AltBotMenuDB.botStates[name] == nil then
                AltBotMenuDB.botStates[name] = false
            end
            
            -- Update button text based on current state
            if AltBotMenuDB.botStates[name] then
                btn:SetText(name .. " (Remove)")
            else
                btn:SetText(name .. " (Add)")
            end

            -- Toggle bot on click - use btn.altName instead of name
            btn:SetScript("OnClick", function()
                if AltBotMenuDB.botStates[btn.altName] then
                    -- Bot is active, remove it
                    SendChatMessage(".bot remove "..btn.altName, "SAY")
                    AltBotMenuDB.botStates[btn.altName] = false
                    btn:SetText(btn.altName .. " (Add)")
                else
                    -- Bot is not active, add it
                    SendChatMessage(".bot add "..btn.altName, "SAY")
                    AltBotMenuDB.botStates[btn.altName] = true
                    btn:SetText(btn.altName .. " (Remove)")
                end
            end)

            table.insert(frame.buttons, btn)
        end
    end

    -- Auto-adjust frame height based on number of buttons
    local totalHeight = 80 + (i * 30)  -- Base height + button space
    frame:SetHeight(math.max(160, math.min(400, totalHeight)))  -- Min 160, Max 400
end

-- Slash command to toggle
SLASH_ALTBOT1 = "/altbot"
SlashCmdList["ALTBOT"] = function(msg)
    if frame:IsShown() then
        frame:Hide()
    else
        BuildButtons()
        frame:Show()
    end
end
