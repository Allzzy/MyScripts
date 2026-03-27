-- [[ TP TOOL HOTBAR - AUTO SAVE POSITION ]] --
local HttpService = game:GetService("HttpService")
local FileName = "TPTool_Pos.json"

-- Fungsi Simpan & Load Posisi
local function SaveConfig(pos)
    local data = {X = pos.X.Scale, XO = pos.X.Offset, Y = pos.Y.Scale, YO = pos.Y.Offset}
    writefile(FileName, HttpService:JSONEncode(data))
end

local function LoadConfig()
    if isfile(FileName) then
        local data = HttpService:JSONDecode(readfile(FileName))
        return UDim2.new(data.X, data.XO, data.Y, data.YO)
    end
    return UDim2.new(0.5, -80, 0.9, -60) -- Default: Bawah Tengah
end

-- UI Setup
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", SG)

Main.Size = UDim2.new(0, 160, 0, 40)
Main.Position = LoadConfig()
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

-- Simpan posisi otomatis pas berhenti digeser
Main.DragStopped:Connect(function()
    SaveConfig(Main.Position)
end)

local Layout = Instance.new("UIListLayout", Main)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center

local function MakeBtn(txt, col, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 45, 0, 30)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- Fitur
MakeBtn("TP", Color3.fromRGB(0, 120, 255), function()
    local t = Instance.new("Tool", lp.Backpack)
    t.Name = "Click TP"
    t.RequiresHandle = false
    t.Activated:Connect(function()
        if lp.Character then lp.Character:MoveTo(mouse.Hit.p) end
    end)
end)

local isMini = false
MakeBtn("-", Color3.fromRGB(60, 60, 60), function()
    isMini = not isMini
    Main.BackgroundTransparency = isMini and 1 or 0
    for _, v in pairs(Main:GetChildren()) do
        if v:IsA("TextButton") and v.Text ~= "-" then v.Visible = not isMini end
    end
end)

MakeBtn("X", Color3.fromRGB(200, 50, 50), function() SG:Destroy() end)
