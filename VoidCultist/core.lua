local cooldownTime = time()
local procChance = 0.033
local cooldown = 30
local VCPrefix = "VOID_CULTIST"

local VoidCultist = CreateFrame("Frame")
VoidCultist:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
VoidCultist:RegisterEvent('UNIT_AURA')
VoidCultist:RegisterEvent("CHAT_MSG_ADDON")
RegisterAddonMessagePrefix(VCPrefix)

local chants = {
     [1] = {"He is coming! This has been written!", "It has been written!"},
     [2] = {"The lord of ravens will turn the key.", "The gate to Ny'alotha is open!"},
     [3] = {"The last prison weakens.", "The dead sleeper stirs in the depths."},
     [4] = {"Untouched by time, unmoved by fate.", "The Hour of Twilight approaches, unyielding."},
     [5] = {"In the land of Ny'alotha there is only sleep.", "Only the mad walk amongst the dreaming."},
     [6] = {"At the bottom of the ocean even light must die.", "The void will consume everything."},
     [7] = {"In the sunken city, he lays dreaming.", "N'Zoth slumbers beneath."},
     [8] = {"O, discordia!", "O, discordia!"},
     [9] = {"Oblivion offers solace.", "Take the gift of oblivion! Take it!"},
	[10] = {"Have you had the dream again?", "The seven eyes watch from the outside."},
	[11] = {"The giant rook watches from the dead trees.", "Nothing breathes beneath his shadow."},
	[12] = {"All places, all things have souls.", "All souls can be devoured."}
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
        SendAddonMessage(VCPrefix, tostring(msgIndex), "RAID")
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