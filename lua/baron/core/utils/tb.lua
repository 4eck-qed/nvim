local tb = {}

--- Merges two tables and returns the result
---@param tb1 table
---@param tb2 table
function tb.merge(tb1, tb2)
    local result = {}

    for _, v in ipairs(tb1) do
        table.insert(result, v)
    end

    for _, v in ipairs(tb2) do
        table.insert(result, v)
    end

    return result
end

--- Checks if table contains item
---@param tb table
---@param item any
function tb.contains(tb, item)
    for _, v in ipairs(tb) do
        if v == item then
            return true
        end
    end

    return false
end

return tb
