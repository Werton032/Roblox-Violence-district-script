-- Violence District OP HUB
-- by Werton | TG: t.me/+WNSQE9ikwtcxYTQ6

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ====================== CONFIG ======================
local Config = {
    ESP = false, Godmode = false, Fly = false, NoClip = false,
    AntiFlash = false, Speed = false, Jump = false, BodyBlock = false,
    WalkSpeed = 50, FlySpeed = 80, JumpPower = 70,
    Accent = Color3.fromRGB(170, 0, 30),
    BG = Color3.fromRGB(14, 14, 16), BG2 = Color3.fromRGB(20, 20, 24), BG3 = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(235, 235, 240), TextDim = Color3.fromRGB(140, 140, 150),
    ColorSurvivor = Color3.fromRGB(190, 0, 255), ColorKiller = Color3.fromRGB(255, 25, 25)
}

local Cache = {
    Highlights = {}, Billboards = {}, BodyBlockTarget = nil,
    Tabs = {}, CurrentTab = nil, TPButtons = {}
}

-- ====================== ROLE DETECTION ======================
local KillerKeywords = {"killer", "maniac", "slasher", "murder", "hunter", "demon", "psycho"}

local function IsKiller(plr)
    if not plr or not plr.Character then return false end
    if plr.Team then
        local tname = plr.Team.Name:lower()
        for _, k in KillerKeywords do if tname:find(k) then return true end end
    end
    local char = plr.Character
    for _, k in KillerKeywords do
        if char:FindFirstChild(k) or char:FindFirstChild(k:upper()) or char:FindFirstChild(k:sub(1,1):upper() .. k:sub(2)) then return true end
    end
    for _, item in char:GetChildren() do
        if item:IsA("Tool") then
            local iname = item.Name:lower()
            if iname:find("knife") or iname:find("axe") or iname:find("machete") or iname:find("chainsaw") or iname:find("blade") or iname:find("weapon") then return true end
        end
    end
    if plr:FindFirstChild("leaderstats") then
        local role = plr.leaderstats:FindFirstChild("Role") or plr.leaderstats:FindFirstChild("Class") or plr.leaderstats:FindFirstChild("Team")
        if role and role:IsA("StringValue") then
            local rname = role.Value:lower()
            for _, k in KillerKeywords do if rname:find(k) then return true end end
        end
    end
    return false
end

-- ====================== UI BASE ======================
if game.CoreGui:FindFirstChild("VDHub") then game.CoreGui.VDHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 380)
Main.Position = UDim2.new(0.5, -290, 0.5, -190)
Main.BackgroundColor3 = Config.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 45)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Config.BG2
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, 0)
TopLine.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(0, 3, 0, 20)
AccentBar.Position = UDim2.new(0, 14, 0.5, -10)
AccentBar.BackgroundColor3 = Config.Accent
AccentBar.BorderSizePixel = 0
AccentBar.Parent = TopBar
Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(0, 200, 1, 0)
LogoText.Position = UDim2.new(0, 28, 0, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "VIOLENCE"
LogoText.TextColor3 = Config.Text
LogoText.TextSize = 14
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = TopBar

local SubLogo = Instance.new("TextLabel")
SubLogo.Size = UDim2.new(0, 200, 1, 0)
SubLogo.Position = UDim2.new(0, 95, 0, 0)
SubLogo.BackgroundTransparency = 1
SubLogo.Text = "DISTRICT HUB"
SubLogo.TextColor3 = Config.TextDim
SubLogo.TextSize = 14
SubLogo.Font = Enum.Font.GothamMedium
SubLogo.TextXAlignment = Enum.TextXAlignment.Left
SubLogo.Parent = TopBar

-- USERNAME BADGE (CLICKABLE TG LINK)
local UserBadge = Instance.new("TextButton")
UserBadge.Size = UDim2.new(0, 120, 0, 22)
UserBadge.Position = UDim2.new(1, -180, 0.5, -11)
UserBadge.BackgroundColor3 = Config.BG3
UserBadge.Text = "Werton"
UserBadge.TextColor3 = Config.Accent
UserBadge.TextSize = 12
UserBadge.Font = Enum.Font.GothamBold
UserBadge.BorderSizePixel = 0
UserBadge.AutoButtonColor = false
UserBadge.Parent = TopBar
Instance.new("UICorner", UserBadge).CornerRadius = UDim.new(0, 6)

UserBadge.MouseButton1Click:Connect(function()
    local link = "https://t.me/+WNSQE9ikwtcxYTQ6"
    if setclipboard then pcall(setclipboard, link) end
    Notify("TG link copied! " .. link, 4)
end)
UserBadge.MouseEnter:Connect(function()
    TweenService:Create(UserBadge, TweenInfo.new(0.15), {BackgroundColor3 = Config.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
end)
UserBadge.MouseLeave:Connect(function()
    TweenService:Create(UserBadge, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG3, TextColor3 = Config.Accent}):Play()
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Config.TextDim
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Config.TextDim}):Play()
end)

