local str = {}

--- Limits the string to given length adding an ellipsis if the string is longer then limit
---@param str string
---@param len int
---@return string limited
function str.limit(str, len)
    if #str > len then
        return string.sub(str, 1, len - 3) .. "..."
    end

    return str
end

return str
