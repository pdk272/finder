--[[
    📡 TITAN BOT: SERVER SCANNER & HOPPER
    - Chạy trên Acc Phụ. 
    - Nhiệm vụ: Quét Pet rớt dưới đất (Workspace) -> Báo Webhook -> Hop Server
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- ================= CẤU HÌNH CỦA ÔNG =================
-- Dán cái Link Discord Webhook vào trong cặp ngoặc kép
local WEBHOOK_URL = "https://discord.com/api/webhooks/1501273736580567132/8eMKz7k1UtE1F_3zcE2zOiO750wRM3umAYEZEjWsxAspbt16PnxmI4Mp-xSc7nVWlwk6"

-- Ghi tên những con Pet ông muốn tìm (Ghi chữ thường cho chuẩn)
local PETS_TO_FIND = {
    "garama",
    "chic",
    "chihuanini taconini"
}
-- ====================================================

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LPlr = game:GetService("Players").LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

-- HÀM GỬI MẬT BÁO VỀ DISCORD
local function SendWebhook(petName)
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "🚨 PHÁT HIỆN PET VIP!",
            ["description"] = "**Pet:** `" .. petName .. "`\n**Mã Server (JobId):**\n```" .. JobId .. "
```\n*Copy mã trên dán vào Gui Finder Brainrot để Join.*",
            ["color"] = tonumber("0x00FFFF") -- Màu Cyan
        }}
    }
    
    -- Gửi gói tin lên Discord (Dùng syn.request hoặc request tùy Executor)
    local req = (syn and syn.request) or request or http_request
    if req then
        req({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- HÀM SERVER HOP (CHUYỂN SERVER LIÊN TỤC)
local function ServerHop()
    print("Đang tìm Server mới...")
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Desc&limit=100")).data
    for _, s in pairs(servers) do
        -- Tìm server chưa đầy và không phải server hiện tại
        if s.playing < s.maxPlayers and s.id ~= JobId then
            TeleportService:TeleportToPlaceInstance(PlaceId, s.id, LPlr)
            task.wait(5) -- Đợi nó bay qua
        end
    end
end

-- ================= LOGIC QUÉT =================
task.spawn(function()
    print("Bắt đầu quét Server...")
    task.wait(3) -- Đợi map load xong một chút
    
    local found = false
    -- Quét toàn bộ đồ vật trong game
    for _, item in pairs(workspace:GetDescendants()) do
        -- Nếu tìm thấy Model hoặc Part
        if item:IsA("Model") or item:IsA("BasePart") then
            -- Check xem tên item có khớp với danh sách VIP không
            for _, vipPet in pairs(PETS_TO_FIND) do
                if item.Name:lower():find(vipPet) then
                    print("TÌM THẤY: " .. item.Name)
                    SendWebhook(item.Name)
                    found = true
                    task.wait(2) -- Dừng lại xíu để gửi Webhook
                    break
                end
            end
        end
        if found then break end -- Đã thấy 1 con thì báo cáo rồi nhảy luôn
    end

    if not found then
        print("Server này rác, đang nhảy...")
    end
    
    -- Dù thấy hay không thấy cũng nhảy sang Server khác quét tiếp
    ServerHop()
end)
