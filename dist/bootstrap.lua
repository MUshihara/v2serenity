-- Serenity key-window UI test. Authentication is intentionally not connected.
-- This file contains the entire window; it does not load the dashboard or games.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
assert(player, "Serenity key window requires a local player")
local environment = _G
if type(getgenv) == "function" then
    local ok, value = pcall(getgenv)
    if ok and type(value) == "table" then environment = value end
end
local previous = environment.__SerenityKeyWindowTest
if type(previous) == "table" and type(previous.Destroy) == "function" then
    pcall(function() previous:Destroy() end)
end

local connections, tweens = {}, {}
local destroyed, closing = false, false
local controller = {}
local colors = {
    navy = Color3.fromRGB(13, 28, 49),
    glass = Color3.fromRGB(26, 47, 76),
    text = Color3.fromRGB(238, 244, 252),
    muted = Color3.fromRGB(167, 188, 219),
    cyan = Color3.fromRGB(48, 202, 244),
    lavender = Color3.fromRGB(159, 137, 223),
    ivory = Color3.fromRGB(249, 233, 198),
    error = Color3.fromRGB(255, 149, 157),
}
local function bind(signal, callback)
    local connection = signal:Connect(callback)
    connections[#connections + 1] = connection
    return connection
end
local function make(class, properties, parent)
    local object = Instance.new(class)
    for key, value in pairs(properties or {}) do object[key] = value end
    object.Parent = parent
    return object
end
local function round(object, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end
local function stroke(object, color, transparency, thickness)
    return make("UIStroke", {
        Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, object)
end
local function animate(object, duration, properties)
    if destroyed then return end
    local active = tweens[object]
    if active then active:Cancel() end
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tweens[object] = tween
    tween:Play()
end
local function text(parent, content, size, position, dimensions, color, bold)
    return make("TextLabel", {
        BackgroundTransparency = 1, Text = content,
        TextColor3 = color or colors.text, TextSize = size,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Position = position, Size = dimensions,
    }, parent)
end

local gui = make("ScreenGui", {
    Name = "Serenity_KeyWindow_Test", ResetOnSpawn = false,
    IgnoreGuiInset = false, DisplayOrder = 150,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local parented = false
if type(gethui) == "function" then
    local ok, parent = pcall(gethui)
    if ok and parent then parented = pcall(function() gui.Parent = parent end) end
end
if not parented then
    parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
end
if not parented then gui.Parent = player:WaitForChild("PlayerGui") end

local viewport = make("Frame", {
    Name = "SafeViewport", BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1), Active = false,
}, gui)
-- Measure inherited GUI scaling separately from the window's own UIScale.
local scaleProbe = make("Frame", {
    Name = "ScaleProbe", BackgroundTransparency = 1,
    Size = UDim2.fromOffset(100, 100), Active = false,
}, viewport)
local panel = make("CanvasGroup", {
    Name = "KeyWindow", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(552, 380),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1,
    GroupColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0, GroupTransparency = 1, ClipsDescendants = true,
}, viewport)
round(panel, 18)
local edge = stroke(panel, Color3.fromRGB(255, 255, 255), 0.08, 1.5)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(134, 188, 245)),
        ColorSequenceKeypoint.new(1, colors.lavender),
    }), Rotation = 32,
}, edge)
-- A gradient on CanvasGroup tints its entire rendered subtree. Keep the
-- group neutral and shade only this background frame. White is intentional:
-- UIGradient multiplies the underlying color rather than replacing it.
local background = make("Frame", {
    Name = "GlassBackground", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.025, BorderSizePixel = 0,
    ZIndex = 0, Active = false,
}, panel)
round(background, 18)
make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 50, 83)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(17, 34, 59)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(21, 35, 65)),
    }), Rotation = 35,
}, background)
local scaling = make("UIScale", {Scale = 1}, panel)
local header = make("Frame", {
    Name = "Header", BackgroundColor3 = colors.glass,
    BackgroundTransparency = 0.68, BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 56),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
}, header)
-- The compass uses native GUI shapes; no external image asset is required.
local emblem = make("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(24, 12),
    Size = UDim2.fromOffset(32, 32),
}, header)
for i = 0, 11 do
    local distance = i / 11
    local thickness = math.max(1, math.floor(32 * 0.32 * (1 - distance) ^ 2))
    for _, axis in ipairs({0, 1}) do
        for _, sign in ipairs({-1, 1}) do
            make("Frame", {
                BorderSizePixel = 0, BackgroundColor3 = colors.ivory,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(axis == 0 and thickness or 1.4, axis == 0 and 1.4 or thickness),
                Position = UDim2.fromOffset(16 + (axis == 1 and sign * distance * 14.7 or 0), 16 + (axis == 0 and sign * distance * 14.7 or 0)),
            }, emblem)
        end
    end
