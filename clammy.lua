--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

addon.author   = 'Sanserof'
addon.name     = 'Clammy'
addon.desc     = 'Clamming calculator: displays bucket weight, items in bucket, & approximate value.'
addon.version  = '1.0'

require('common')
local itemlist = require('itemlist')
local imgui = require('imgui')
local settings = require('settings')

local clammingItems = itemlist.clammingItems

-- Weight threshold colors for bucket fullness warning
local weightColor = {
    { diff = 200, color = {1.0, 1.0, 1.0, 1.0} },
    { diff = 35,  color = {1.0, 1.0, 0.8, 1.0} },
    { diff = 20,  color = {1.0, 1.0, 0.4, 1.0} },
    { diff = 11,  color = {1.0, 1.0, 0.0, 1.0} },
    { diff = 7,   color = {1.0, 0.6, 0.0, 1.0} },
    { diff = 6,   color = {1.0, 0.4, 0.0, 1.0} },
    { diff = 3,   color = {1.0, 0.3, 0.0, 1.0} },
}

local bucketColor = {1.0, 1.0, 1.0, 1.0}

local defaultConfig = T{
    showItems = true,
    showValue = true,
    log = false,
    tone = false,
}

local config = settings.load(defaultConfig)

-- Session tracking
local sessionTotal   = 0        -- Total gil profit after bucket costs
local bucketsEmptied = 0        -- Number of buckets turned in this session

-- Current bucket state
local bucketSize = 50
local weight     = 0
local money      = 0            -- Estimated value of current bucket (using best sell method)
local bucket     = {}           -- Count of each item type in current bucket
local cooldown   = 0            -- Cooldown timer after finding an item

-- Logging setup
local fileName = ('log_%s.txt'):fmt(os.date('%Y_%m_%d__%H_%M_%S'))
local fileDir  = ('%s\\addons\\Clammy\\logs\\'):fmt(AshitaCore:GetInstallPath())
local filePath = fileDir .. fileName
local playTone = false

-- Reset current bucket and update session stats
local function emptyBucket()
    sessionTotal   = sessionTotal + money - 500
    bucketsEmptied = bucketsEmptied + 1
    
    bucketSize = 50
    weight     = 0
    money      = 0  

    for idx in ipairs(clammingItems) do
        bucket[idx] = 0
    end
end

-- Play alert sound when bucket is ready
function playSound()
    if config.tone == true and playTone == true then
        ashita.misc.play_sound(addon.path:append("clam.wav"))
        playTone = false
    end
end

-- Print list of AH items to chat, reminder so you don't NPC the wrong items
local function printAHItems()
    print("Clammy: AH items:")
    for _, item in ipairs(clammingItems) do
        if item.sell_to == "AH" then
            print("  " .. item.item)
        end
    end
end

function openLogFile()
    if ashita.fs.create_directory(fileDir) ~= false then
        file = io.open(filePath, 'a')
        if file == nil then
            print("Clammy: Could not open log file.")
        else
            return file
        end
    end
end

function closeLogFile(file)
    if file ~= nil then io.close(file) end
end

function writeLogFile(item)
    local file = openLogFile()
    if file ~= nil then
        local fdata = ('%s, %s\n'):fmt(os.date('%Y-%m-%d %H:%M:%S'), item)
        file:write(fdata)
    end
    closeLogFile(file)
end

-- Initial reset on addon load
ashita.events.register('load', 'load_cb', function()
    emptyBucket()
    sessionTotal   = 0
    bucketsEmptied = 0 
end)

ashita.events.register('unload', 'unload_cb', function() end)

-- Command handler
ashita.events.register('command', 'command_cb', function(e)
    local args = e.command:args()
    if #args == 0 or not args[1]:any('/clammy') then return end
    e.blocked = true

    if #args == 2 and args[2]:any('reset') then
        emptyBucket()  
        sessionTotal   = 0
        bucketsEmptied = 0
        print("Clammy: Session reset.")
        return
    end

    if #args >= 2 and args[2]:any('ahlist', 'ah', 'listah') then
        printAHItems()
        return
    end

    if #args >= 2 and args[2]:any('lookup', 'look', 'price', 'item') then
        if #args < 3 then
            print("Clammy: Usage: /clammy lookup <item name>")
            print("Example: /clammy lookup oxblood")
            return
        end
        
        -- Get search term (everything after 'lookup')
        local search = ""
        for i = 3, #args do
            search = search .. " " .. args[i]:lower()
        end
        search = search:trim():lower()

        local found = false
        for _, item in ipairs(itemlist.clammingItems) do
            local itemNameLower = item.item:lower()
            if itemNameLower:find(search, 1, true) then  -- partial match
                print(string.format(
                    "Clammy: %s | NPC: %d gil | AH: %d gil | Sell to: %s",
                    item.item,
                    item.npc_gil,
                    item.ah_gil,
                    item.sell_to
                ))
                found = true
                -- Don't break — show all partial matches if multiple
            end
        end

        if not found then
            print("Clammy: No matching item found for '" .. search .. "'")
            print("Try a more specific name or check spelling.")
        end
        
        return
    end

end)