local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Config.BG2
SideBar.BorderSizePixel = 0
SideBar.Parent = Main
Instance.new("UIStroke", SideBar).Color = Color3.fromRGB(40, 40, 45)

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, -16, 1, -16)
TabList.Position = UDim2.new(0, 8, 0, 8)
TabList.BackgroundTransparency = 1
TabList.Parent = SideBar
Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 4)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -40)
Content.Position = UDim2.new(0, 140, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ====================== TAB SYSTEM ======================
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 34)
    TabBtn.BackgroundColor3 = Config.BG2
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = ""
    TabBtn.Parent = TabList
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 24, 1, 0)
    TabIcon.Position = UDim2.new(0, 10, 0, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = icon
    TabIcon.TextColor3 = Config.TextDim
    TabIcon.TextSize = 14
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.Parent = TabBtn

    local TabName = Instance.new("TextLabel")
    TabName.Size = UDim2.new(1, -40, 1, 0)
    TabName.Position = UDim2.new(0, 38, 0, 0)
    TabName.BackgroundTransparency = 1
    TabName.Text = name
    TabName.TextColor3 = Config.TextDim
    TabName.TextSize = 13
    TabName.Font = Enum.Font.GothamMedium
    TabName.TextXAlignment = Enum.TextXAlignment.Left
    TabName.Parent = TabBtn

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Size = UDim2.new(0, 2, 0, 16)
    TabIndicator.Position = UDim2.new(0, 0, 0.5, -8)
    TabIndicator.BackgroundColor3 = Config.Accent
    TabIndicator.BorderSizePixel = 0
    TabIndicator.Visible = false
    TabIndicator.Parent = TabBtn
    Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(1, 0)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Config.Accent
    Page.Visible = false
    Page.Parent = Content
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local tab = {Button = TabBtn, Page = Page, Icon = TabIcon, Name = TabName, Indicator = TabIndicator, Layout = PageLayout}
    table.insert(Cache.Tabs, tab)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in Cache.Tabs do
            t.Page.Visible = false
            t.Indicator.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(t.Name, TweenInfo.new(0.15), {TextColor3 = Config.TextDim}):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.15), {TextColor3 = Config.TextDim}):Play()
        end
        Page.Visible = true
        TabIndicator.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG3, BackgroundTransparency = 0}):Play()
        TweenService:Create(TabName, TweenInfo.new(0.15), {TextColor3 = Config.Text}):Play()
        TweenService:Create(TabIcon, TweenInfo.new(0.15), {TextColor3 = Config.Accent}):Play()
        Cache.CurrentTab = tab
    end)
    return tab
end

-- ====================== COMPONENTS ======================
local function AddSection(page, name)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 22)
    sec.BackgroundTransparency = 1
    sec.Parent = page
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    line.BorderSizePixel = 0
    line.Parent = sec
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = Config.Accent
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sec
end

local function AddToggle(page, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Config.BG2
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(40, 40, 45)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local switchBG = Instance.new("Frame")
    switchBG.Size = UDim2.new(0, 38, 0, 18)
    switchBG.Position = UDim2.new(1, -50, 0.5, -9)
    switchBG.BackgroundColor3 = Config.BG3
    switchBG.BorderSizePixel = 0
    switchBG.Parent = btn
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Config.TextDim
    knob.BorderSizePixel = 0
    knob.Parent = switchBG
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 30, 1, 0)
    statusLbl.Position = UDim2.new(1, -90, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "OFF"
    statusLbl.TextColor3 = Config.TextDim
    statusLbl.TextSize = 10
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.Parent = btn

    btn.MouseEnter:Connect(function()
        if not state then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG3}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if not state then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG2}):Play() end
    end)

    btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        if state then
            TweenService:Create(switchBG, TweenInfo.new(0.2), {BackgroundColor3 = Config.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -7), BackgroundColor3 = Color3.new(1,1,1)}):Play()
            statusLbl.Text = "ON"
            statusLbl.TextColor3 = Config.Accent
        else
            TweenService:Create(switchBG, TweenInfo.new(0.2), {BackgroundColor3 = Config.BG3}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Config.TextDim}):Play()
            statusLbl.Text = "OFF"
            statusLbl.TextColor3 = Config.TextDim
        end
    end)
    return btn