end
text(header, "SERENITY HUB", 20, UDim2.fromOffset(69, 0), UDim2.fromOffset(280, 56), colors.text, true)
local close = make("TextButton", {
    Name = "Close", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.6, Text = "×",
    TextColor3 = colors.muted, TextSize = 30, Font = Enum.Font.Gotham,
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 6),
    Size = UDim2.fromOffset(44, 44), AutoButtonColor = false,
}, header)

round(close, 8)
stroke(close, colors.muted, 0.75)
local body = make("CanvasGroup", {
    Name = "Body", BackgroundTransparency = 1, BorderSizePixel = 0,
    GroupTransparency = 0, GroupColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 1, -120),
    ClipsDescendants = false,
}, panel)
local title = text(body, "Welcome to Serenity", 26, UDim2.fromOffset(24, 12), UDim2.new(1, -48, 0, 32), colors.text, true)
title.TextXAlignment = Enum.TextXAlignment.Center
local subtitle = text(body, "Enter your key to continue.", 16, UDim2.fromOffset(24, 47), UDim2.new(1, -48, 0, 24), colors.muted)
subtitle.TextXAlignment = Enum.TextXAlignment.Center
text(body, "License key", 15, UDim2.fromOffset(28, 81), UDim2.new(1, -56, 0, 22), colors.text, true)
local inputShell = make("Frame", {
    BackgroundColor3 = colors.glass, BackgroundTransparency = 0.28,
    Position = UDim2.fromOffset(28, 108), Size = UDim2.new(1, -56, 0, 48),
    BorderSizePixel = 0,
}, body)
round(inputShell, 9)
local inputEdge = stroke(inputShell, colors.muted, 0.52)
local input = make("TextBox", {
    Name = "LicenseKey", BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15, 0), Size = UDim2.new(1, -100, 1, 0),
    Text = "", PlaceholderText = "Paste your key here",
    TextColor3 = colors.text, PlaceholderColor3 = colors.muted,
    Font = Enum.Font.Gotham, TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false, MultiLine = false,
}, inputShell)
local paste = make("TextButton", {
    Name = "Paste", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.12,
    Text = "Paste", TextColor3 = colors.cyan, Font = Enum.Font.GothamBold,
    TextSize = 13, BorderSizePixel = 0,
    Position = UDim2.new(1, -79, 0, 4), Size = UDim2.fromOffset(75, 40),
    AutoButtonColor = false,
}, inputShell)
round(paste, 7)
local function button(name, caption, y, primary)
    local object = make("TextButton", {
        Name = name, BackgroundColor3 = primary and Color3.fromRGB(255, 255, 255) or colors.navy,
        BackgroundTransparency = primary and 0 or 0.3, BorderSizePixel = 0,
        Position = UDim2.fromOffset(28, y), Size = UDim2.new(1, -56, 0, 48),
        Text = caption, TextColor3 = primary and colors.navy or colors.text,
        Font = Enum.Font.GothamBold, TextSize = 18, AutoButtonColor = false,
    }, body)
    round(object, 9)
    stroke(object, primary and colors.cyan or colors.lavender, primary and 0.15 or 0.3)
    if primary then
        make("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(62, 216, 243), colors.cyan), Rotation = 90}, object)
    end
    bind(object.MouseEnter, function() animate(object, 0.12, {BackgroundTransparency = primary and 0.08 or 0.08}) end)
    bind(object.MouseLeave, function() animate(object, 0.12, {BackgroundTransparency = primary and 0 or 0.3}) end)
    return object
end
-- One action row keeps the complete key gate visible in phone landscape.
local verify = button("Verify", "Verify key  →", 170, true)
verify.Size = UDim2.new(0.64, -36, 0, 48)
local getKey = button("GetKey", "Get a key", 170, false)
getKey.Position = UDim2.new(0.64, 4, 0, 170)
getKey.Size = UDim2.new(0.36, -32, 0, 48)
local statusDot = make("Frame", {
    BackgroundColor3 = colors.muted, BorderSizePixel = 0,
    Position = UDim2.fromOffset(28, 242), Size = UDim2.fromOffset(7, 7),
}, body)
round(statusDot, 7)
local statusLabel = text(body, "Ready to verify", 13, UDim2.fromOffset(44, 228), UDim2.new(1, -72, 0, 30), colors.muted)
statusLabel.TextWrapped = true

local footer = make("Frame", {
    Name = "Footer", BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 1, -64), Size = UDim2.new(1, 0, 0, 64),
}, panel)
make("Frame", {
    BackgroundColor3 = colors.muted, BackgroundTransparency = 0.85,
    Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -48, 0, 1), BorderSizePixel = 0,
}, footer)
text(footer, "Do you need help?", 14, UDim2.fromOffset(28, 8), UDim2.new(1, -190, 0, 22), colors.text, true)
text(footer, "Keys, updates & premium support.", 12, UDim2.fromOffset(28, 31), UDim2.new(1, -190, 0, 22), colors.muted)
local discord = make("TextButton", {
    Name = "Discord", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.25, Text = "Join Discord  →",
    TextColor3 = colors.cyan, TextSize = 13, Font = Enum.Font.Gotham,
    Position = UDim2.new(1, -152, 0, 10), Size = UDim2.fromOffset(124, 44),
    TextXAlignment = Enum.TextXAlignment.Center, AutoButtonColor = false,
}, footer)
round(discord, 9)
local discordOutline = stroke(discord, colors.cyan, 0.55)
bind(discord.MouseEnter, function()
    animate(discord, 0.14, {BackgroundTransparency = 0})
    animate(discordOutline, 0.14, {Transparency = 0.15})
end)
bind(discord.MouseLeave, function()
    animate(discord, 0.14, {BackgroundTransparency = 0.25})
    animate(discordOutline, 0.14, {Transparency = 0.55})
end)

