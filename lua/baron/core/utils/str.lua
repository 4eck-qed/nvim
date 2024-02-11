local str = {}

--- Limits the string to given length adding an ellipsis if the string is longer then limit
---@param s string
---@param len integer
---@return string
function str.limit(s, len)
    if #s > len then
        return string.sub(s, 1, len - 3) .. "..."
    end

    return s
end

return str
