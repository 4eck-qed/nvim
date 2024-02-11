-- Contains basic functionality for global use

--- Sends a notification
---@param title string title of the notification window
---@param msg string message of the notification
---@param level any vim.log.levels
---@param dur integer timeout in ms
function notify_async(title, msg, level, dur)
    local async = require("plenary.async")
    local status, notify = pcall(require, "notify")
    if not status then
        return
    end

    async.run(function()
        notify.async(msg, level, {
            title = title,
            timeout = dur
        })
    end)
end

--- Pads string to the left with given char for given length
---@param str string
---@param len integer
---@param char string
---@return string
function lpad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str
end

--- Pads string to the right with given char for given length
---@param str string
---@param len integer
---@param char string
---@return string
function rpad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

--- Pads string with given char for given length
---@param str string
---@param len integer
---@param char string
---@return string
function pad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    local total_rep = len - #str
    local l_rep = math.floor(total_rep / 2)
    local r_rep = total_rep - l_rep
    return string.rep(char, l_rep) .. str .. string.rep(char, r_rep)
end

--- Returns the length of any table
---@param tbl table
---@return integer
function len(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end