end

local function AddButton(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Config.BG2
    btn.Text = text
    btn.TextColor3 = Config.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 40, 45)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG3}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Config.Accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG2}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function Notify(text, duration)
    duration = duration or 3
    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0, 0, 0, 38)
    nf.Position = UDim2.new(1, -20, 0, 80 + (#ScreenGui:GetChildren() * 45))
    nf.AnchorPoint = Vector2.new(1, 0)
    nf.BackgroundColor3 = Config.BG2
    nf.BorderSizePixel = 0
    nf.Parent = ScreenGui
    Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", nf).Color = Config.Accent

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -10)
    accent.Position = UDim2.new(0, 6, 0.5, 0)
    accent.AnchorPoint = Vector2.new(0, 0.5)
    accent.BackgroundColor3 = Config.Accent
    accent.BorderSizePixel = 0
    accent.Parent = nf
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 1, 0)
    lbl.Position = UDim2.new(0, 18, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Config.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = nf

    TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 240, 0, 38)}):Play()
    task.wait(duration)
    TweenService:Create(nf, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 38)}):Play()
    task.wait(0.3)
    nf:Destroy()
end

-- ====================== CORE FUNCTIONS ======================
local function CleanESP()
    for _, v in Cache.Highlights do if v then v:Destroy() end end
    for _, v in Cache.Billboards do if v then v:Destroy() end end
    table.clear(Cache.Highlights)
    table.clear(Cache.Billboards)
end

local function UpdateESP()
    CleanESP()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local mypos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then continue end
        local killer = IsKiller(plr)
        local color = killer and Config.ColorKiller or Config.ColorSurvivor

        local hl = Instance.new("Highlight")
        hl.Adornee = plr.Character
        hl.FillColor = color
        hl.OutlineColor = color
        hl.FillTransparency = 0.65
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = plr.Character
        Cache.Highlights[plr] = hl

        local bb = Instance.new("BillboardGui")
        bb.Adornee = plr.Character.HumanoidRootPart
        bb.Size = UDim2.new(0, 200, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = plr.Character

        local dist = math.floor((plr.Character.HumanoidRootPart.Position - mypos).Magnitude)
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 0, 18)
        txt.BackgroundTransparency = 1
        txt.Text = plr.Name
        txt.TextColor3 = color
        txt.TextSize = 15
        txt.Font = Enum.Font.GothamBold
        txt.TextStrokeTransparency = 0
        txt.TextStrokeColor3 = Color3.new(0,0,0)
        txt.Parent = bb

        local dtxt = Instance.new("TextLabel")
        dtxt.Size = UDim2.new(1, 0, 0, 16)
        dtxt.Position = UDim2.new(0, 0, 0, 18)
        dtxt.BackgroundTransparency = 1
        dtxt.Text = `[{dist}m] {killer and "KILLER" or "SURVIVOR"}`
        dtxt.TextColor3 = color
        dtxt.TextSize = 12
        dtxt.Font = Enum.Font.GothamBold
        dtxt.TextStrokeTransparency = 0
        dtxt.TextStrokeColor3 = Color3.new(0,0,0)
        dtxt.Parent = bb
        Cache.Billboards[plr] = bb
    end
end

local function UpdateESPDistance()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local mypos = LocalPlayer.Character.HumanoidRootPart.Position
    for plr, bb in Cache.Billboards do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and bb and bb.Parent then
            local dist = math.floor((plr.Character.HumanoidRootPart.Position - mypos).Magnitude)
            local killer = IsKiller(plr)
            local dlbl = bb:GetChildren()[2]
            if dlbl and dlbl:IsA("TextLabel") then
                dlbl.Text = `[{dist}m] {killer and "KILLER" or "SURVIVOR"}`
            end
        end
    end
end

local function EnableGodmode()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local hum = char.Humanoid
    hum.MaxHealth = 9999
    hum.Health = 9999
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.HealthChanged:Connect(function(h)
        if Config.Godmode and h < 9999 then hum.Health = 9999 end
    end)
