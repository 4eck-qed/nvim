local fn = {}

--- Calls given function for each argument
---@param f function
---@param args any
function fn.call_each(f, args)
    for _, v in ipairs(args) do
        f(v)
    end
end

return fn