-- Parse incoming chat for clamming messages
ashita.events.register('text_in', 'Clammy_HandleText', function(e)
    if e.injected then return end

    if string.match(e.message, "You return the") or
       string.match(e.message, "All your shellfish are washed back into the sea") then
        emptyBucket()
        bucketColor = {1.0, 1.0, 1.0, 1.0}
        return
    end

    if string.match(e.message, "Your clamming capacity has increased to") then
        bucketSize = bucketSize + 50
        bucketColor = {1.0, 1.0, 1.0, 1.0}
        return
    end

    if string.match(e.message, "You find a") then
        for idx, citem in ipairs(clammingItems) do
            if string.match(string.lower(e.message), string.lower(citem.item)) then
                weight = weight + citem.weight

                local chosen_gil = 0
                if     citem.sell_to == "AH"   then chosen_gil = citem.ah_gil
                elseif citem.sell_to == "NPC"  then chosen_gil = citem.npc_gil
                else                                chosen_gil = 0 end

                money = money + chosen_gil
                bucket[idx] = bucket[idx] + 1
                cooldown = os.clock() + 10.5

                for _, wc in ipairs(weightColor) do
                    if (bucketSize - weight) < wc.diff then
                        bucketColor = wc.color
                    end
                end

                playTone = true
                if config.log then writeLogFile(citem.item) end
            end
        end
    end
end)

-- Main UI render loop
ashita.events.register('d3d_present', 'present_cb', function()
    local player = GetPlayerEntity()
    if not player then return end

    local windowSize = 300
    imgui.SetNextWindowBgAlpha(0.8)
    imgui.SetNextWindowSize({windowSize, -1}, ImGuiCond_Always)

    if imgui.Begin('Clammy', true, bit.bor(ImGuiWindowFlags_NoDecoration)) then

        -- Legend + session stats (compact line)
        imgui.TextColored({0.2,0.9,0.3,1.0}, "AH")   imgui.SameLine()
        imgui.TextColored({1.0,0.8,0.1,1.0}, " NPC") imgui.SameLine()
        imgui.TextColored({0.70,0.70,0.70,1.0}, " Trash")
        imgui.SameLine()
        imgui.Text("  |  ")
        imgui.SameLine()
        imgui.Text("Total: " .. sessionTotal .. "g")
        imgui.SameLine()
        imgui.Text("(" .. bucketsEmptied .. ")")

        imgui.Separator()

        -- Bucket weight display
        imgui.Text("Bucket Weight [" .. bucketSize .. "]:")
        imgui.SameLine()
        imgui.SetWindowFontScale(1.3)
        imgui.SetCursorPosY(imgui.GetCursorPosY() - 2)
        imgui.TextColored(bucketColor, tostring(weight))
        imgui.SetWindowFontScale(1.0)
        imgui.SameLine()
        imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - imgui.GetStyle().FramePadding.x - imgui.CalcTextSize("[999]"))

        local cdTime = math.floor(cooldown - os.clock())
        if cdTime <= 0 then
            imgui.TextColored({0.5, 1.0, 0.5, 1.0}, "  [*]")
            playSound()
        else
            imgui.TextColored({1.0, 1.0, 0.5, 1.0}, "  [" .. cdTime .. "]")
        end

        -- Current bucket value
        if config.showValue then
            imgui.Text("Estimated Value: " .. money .. "g")
        end

        -- Item list with color coding
        if config.showItems then
            imgui.Separator()
            for idx, citem in ipairs(clammingItems) do
                if bucket[idx] > 0 then
                    local count = bucket[idx]
                    local val   = 0
                    local color = {0.70, 0.70, 0.70, 1.0}  

                    if citem.sell_to == "AH" then
                        val   = citem.ah_gil * count
                        color = {0.2, 0.9, 0.3, 1.0}        
                    elseif citem.sell_to == "NPC" then
                        val   = citem.npc_gil * count
                        color = {1.0, 0.8, 0.1, 1.0}       
                    else
                        val   = 0
                        color = {0.7, 0.7, 0.7, 1.0}        
                    end

                    imgui.TextColored(color, " - " .. citem.item .. " [" .. count .. "]")
                    imgui.SameLine()
                    local valTxt = "(" .. val .. "g)"
                    local x, _ = imgui.CalcTextSize(valTxt)
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - x - imgui.GetStyle().FramePadding.x)
                    imgui.TextColored(color, valTxt)
                end
            end
        end
    end

    imgui.End()
end)