end

-- ====================== TABS ======================
local TabMain = CreateTab("Main", "◆")
local TabVisual = CreateTab("Visual", "◇")
local TabPlayers = CreateTab("Players", "◈")
local TabMisc = CreateTab("Misc", "◉")

AddSection(TabMain.Page, "Movement")
AddToggle(TabMain.Page, "Fly", function(v) Config.Fly = v end)
AddToggle(TabMain.Page, "NoClip", function(v) Config.NoClip = v end)
AddToggle(TabMain.Page, "Speed Boost", function(v) Config.Speed = v end)
AddToggle(TabMain.Page, "Jump Enable", function(v) Config.Jump = v end)
AddButton(TabMain.Page, "+ Speed (+10)", function() Config.WalkSpeed += 10 Notify(`Speed: {Config.WalkSpeed}`) end)
AddButton(TabMain.Page, "- Speed (-10)", function() Config.WalkSpeed = math.max(16, Config.WalkSpeed - 10) Notify(`Speed: {Config.WalkSpeed}`) end)

AddSection(TabMain.Page, "Combat")
AddToggle(TabMain.Page, "Godmode", function(v) Config.Godmode = v if v then EnableGodmode() end end)
AddToggle(TabMain.Page, "Body Block", function(v) Config.BodyBlock = v if not v then Cache.BodyBlockTarget = nil end end)

AddSection(TabVisual.Page, "ESP")
AddToggle(TabVisual.Page, "Player ESP", function(v) Config.ESP = v if not v then CleanESP() end end)
AddToggle(TabVisual.Page, "Anti Flash", function(v) Config.AntiFlash = v end)

AddSection(TabVisual.Page, "World")
AddButton(TabVisual.Page, "Full Bright", function()
    Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.FogEnd = 99999; Lighting.GlobalShadows = false
    Notify("Full Bright enabled")
end)

local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Size = UDim2.new(1, 0, 0, 18)
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.Text = "Click player → Teleport / Body Block target"
PlayerListLabel.TextColor3 = Config.TextDim
PlayerListLabel.TextSize = 11
PlayerListLabel.Font = Enum.Font.GothamMedium
PlayerListLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerListLabel.Parent = TabPlayers.Page

AddButton(TabPlayers.Page, "🔄 Refresh Player List", function()
    for _, b in Cache.TPButtons do if b and b.Parent then b:Destroy() end end
    table.clear(Cache.TPButtons)
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then continue end
        local role = IsKiller(plr) and "[K]" or "[S]"
        local roleColor = IsKiller(plr) and Config.ColorKiller or Config.ColorSurvivor
        local pbtn = Instance.new("TextButton")
        pbtn.Size = UDim2.new(1, 0, 0, 30)
        pbtn.BackgroundColor3 = Config.BG2
        pbtn.Text = ""
        pbtn.AutoButtonColor = false
        pbtn.Parent = TabPlayers.Page
        Instance.new("UICorner", pbtn).CornerRadius = UDim.new(0, 6)
        local pstroke = Instance.new("UIStroke", pbtn)
        pstroke.Color = Color3.fromRGB(40, 40, 45)

        local rlbl = Instance.new("TextLabel")
        rlbl.Size = UDim2.new(0, 30, 1, 0)
        rlbl.Position = UDim2.new(0, 8, 0, 0)
        rlbl.BackgroundTransparency = 1
        rlbl.Text = role
        rlbl.TextColor3 = roleColor
        rlbl.TextSize = 12
        rlbl.Font = Enum.Font.GothamBold
        rlbl.Parent = pbtn

        local nlbl = Instance.new("TextLabel")
        nlbl.Size = UDim2.new(1, -50, 1, 0)
        nlbl.Position = UDim2.new(0, 42, 0, 0)
        nlbl.BackgroundTransparency = 1
        nlbl.Text = plr.Name
        nlbl.TextColor3 = Config.Text
        nlbl.TextSize = 12
        nlbl.Font = Enum.Font.GothamMedium
        nlbl.TextXAlignment = Enum.TextXAlignment.Left
        nlbl.Parent = pbtn

        pbtn.MouseEnter:Connect(function()
            TweenService:Create(pbtn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG3}):Play()
            TweenService:Create(pstroke, TweenInfo.new(0.15), {Color = Config.Accent}):Play()
        end)
        pbtn.MouseLeave:Connect(function()
            TweenService:Create(pbtn, TweenInfo.new(0.15), {BackgroundColor3 = Config.BG2}):Play()
            TweenService:Create(pstroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 40, 45)}):Play()
        end)
        pbtn.MouseButton1Click:Connect(function()
            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then Notify(`{plr.Name} has no character`) return end
            if Config.BodyBlock then
                Cache.BodyBlockTarget = plr
                Notify(`Body Block target: {plr.Name}`)
            else
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    Notify(`Teleported to {plr.Name}`)
                end
            end
        end)
        table.insert(Cache.TPButtons, pbtn)
    end
    Notify(`Refreshed: {#Cache.TPButtons} players`)