function controller:SetStatus(message, kind)
    if destroyed then return end
    local color = kind == "error" and colors.error or colors.muted
    statusLabel.Text = message
    statusLabel.TextColor3 = color
    statusDot.BackgroundColor3 = color
    -- Feedback always occupies the same row; text never resizes the window.

end
function controller:Resize()
    if destroyed then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    -- Mobile devices can report keyboard support even without a physical one.
    local mobile = UserInputService.TouchEnabled
    local naturalHeight = 380
    local availableWidth = math.max(1, dimensions.X - 32)
    local availableHeight = math.max(1, dimensions.Y - 32)
    local targetWidth = 460
    if mobile then
        targetWidth = 420
        availableWidth = math.min(availableWidth, dimensions.X * 0.70)
        availableHeight = math.min(availableHeight, dimensions.Y * 0.84)
    end
    local inheritedScale = scaleProbe.AbsoluteSize.X / 100
    if inheritedScale <= 0 then inheritedScale = 1 end
    -- Fit the entire form on both axes. No shortened body and no scrolling.
    local fittedScale = math.min(targetWidth / 552, availableWidth / 552, availableHeight / naturalHeight)
    panel.Size = UDim2.fromOffset(552, naturalHeight)
    scaling.Scale = fittedScale / inheritedScale
    self:ClampPosition()
end
-- The header moves the complete window with mouse or a single touch.
-- Normalized positions account for inherited scaling and keep the close button reachable.
function controller:ClampPosition()
    if destroyed then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    local inheritedScale = math.max(0.001, scaleProbe.AbsoluteSize.X / 100)
    local width = panel.Size.X.Offset * scaling.Scale * inheritedScale
    local height = panel.Size.Y.Offset * scaling.Scale * inheritedScale
    local x = panel.Position.X.Scale * dimensions.X + panel.Position.X.Offset * inheritedScale
    local y = panel.Position.Y.Scale * dimensions.Y + panel.Position.Y.Offset * inheritedScale
    local lowX, highX = width / 2 + 12, dimensions.X - width / 2 - 12
    local lowY, highY = height / 2 + 12, dimensions.Y - height / 2 - 12
    x = lowX <= highX and math.max(lowX, math.min(highX, x)) or dimensions.X / 2
    y = lowY <= highY and math.max(lowY, math.min(highY, y)) or dimensions.Y / 2
    panel.Position = UDim2.fromScale(x / dimensions.X, y / dimensions.Y)
