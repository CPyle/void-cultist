local cooldownTime = time()
local procChance = 0.05
local cooldown = 15
local VCPrefix = "VOID_CULTIST"

local VoidCultist = CreateFrame("Frame")
VoidCultist:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
VoidCultist:RegisterEvent('UNIT_AURA')
VoidCultist:RegisterEvent("CHAT_MSG_ADDON")
RegisterAddonMessagePrefix(VCPrefix)

local chants = {
    "Visualize that the seal becomes a gate!",
    "He is coming! This has been written!",
    "Turn the key!",
    "The last prison weakens. The dead sleeper stirs in the depths.",
    "Untouched by time, unmoved by fate.",
    "The Black Empire commands the Hour Of Twilight.",
    "In the land of Ny'alotha there is only sleep.",
    "At the bottom of the ocean even light must die.",
    "In the sunken city, he lays dreaming.",
    "O, discordia!"
}

function VoidCultist:Chant(msg)
    broadcast = false
    if (msg == nil) then
        msg = chants[math.random(#chants)]
        broadcast = true        
    end    
    SendChatMessage(msg, "SAY")
    cooldownTime = time()
    if IsAddonMessagePrefixRegistered(VCPrefix) and broadcast then
        SendAddonMessage(VCPrefix, msg, "RAID")
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
            self:Chant(msg)
        end
    end
end