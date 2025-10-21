local Lplr = game:GetService("Players").LocalPlayer
local moduleScript = Lplr.PlayerScripts.Code.controllers.antiCheatController
local ACModule = require(moduleScript)
print("Anti-Cheat Module gefunden")

local AntiCheatManager = {
    enabled = false,
    originalFunctions = {},
    controller = nil
}

function AntiCheatManager:init()
    if ACModule and ACModule.AntiCheatController then
        self.controller = ACModule.AntiCheatController
        self:backupFunctions()
    else
        warn("❌ AntiCheatController not found!")
    end
end

function AntiCheatManager:backupFunctions()
    if not self.controller then return end
    
    local functionNames = {
        "onStart", "onTick", "onCharacterAdded", 
        "checkWalkSpeed", "checkJumpHeight", "checkUseJumpPower", "handleGuiName"
    }
    
    for _, funcName in pairs(functionNames) do
        if self.controller[funcName] and type(self.controller[funcName]) == "function" then
            self.originalFunctions[funcName] = self.controller[funcName]
        end
    end
end

function AntiCheatManager:disable()
    if not self.controller then 
        print("❌ Controller not exist!")
        return false
    end
    
    if self.enabled then
        print("⚠️ Already deactivated! Please use toggle()!")
        return false
    end
    
    local emptyFunc = function() end
    self.controller.onStart = emptyFunc
    self.controller.onTick = emptyFunc
    self.controller.onCharacterAdded = emptyFunc
    self.controller.checkWalkSpeed = emptyFunc
    self.controller.checkJumpHeight = emptyFunc
    self.controller.checkUseJumpPower = emptyFunc
    self.controller.handleGuiName = emptyFunc
    
    self.enabled = true
    return true
end

function AntiCheatManager:enable()
    if not self.controller then 
        print("❌ Controller nicht verfügbar")
        return false
    end
    
    if not self.enabled then
        print("⚠️ Already activated! Please use toggle()!")
        return false
    end
    
    for funcName, originalFunc in pairs(self.originalFunctions) do
        if self.controller[funcName] then
            self.controller[funcName] = originalFunc
        end
    end
    
    self.enabled = false
    return true
end

-- Toggling
function AntiCheatManager:toggle()
    if self.enabled then
        return self:enable() 
    else
        return self:disable()
    end
end

-- Get AC Status
function AntiCheatManager:getStatus()
    return self.enabled and "aktiviert" or "deaktiviert"
end

return AntiCheatManager
