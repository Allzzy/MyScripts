local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TPButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Setup GUI Utama
ScreenGui.Name = "MyCustomMenu"
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.3 
Frame.Position = UDim2.new(0.5, -60, 0.4, 0)
Frame.Size = UDim2.new(0, 120, 0, 175) 
Frame.Active = true
Frame.Draggable = true

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

-- Tombol X dan -
local ExitBtn = Instance.new("TextButton")
ExitBtn.Parent = Frame
ExitBtn.Text = "X"
ExitBtn.Size = UDim2.new(0, 20, 0, 20)
ExitBtn.Position = UDim2.new(1, -25, 0, 5)
ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 5)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = Frame
MiniBtn.Text = "-"
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Position = UDim2.new(1, -50, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 5)

createBtn(TPButton, "TP", UDim2.new(0, 10, 0, 30), Color3.fromRGB(0, 120, 255), "TP Tool")
createBtn(NoclipButton, "Noclip", UDim2.new(0, 10, 0, 75), Color3.fromRGB(60, 60, 60), "Noclip: OFF")
createBtn(FlyButton, "Fly", UDim2.new(0, 10, 0, 120), Color3.fromRGB(200, 0, 0), "Fly: OFF")

ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

--- === FIX IY FLY (STABLE / TIDAK MEROSOT) === ---
local iyfly = false
local flySpeed = 1
local flyConn
local uis = game:GetService("UserInputService")

FlyButton.MouseButton1Click:Connect(function()
    iyfly = not iyfly
    FlyButton.Text = iyfly and "Fly: ON" or "Fly: OFF"
    FlyButton.BackgroundColor3 = iyfly and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if iyfly then
        -- BV (Velocity) untuk gerak
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) -- Dikasih tenaga penuh biar nggak turun
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Name = "IYFlyBV"
        bv.Parent = hrp
        
        -- BG (Gyro) untuk jaga rotasi
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 10000
        bg.Name = "IYFlyBG"
        bg.Parent = hrp

        hum.PlatformStand = true
        
        flyConn = game:GetService("RunService").Heartbeat:Connect(function()
            local direction = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera.CFrame
            
            if uis:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
            
            bv.Velocity = direction * (flySpeed * 50)
            -- Jaga agar karakter selalu hadap depan kamera
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
        end)
    else
        if flyConn then flyConn:Disconnect() end
        hum.PlatformStand = false
        if hrp:FindFirstChild("IYFlyBV") then hrp.IYFlyBV:Destroy() end
        if hrp:FindFirstChild("IYFlyBG") then hrp.IYFlyBG:Destroy() end
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end)

--- === TP TOOL & NOCLIP (TETAP SAMA) === ---
TPButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local toolName = "Click Teleport"
    local existingTool = player.Backpack:FindFirstChild(toolName) or player.Character:FindFirstChild(toolName)
    if existingTool then
        existingTool:Destroy()
        TPButton.Text = "TP Tool: OFF"
        TPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    else
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = toolName
        tool.Activated:Connect(function()
            player.Character:MoveTo(player:GetMouse().Hit.p + Vector3.new(0, 3, 0))
        end)
        tool.Parent = player.Backpack
        TPButton.Text = "TP Tool: ON"
        TPButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end
end)

local noclip = false
NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    NoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
end)

game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = not noclip end
        end
    end
end)
