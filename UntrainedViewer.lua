print("version: 1")

-- Slash reload command
SLASH_NEWRELOAD1 = "/rl"
SlashCmdList.NEWRELOAD = ReloadUI


local TRAINER_OPEN = false
local TRAINER_TYPE = ""


-- Helper Functions

-- Get Profession
local function GetTrainerType() 
-- fishing
-- first aid
-- engineering, tailoring
  local professions = { "Cook", "Miner", "Blacksmith", "Skinner", "Leatherworker", "Herbalist", "Alchemist", "First Aid"}
  
  local isTradeskill = IsTradeskillTrainer()
  local skillFullName, skillName
  --print(isTradeskill)
  if isTradeskill == 1 then
    local numServices = GetNumTrainerServices()
    for i = 1, numServices do
      local name, rank, category, expanded = GetTrainerServiceInfo(i)
      --print(name, rank, category, expanded) 
      if i > 1 then
        local name1, rank1, category1, expanded1 = GetTrainerServiceInfo(i-1)
        if name1 == "Development Skills" and name ~= "Recipes" then
          skillFullName = name
          break
        end
      end  
    end
  else
    return "UNKNOWN PROFESSION TRAINER"
  end
  --print(skillFullName)
  for i = 1, #professions do
    local match = strmatch(skillFullName, professions[i])
    --print(match)
    if match ~= nil then skillName = match end
  end
  return skillName
end

-------------------------------------------------------------
-------------------------- DEBUG ----------------------------
-------------------------------------------------------------

-- Debug window
local dW = CreateFrame("Frame", "DebugWindow", UIParent, "BasicFrameTemplate")
dW:SetPoint("CENTER")
dW:SetSize(200, 100)
dW:SetMovable(true)
dW:EnableMouse(true)
dW:RegisterForDrag("LeftButton")
dW:SetScript("OnDragStart", dW.StartMoving)
dW:SetScript("OnDragStop", dW.StopMovingOrSizing)
dW:Hide()

dW:SetScript("OnShow", function()
  print("Scanning...")
end)

-- Title
dW.title = dW:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dW.title:SetPoint("TOPLEFT", dW, 5, -5)
local function writeType(type)
  dW.title:SetText("Debug: %s"):format(type))
end

-- Content
dW.trainerType = dW:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dW.trainerType:SetPoint("TOPLEFT", dW, 5, -22)

-- Scan to open
SLASH_SCAN1 = "/scan"
SlashCmdList.SCAN = function()
  if dW:IsShown() then
    dW:Hide()
  else
    dW:Show()
  end
end

-------------------------------------------------------------
--------------------- EVENT HANDLING ------------------------
-------------------------------------------------------------

-- Event Frame
local eF = CreateFrame("Frame")

-- Retrieve Event
function eF:OnEvent(event, ...)
  self[event](self, event, ...)
end

-- When opening/closing vendor window
function eF:TRAINER_SHOW(event)
  print("Trainer window |cff00ff00open|r")
  TRAINER_OPEN = true
  TRAINER_TYPE = GetTrainerType()
  print(("|cff00ffff%s|r"):format(TRAINER_TYPE), "active")

  writeType(TRAINER_TYPE)
  dW:Show()
  
end

function eF:TRAINER_CLOSED(event)
  print("Trainer window |cffff0000close|r")
  TRAINER_OPEN = false
  TRAINER_TYPE = ""

  writeType(TRAINER_TYPE)
  dW:Hide()
end

-- Event Registry
eF:RegisterEvent("TRAINER_SHOW")
eF:RegisterEvent("TRAINER_CLOSED")
eF:SetScript("OnEvent", eF.OnEvent)
