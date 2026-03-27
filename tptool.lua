local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TPButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Setup GUI Utama
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -60, 0.4, 0)
Frame.Size = UDim2.new(0, 120, 0, 175) -- Sedikit lebih tinggi untuk ruang tombol atas
Frame.Active = true
Frame.Draggable = true

-- Tombol Exit (X)
local ExitBtn = Instance.new("TextButton")
ExitBtn.Parent = Frame
ExitBtn.Text = "X"
ExitBtn.Size = UDim2.new(0, 20, 0, 20)
ExitBtn.Position = UDim2.new(1, -25, 0, 5)
ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitBtn.Font = Enum.Font.SourceSansBold
ExitBtn.TextSize = 14
local ExitCorner = Instance.new("UICorner", ExitBtn)
ExitCorner.CornerRadius = UDim.new(0, 5)

-- Tombol Minimize (-)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = Frame
MiniBtn.Text = "-"
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Position = UDim2.new(1, -50, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 14
local MiniCorner = Instance.new("UICorner", MiniBtn)
MiniCorner.CornerRadius = UDim.new(0, 5)

local function createBtn(btn, name, pos, color, text)
    btn.Name = name
    btn.Parent = Frame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    local cl = Instance.new("UICorner")
    cl.CornerRadius = UDim.new(0, 8)
    cl.Parent = btn
end

-- Posisi tombol diturunkan sedikit agar tidak tabrakan dengan Exit/Mini
createBtn(TPButton, "TP", UDim2.new(0, 10, 0, 30), Color3.fromRGB(0, 120, 255), "TP Tool")
createBtn(NoclipButton, "Noclip", UDim2.new(0, 10, 0, 75), Color3.fromRGB(60, 60, 60), "Noclip: OFF")
createBtn(FlyButton, "Fly", UDim2.new(0, 10, 0, 120), Color3.fromRGB(200, 0, 0), "Fly: OFF")

-- Logic Exit & Minimize
ExitBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local minimized = false
MiniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame:TweenSize(UDim2.new(0, 120, 0, 30), "Out", "Quad", 0.3, true)
        TPButton.Visible = false
        NoclipButton.Visible = false
        FlyButton.Visible = false
        MiniBtn.Text = "+"
    else
        Frame:TweenSize(UDim2.new(0, 120, 0, 175), "Out", "Quad", 0.3, true)
        TPButton.Visible = true
        NoclipButton.Visible = true
        FlyButton.Visible = true
        MiniBtn.Text = "-"
    end
end)

-- FITUR ASLI (TIDAK DIRUBAH)
TPButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Allzzy/MyScripts/main/tptool.lua"))()
end)

local noclip = false
NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    NoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

local flying = false
local speed = 2
local keys = {w = false, s = false, a = false, d = false}
local lp = game.Players.LocalPlayer

FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    FlyButton.Text = flying and "Fly: ON" or "Fly: OFF"
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    local char = lp.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if flying then
        hum.PlatformStand = true
        local bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0, 0.1, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flying and char and hrp do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new(0,0,0)
                if keys.w then moveDir = moveDir + cam.LookVector end
                if keys.s then moveDir = moveDir - cam.LookVector end
                if keys.a then moveDir = moveDir - cam.RightVector end
                if keys.d then moveDir = moveDir + cam.RightVector end
                bv.Velocity = moveDir * (speed * 50)
                bg.CFrame = cam
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if hum then hum.PlatformStand = false end
        end)
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.W then keys.w = true
    elseif k == Enum.KeyCode.S then keys.s = true
    elseif k == Enum.KeyCode.A then keys.a = true
    elseif k == Enum.KeyCode.D then keys.d = true end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    local k = input.KeyCode
    if k == Enum.KeyCode.W then keys.w = false
    elseif k == Enum.KeyCode.S then keys.s = false
    elseif k == Enum.KeyCode.A then keys.a = false
    elseif k == Enum.KeyCode.D then keys.d = false end
end)