end
local dragHandle = make("TextButton", {
    Name = "DragHandle", BackgroundTransparency = 1, Text = "",
    Size = UDim2.new(1, -64, 1, 0), Active = true,
    AutoButtonColor = false, ZIndex = 3,
}, header)
close.ZIndex = 4
local drag = nil
bind(dragHandle.InputBegan, function(event)
    if closing or destroyed then return end
    local kind = event.UserInputType
    if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
    drag = {
        Input = event, Kind = kind, X = event.Position.X, Y = event.Position.Y,
        Position = panel.Position,
    }
end)
bind(UserInputService.InputChanged, function(event)
    if not drag or closing or destroyed then return end
    local movement = drag.Kind == Enum.UserInputType.Touch and event == drag.Input
        or drag.Kind == Enum.UserInputType.MouseButton1 and event.UserInputType == Enum.UserInputType.MouseMovement
    if not movement then return end
    local dimensions = viewport.AbsoluteSize
    if dimensions.X <= 0 or dimensions.Y <= 0 then return end
    panel.Position = UDim2.fromScale(
        drag.Position.X.Scale + (event.Position.X - drag.X) / dimensions.X,
        drag.Position.Y.Scale + (event.Position.Y - drag.Y) / dimensions.Y
    )
    controller:ClampPosition()
end)
bind(UserInputService.InputEnded, function(event)
    if drag and (event == drag.Input or event.UserInputType == drag.Kind) then drag = nil end
end)
function controller:Destroy()
    if destroyed then return end
    destroyed = true
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, tween in pairs(tweens) do tween:Cancel() end
    gui:Destroy()
    if environment.__SerenityKeyWindowTest == self then environment.__SerenityKeyWindowTest = nil end
end
local function submit()
    if destroyed or closing then return end
    local key = input.Text:match("^%s*(.-)%s*$") or ""
    if key == "" then
        controller:SetStatus("Enter a key first.", "error")
        input:CaptureFocus()
        return
    end
    -- No key is logged, saved, sent, or accepted by this visual-only build.
    controller:SetStatus("UI test only. Authentication is not connected yet.", "info")
end
bind(verify.Activated, submit)
bind(input.FocusLost, function(enterPressed) if enterPressed then submit() end end)
bind(input.Focused, function() animate(inputEdge, 0.12, {Color = colors.cyan, Transparency = 0.12}) end)
bind(input.FocusLost, function() animate(inputEdge, 0.12, {Color = colors.muted, Transparency = 0.52}) end)
bind(paste.Activated, function()
    local readClipboard = environment.getclipboard or getclipboard
    if type(readClipboard) ~= "function" then
        controller:SetStatus("Paste into the key field using your device keyboard.", "info")
        input:CaptureFocus()
        return
    end
    local ok, value = pcall(readClipboard)
    if ok and type(value) == "string" then
        input.Text = value:gsub("[\r\n]", ""):sub(1, 512)
        controller:SetStatus("Ready to verify", "info")
    else
        controller:SetStatus("Clipboard unavailable. Paste into the key field.", "error")
    end
end)
local providers = make("CanvasGroup", {
    Name = "Providers", BackgroundTransparency = 1, BorderSizePixel = 0,
    GroupTransparency = 1, GroupColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 1, -120),
    Visible = false, ClipsDescendants = false,
}, panel)
local back = make("TextButton", {
    Name = "Back", BackgroundColor3 = colors.glass, BackgroundTransparency = 0.35,
    Position = UDim2.fromOffset(28, 10), Size = UDim2.fromOffset(38, 38),
    Text = "←", TextSize = 24, Font = Enum.Font.Gotham,
    TextColor3 = colors.text, AutoButtonColor = false, BorderSizePixel = 0,
}, providers)
round(back, 8)
stroke(back, colors.muted, 0.7)
text(providers, "Get your key", 24, UDim2.fromOffset(80, 10), UDim2.new(1, -108, 0, 32), colors.text, true)
text(providers, "Choose a service to continue.", 15, UDim2.fromOffset(80, 43), UDim2.new(1, -108, 0, 24), colors.muted)
local providerFeedback = text(providers, "", 12, UDim2.fromOffset(28, 240), UDim2.new(1, -56, 0, 18), colors.muted)
local providerLinks = {}
function controller:SetProviderLinks(links)
    if type(links) ~= "table" then return end
    for _, name in ipairs({"Linkvertise", "LootLabs", "Work.ink"}) do
        local url = links[name]
        providerLinks[name] = type(url) == "string" and url:match("^https://") and url or nil
    end
