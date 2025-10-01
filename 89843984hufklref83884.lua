local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "drqnzHUB",
    SubTitle = "by drqnz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
})

local Tabs = {
Misc = Window:AddTab({ Title = "Misc", Icon = "box" }),
Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Players          = game:GetService("Players")
local StarterPlayer    = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local function destroyFlashbangGui()
    local uiFolder = StarterPlayerScripts:FindFirstChild("UserInterface")
    if uiFolder then
        local gui = uiFolder:FindFirstChild("FlashbangGui")
        if gui then gui:Destroy() end
    end

    local localPlayer = Players.LocalPlayer
    if localPlayer then
        local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
        if playerScripts then
            local uiFolder2 = playerScripts:FindFirstChild("UserInterface")
            if uiFolder2 then
                local gui2 = uiFolder2:FindFirstChild("FlashbangGui")
                if gui2 then gui2:Destroy() end
            end
        end
    end
end

local FlashbangToggle = Tabs.Misc:AddToggle("RemoveFlashbang", {
    Title       = "Remove Flashbang Effect",
    Default     = false,
    Description = "Destroy FlashbangGui (REJOIN TO RESTORE)",
})

FlashbangToggle:OnChanged(function(isOn)
    if isOn then
        destroyFlashbangGui()
        print("[Flashbang] GUI destroyed")
    else
        print("[Flashbang] Toggle OFF – nothing to do")
    end
end)

local platformMap = {
    PC     = "MouseKeyboard",
    Mobile = "Touch",
    Console= "Gamepad",
    VR     = "VR",
}

local ControlDropdown = Tabs.Misc:AddDropdown("SetControls", {
    Title       = "Set Controls",
    Description = "Choose your platform type",
    Values      = {"PC", "Mobile", "Console", "VR"},
    Multi       = false,
    Default     = 1, -- 1 = PC
})


local Replicated = game:GetService("ReplicatedStorage")
local Remotes    = Replicated:WaitForChild("Remotes")
local Replication = Remotes:WaitForChild("Replication")
local Fighter    = Replication:WaitForChild("Fighter")
local SetControls = Fighter:WaitForChild("SetControls")  -- RemoteEvent

ControlDropdown:OnChanged(function(selected)
    local platformName = platformMap[selected]
    if platformName then
        
        SetControls:FireServer(platformName)

        print("[Controls] Set platform to", platformName)
    else
        warn("[Controls] Unknown selection:", selected)
    end
end)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
