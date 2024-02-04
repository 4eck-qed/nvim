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

function lpad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str
end

function rpad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

function pad(str, len, char)
    if str == nil then str = "nil" end
    if char == nil then char = ' ' end
    total_rep = len - #str
    l_rep = math.floor(total_rep / 2)
    r_rep = total_rep - l_rep
    return string.rep(char, l_rep) .. str .. string.rep(char, r_rep)
end

function len(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end

    return count
end