end
controller:SetProviderLinks(environment.__SerenityKeyLinks)
for index, name in ipairs({"Linkvertise", "LootLabs", "Work.ink"}) do
    local option = make("TextButton", {
        Name = name, BackgroundColor3 = colors.glass, BackgroundTransparency = 0.2,
        Position = UDim2.fromOffset(28, 82 + (index - 1) * 54),
        Size = UDim2.new(1, -56, 0, 48), BorderSizePixel = 0,
        Text = "", AutoButtonColor = false,
    }, providers)
    round(option, 9)
    stroke(option, colors.muted, 0.6)
    local mark = make("TextLabel", {
        BackgroundColor3 = colors.cyan, BackgroundTransparency = 0.84,
        Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(28, 28),
        Text = name:sub(1, 1), Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = colors.cyan, BorderSizePixel = 0,
    }, option)
    round(mark, 7)
    text(option, name, 17, UDim2.fromOffset(54, 0), UDim2.new(1, -102, 1, 0), colors.text, true)
    text(option, "→", 22, UDim2.new(1, -40, 0, 0), UDim2.fromOffset(28, 48), colors.muted)
    bind(option.MouseEnter, function() animate(option, 0.12, {BackgroundTransparency = 0}) end)
    bind(option.MouseLeave, function() animate(option, 0.12, {BackgroundTransparency = 0.2}) end)
    bind(option.Activated, function()
        if destroyed or closing then return end
        local url = providerLinks[name]
        if not url then
            providerFeedback.Text = name .. " link is not configured yet."
            return
        end
        local copy = environment.setclipboard or setclipboard or toclipboard
        local ok = type(copy) == "function" and pcall(copy, url)
        providerFeedback.Text = ok and (name .. " link copied. Open it in your browser.") or "Clipboard unavailable on this device."
    end)
end
local showingProviders, switching = false, false
local function switchView(show)
    if destroyed or closing or switching or showingProviders == show then return end
    switching = true
    showingProviders = show
    input:ReleaseFocus()
    local incoming = show and providers or body
    local outgoing = show and body or providers
    local direction = show and 1 or -1
    incoming.Position = UDim2.fromOffset(22 * direction, 56)
    incoming.GroupTransparency = 1
    incoming.Visible = true
    animate(outgoing, 0.16, {GroupTransparency = 1, Position = UDim2.fromOffset(-22 * direction, 56)})
    animate(incoming, 0.20, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 56)})
    task.delay(0.21, function()
        if destroyed then return end
        outgoing.Visible = false
        switching = false
    end)
end
bind(getKey.Activated, function() providerFeedback.Text = ""; switchView(true) end)
bind(back.Activated, function() switchView(false) end)
-- Modal stays inside the fitted window, so every action remains visible on mobile.
local discordInvite = "https://discord.gg/pWPs7428wE"
local discordModal = make("CanvasGroup", {
    Name = "DiscordPopup", BackgroundTransparency = 1, GroupColor3 = Color3.fromRGB(255, 255, 255),
    GroupTransparency = 1, Visible = false, Size = UDim2.fromScale(1, 1), ZIndex = 20,
}, panel)
local dismiss = make("TextButton", {
    Name = "DiscordBackdrop", Text = "", AutoButtonColor = false,
    BackgroundColor3 = colors.navy, BackgroundTransparency = 0.12,
    Size = UDim2.fromScale(1, 1), ZIndex = 1,
}, discordModal)
local card = make("Frame", {
    Name = "DiscordCard", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(452, 264),
    BackgroundColor3 = colors.glass, BorderSizePixel = 0, ZIndex = 2,
}, discordModal)
round(card, 14)
stroke(card, colors.lavender, 0.35)
local community = text(card, "SERENITY COMMUNITY", 12, UDim2.fromOffset(24, 16), UDim2.fromOffset(350, 22), colors.cyan, true)
text(card, "Join Serenity Hub", 24, UDim2.fromOffset(24, 42), UDim2.fromOffset(380, 32), colors.text, true)
text(card, "Help with keys, updates and premium.", 14, UDim2.fromOffset(24, 80), UDim2.fromOffset(400, 24), colors.muted)
local popupClose = make("TextButton", {
    Name = "DiscordClose", Text = "×", TextSize = 24, TextColor3 = colors.muted,
    Font = Enum.Font.Gotham, BackgroundTransparency = 1, AutoButtonColor = false,
    Position = UDim2.new(1, -48, 0, 8), Size = UDim2.fromOffset(40, 40),
}, card)
local inviteField = make("TextBox", {
    Name = "DiscordInvite", Text = discordInvite, TextEditable = false, ClearTextOnFocus = false,
    TextColor3 = colors.text, TextSize = 16, Font = Enum.Font.Gotham,
    BackgroundColor3 = colors.navy, BackgroundTransparency = 0.2,
    Position = UDim2.fromOffset(24, 116), Size = UDim2.fromOffset(404, 44),
}, card)
round(inviteField, 8)
stroke(inviteField, colors.muted, 0.65)
local copyInvite = make("TextButton", {
    Name = "CopyDiscordInvite", Text = "Copy invite  →", TextSize = 16,
    Font = Enum.Font.GothamBold, TextColor3 = colors.navy,
    BackgroundColor3 = colors.cyan, AutoButtonColor = false,
    Position = UDim2.fromOffset(24, 174), Size = UDim2.fromOffset(404, 44),
}, card)
round(copyInvite, 8)
local inviteFeedback = text(card, "Copy the invite, then open it in your browser.", 12,
    UDim2.fromOffset(24, 228), UDim2.fromOffset(404, 22), colors.muted)
