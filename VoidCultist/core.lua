local cooldownTime = time()
local procChance = 0.04
local cooldown = 20
local VCPrefix = "VOID_CULTIST"

local VoidCultist = CreateFrame("Frame")
VoidCultist:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
VoidCultist:RegisterEvent('UNIT_AURA')
VoidCultist:RegisterEvent("CHAT_MSG_ADDON")
RegisterAddonMessagePrefix(VCPrefix)

local chants = {
     [1] = {"Visualize that the seal becomes a gate!", "The seal is broken!"},
     [2] = {"He is coming! This has been written!", "It has been written!"},
     [3] = {"The lord of ravens will turn the key.", "The gate is open!"},
     [4] = {"The last prison weakens.", "The dead sleeper stirs in the depths."},
     [5] = {"Untouched by time, unmoved by fate.", "The Hour of Twilight approaches, unyielding."},
     [6] = {"In the land of Ny'alotha there is only sleep.", "Only the mad walk amongst the dreaming."},
     [7] = {"At the bottom of the ocean even light must die.", "The void consumes."},
     [8] = {"In the sunken city, he lays dreaming.", "N'Zoth slumbers beneath."},
     [9] = {"O, discordia!", "O, discordia!"},
    [10] = {"Oblivion offers solace.", "Take the gift! Take it!"}
}

function VoidCultist:Chant(msgIndex)
    broadcast = false
    if (msgIndex == nil) then
        msgIndex = math.random(#chants)
        msg = chants[msgIndex][1]
        broadcast = true        
    else
        msg = chants[msgIndex][2]
    end    
    SendChatMessage(msg, "SAY")
    cooldownTime = time()
    if IsAddonMessagePrefixRegistered(VCPrefix) and broadcast then
        SendAddonMessage(VCPrefix, msgIndex, "RAID")
    end        
end

function VoidCultist:UNIT_AURA(unitId)
    if unitId == "player" then
        aura = UnitBuff("player", "Voidform")
        if aura then
            if math.random() < procChance and time() - cooldownTime > cooldown then                
                self:Chant()
            end                  
        end
    end
end

function VoidCultist:CHAT_MSG_ADDON(prefix, msg, channel, sender)
    if (prefix == VCPrefix) then
        if (UnitInRange(sender)) then
            self:Chant(tonumber(msg))
        end
    end
end

function VCTest()
    VoidCultist:Chant(1)
end