end)

AddSection(TabMisc.Page, "Info")
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 100)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "VIOLENCE DISTRICT HUB\n\nCreated by Werton\nTG: t.me/+WNSQE9ikwtcxYTQ6\n\nHotkey: G - Toggle Menu\nVersion: 3.1"
InfoLabel.TextColor3 = Config.TextDim
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.TextWrapped = true
InfoLabel.Parent = TabMisc.Page

task.spawn(function()
    task.wait(0.1)
    Cache.Tabs[1].Page.Visible = true
    Cache.Tabs[1].Indicator.Visible = true
    Cache.Tabs[1].Button.BackgroundTransparency = 0
    Cache.Tabs[1].Button.BackgroundColor3 = Config.BG3
    Cache.Tabs[1].Name.TextColor3 = Config.Text
    Cache.Tabs[1].Icon.TextColor3 = Config.Accent
end)

Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 580, 0, 380), Position = UDim2.new(0.5, -290, 0.5, -190)
}):Play()

RunService.Heartbeat:Connect(function()
    for _, t in Cache.Tabs do t.Page.CanvasSize = UDim2.new(0, 0, 0, t.Layout.AbsoluteContentSize.Y + 20) end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = LocalPlayer.Character.HumanoidRootPart
    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not hum then return end

    if Config.Speed then hum.WalkSpeed = Config.WalkSpeed end
    if Config.Jump then hum.JumpPower = Config.JumpPower hum.UseJumpPower = true hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end
    if Config.BodyBlock and Cache.BodyBlockTarget and Cache.BodyBlockTarget.Character then
        local troot = Cache.BodyBlockTarget.Character:FindFirstChild("HumanoidRootPart")
        if troot then root.CFrame = CFrame.new(troot.Position + (troot.CFrame.LookVector * 2.5)) end
    end
    if Config.Fly then
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        root.AssemblyLinearVelocity = dir.Magnitude > 0 and dir.Unit * Config.FlySpeed or Vector3.new()
    end
    if Config.NoClip then
        for _, v in LocalPlayer.Character:GetDescendants() do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if Config.AntiFlash then
        for _, v in LocalPlayer.PlayerGui:GetDescendants() do
            if (v.Name:lower():find("flash") or v.Name:lower():find("blind")) and (v:IsA("Frame") or v:IsA("ImageLabel")) then v.Visible = false end
        end
    end
end)

task.spawn(function() while task.wait(0.4) do if Config.ESP then UpdateESP() end end end)
task.spawn(function() while task.wait(0.1) do if Config.ESP then UpdateESPDistance() end end end)

LocalPlayer.CharacterAdded:Connect(function() task.wait(1.2) if Config.Godmode then EnableGodmode() end end)
Players.PlayerRemoving:Connect(function(plr)
    if Cache.BodyBlockTarget == plr then Cache.BodyBlockTarget = nil end
    if Cache.Highlights[plr] then Cache.Highlights[plr]:Destroy() Cache.Highlights[plr] = nil end
    if Cache.Billboards[plr] then Cache.Billboards[plr]:Destroy() Cache.Billboards[plr] = nil end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then Main.Visible = not Main.Visible end
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.3)
    Main.Visible = false
    Main.Size = UDim2.new(0, 580, 0, 380)
    Main.Position = UDim2.new(0.5, -290, 0.5, -190)
end)

task.spawn(function()
    Notify("Welcome back, Werton", 4)
    task.wait(0.6)
    Notify("TG: t.me/+WNSQE9ikwtcxYTQ6", 4)
    task.wait(0.6)
    Notify("Press G to toggle menu", 3)
end)