inviteFeedback.Name = "DiscordFeedback"
local popupOpen, popupGeneration = false, 0
local function setDiscordPopup(open)
    if destroyed or closing or popupOpen == open then return end
    popupOpen = open
    popupGeneration = popupGeneration + 1
    local generation = popupGeneration
    input:ReleaseFocus()
    inviteField:ReleaseFocus()
    if open then
        copyInvite.Text = "Copy invite  →"
        inviteFeedback.Text = "Copy the invite, then open it in your browser."
        discordModal.Visible = true
        discordModal.GroupTransparency = 1
        card.Position = UDim2.new(0.5, 0, 0.5, 18)
        animate(discordModal, 0.20, {GroupTransparency = 0})
        animate(card, 0.24, {Position = UDim2.fromScale(0.5, 0.5)})
    else
        animate(discordModal, 0.16, {GroupTransparency = 1})
        animate(card, 0.16, {Position = UDim2.new(0.5, 0, 0.5, 12)})
        task.delay(0.17, function()
            if not destroyed and popupGeneration == generation and not popupOpen then discordModal.Visible = false end
        end)
    end
end
bind(discord.Activated, function() setDiscordPopup(true) end)
bind(popupClose.Activated, function() setDiscordPopup(false) end)
bind(dismiss.Activated, function() setDiscordPopup(false) end)
bind(copyInvite.MouseEnter, function() animate(copyInvite, 0.12, {BackgroundTransparency = 0.18}) end)
bind(copyInvite.MouseLeave, function() animate(copyInvite, 0.12, {BackgroundTransparency = 0}) end)
bind(copyInvite.Activated, function()
    if destroyed or closing or not popupOpen then return end
    local copy = environment.setclipboard or setclipboard or toclipboard
    local ok = type(copy) == "function" and pcall(copy, discordInvite)
    copyInvite.Text = ok and "Invite copied  ✓" or "Select invite above"
    inviteFeedback.Text = ok and "You're ready! Paste the invite in your browser." or "Hold or select the invite above to copy it manually."
    if not ok then inviteField:CaptureFocus() end
    animate(copyInvite, 0.12, {BackgroundTransparency = 0})
end)
bind(close.Activated, function()
    if closing then return end
    closing = true
    input:ReleaseFocus()
    animate(panel, 0.16, {GroupTransparency = 1})
    task.delay(0.18, function() controller:Destroy() end)
end)
bind(viewport:GetPropertyChangedSignal("AbsoluteSize"), function() controller:Resize() end)
bind(scaleProbe:GetPropertyChangedSignal("AbsoluteSize"), function() controller:Resize() end)
controller.Gui = gui
controller.Input = input
controller.IsPreview = true
controller.FlowAuthLoader = "https://flowauth.net/v1/loaders/1648c904082188891affedeaf4cf550d.lua"
environment.__SerenityKeyWindowTest = controller
controller:Resize()
animate(panel, 0.22, {GroupTransparency = 0})
return controller
